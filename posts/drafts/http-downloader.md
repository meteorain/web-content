---
id: eHK
title: '记一次http文件下载踩坑'
pubDate: 2020-08-10T05:58:11.000Z
isDraft: true
tags: ['golang']
categories: ['笔记']
---

前段时间碰到这么个需求，需要一个下载器同步两台服务器上的数据，数据在几小时的周期内更新，因为前期系统设计的不足，数据存储端和应用端的文件目录结构存在差异，也就没法使用通用软件来完成同步。

我来临时抗雷，因为同步周期和文件目录还有可能再变动，所以甲方希望这个下载器可以支持外置的配置文件来修改配置。

我首先想到之前了解过的golang的cobra和viper。可以快速构建个cli应用，也支持外置配置文件，于是决定用golang写业务。

程序的逻辑其实很简单，存储端使用IIS发布文件服务，在应用端定时请求，若有新的数据则同步。

关于如何获取文件的更新日期，我首先想根据文件名中包含的时间信息来判断，后来被告知相同文件名的文件有预测和实测数据之分，之前的预测数据会被实测数据覆盖，而文件名不会变化。于是只能打倒重做。

好在默认的IIS文件目录页有文件修改时间的信息，于是便想爬取网页来获取文件修改时间在期望区间的数据。

```go
	var files map[string]string
	var f func(*html.Node)
	f = func(n *html.Node) {
		if n.Type == html.ElementNode && n.Data == "a" {

			for _, a := range n.Attr {
				if a.Key == "href" {
					if !strings.HasSuffix(a.Val, "txt") {
						break
					}
					//解析日期
					day := fmt.Sprintf("%s %s", strings.Fields(strings.TrimSpace(n.PrevSibling.Data))[0], strings.Fields(strings.TrimSpace(n.PrevSibling.Data))[1])
					//文件URL地址
					href := a.Val

					if day == "" {
						continue
					}
					if v, ok := files[day]; ok {
						files[day] = append(v, href)
					} else {
						files[day] = []string{href}
					}
					break
				}
			}
		}
		for c := n.FirstChild; c != nil; c = c.NextSibling {
			f(c)
		}
	}
	f(doc)
```

以上通过爬取IIS文件目录界面，完成了对相同日期更新的文件进行了分组，保存在一个map中。之后只需将期望日期内的数据下载至本地即可，过程中并未判断文件是否更新，在期望日期内修改的文件都将重新下载一遍。

之后就是通过http.Client完成请求，将文件保存到本地。

```go
func download(url, save string) (string, error) {


	client := http.Client{}
	// Get the data
	startTime := time.Now().UnixNano()

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		fmt.Errorf("")
	}

	resp, err := client.Do(req)
	// resp, err := Client.Get(url)
	if err != nil {
		//panic(err)
		return "", fmt.Errorf("%s", err)
	}
	defer resp.Body.Close()

	// 创建一个文件用于保存
	err = os.MkdirAll(filepath.Dir(save), os.ModePerm)
	if err != nil {

	}
	out, err := os.Create(save)
	if err != nil {
		return "", fmt.Errorf("%s", err)
	}
	defer out.Close()

	// 然后将响应流和文件流对接起来
	_, err = io.Copy(out, resp.Body)
	if err != nil {
		return "", fmt.Errorf("%s", err)
	}
	endTime := time.Now().UnixNano()
	duaring := float64(endTime - startTime)
	duaring /= 1e9

	return fmt.Sprintf("%.02fs", duaring), nil

}
```

一开始没有发现问题，甚至都部署了，过了一段时间发现应用部署的机器频繁出现网络故障，无法联网甚至无法远程。左右排查之后发现是文件下载器的问题。

因为更新频率比较频繁，网络请求并没有马上断掉，随着端口占用越来越多，造成了网络连接的各种问题，例如不能访问外网，服务器上其他应用无法访问等。

查了一些资料，发现是没有主动关闭网络连接的问题。

> 一些支持 HTTP1.1 或 HTTP1.0 配置了 connection: keep-alive 选项的服务器会保持一段时间的长连接。但标准库 "net/http" 的连接默认只在服务器主动要求关闭时才断开，所以你的程序可能会消耗完 socket 描述符。解决办法有 2 个，请求结束后：直接设置请求变量的 Close 字段值为 true，每次请求结束后就会主动关闭连接。设置 Header 请求头部选项 Connection: close，然后服务器返回的响应头部也会有这个选项，此时 HTTP 标准库会主动断开连接。[^1]

[^1]: [https://www.imooc.com/article/23959](https://www.imooc.com/article/23959)

```go
func main() {
    req, err := http.NewRequest("GET", "http://golang.org", nil)
    checkError(err)

    req.Close = true
    //req.Header.Add("Connection", "close")    // 等效的关闭方式

    resp, err := http.DefaultClient.Do(req)
    if resp != nil {
        defer resp.Body.Close()
    }
    checkError(err)

    body, err := ioutil.ReadAll(resp.Body)
    checkError(err)

    fmt.Println(string(body))
}
```

之后再做了检测发现端口占用都能在连接完成后自动关闭。
