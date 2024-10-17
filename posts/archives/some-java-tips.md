---
id: arD
title: '一些Java技巧简记'
pubDate: 2019-12-16T08:32:01.000Z
isDraft: true
tags: ['java']
categories: ['笔记']
---

研一到截止研二目前，经手了几个项目，这是一个Java后端过程中遇到的一些问题和解决方案。

### JNA调用C++动态链接库

首先定义模型接口如下：

```java
package ch.yuhang.XModel;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Pointer;

public interface XModel extends Library {
    XModel Instance = (XModel) Native.load(PATH_TO_MODEL_DLL, OSPModel.class);
    Pointer RunModel(String arg1, String arg2, String arg3);
}
```

`PATH_TO_MODEL_DLL`指向dll文件，可加后缀也可以不加。调用方式如下：

```java
OSPModel ospModel = OSPModel.Instance;
Pointer string = XModel.RunModel(arg1, arg2 , arg3 );
```

支持返回结果，dll本身的命令行打印也会生效。

### Java调用命令行阻塞的问题及异常处理

在项目过程中，因为要与其他功能集成，在动态链接库的形式之外，也有直接调用Python脚本和exe的情况，前期遇到了命令行首次可运行，第二次不能正常运行的情况，原因是打印出的内容阻塞了。采用下列方式处理，问题解决：

```java
package ch.yuhang.XModel;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Cmd {
    public static int run(String command,String desc) {
        int re = 10;
        try {
            System.out.println(command);
            Process process = Runtime.getRuntime().exec(command);
            BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line = null;
            while ((line = in.readLine()) != null) {
                System.out.println(line);
            }
            in.close();
            re = process.waitFor();
            if (re == 0) {
                System.out.printf("%s --> success\n",desc);
            } else {
                System.out.printf("%s --> failed\n",desc);
            }
            return re;

        } catch (Exception e) {
            e.printStackTrace();
            return re;
        }

    }
}
```

两个参数，分别是包含命令和参数的字符串，和命令的描述（用于执行情况的打印），`re = process.waitFor();`返回值为`0`表明了任务顺利执行，反之出现异常。

参考自[shendeguang](https://blog.csdn.net/shendeguang/article/details/17854079)博客

### 字符串格式化输出指定参数位置

在格式化输出时，有时候会有重复参数的情况，可用`num$`下列方法指定参数位置。

```java
String format = "Hi ,%s %s,you first name is %1$s";
String message = String.format(format,"yuhang","chen");
```

### Java将Json对象输出成INI配置文件

牵涉到之前的老旧功能，之前的项目采用.NET的方式，其中有的调用需要将配置项写成INI的形式，前端返回的数据是Json格式，这就牵涉到转换的方式，手动的写有点麻烦，于是找到了以下方法完成，大致思路是，遍历Object的字段，然后格式化输出`key`和`value`。

```java
package ch.yuhang.XModel;

import com.google.gson.Gson;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public static boolean writeINI(Object json,String uuid) throws NoSuchMethodException, InvocationTargetException {
        StringBuffer path = new StringBuffer(Path.EVAL_SHEET_TEMP);
        path.append(uuid).append(".ini");

        FileWriter w = null;
        try {
            File file = new File(path.toString());
            file.createNewFile();
            // true表示不覆盖原来的内容，而是加到文件的后面。若要覆盖原来的内容，直接省略这个参数就好
            //System.out.println(path.toString());
            w = new FileWriter(path.toString());

            Gson gson = new Gson();
            String a = gson.toJson(json);
            EvalSheet e = gson.fromJson(a, EvalSheet.class);
            Field[] fields = e.getClass().getDeclaredFields();

            for (Field f:
                    fields) {
                String name = f.getName();
                f.setAccessible(true);
                w.write(String.format("[%s]\n",name));

                try {

                    Object l =  f.get(e);
                    Field[] fsTmp = l.getClass().getDeclaredFields();
                    if (fsTmp.length == 0) {
                        continue;
                    }
                    for (Field f2:
                            fsTmp) {
                        f2.setAccessible(true);
                        String nameTmp = f2.getName();
                        //String typeTmp = f2.getGenericType().toString();
                        Method m = l.getClass().getMethod("get" + nameTmp);
                        String value = (String) m.invoke(l);    //调用getter方法获取属性值
                        if (value != null)
                        {
                            w.write(String.format("%s = %s\n",nameTmp,value));
                        }
                    }

                } catch (IllegalAccessException er ) {
                }
            }
        } catch (IOException ex) {
            ex.printStackTrace();
            return false;
        } finally {
            try {
                w.flush();
                w.close();

            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
        return true;

    }
```
