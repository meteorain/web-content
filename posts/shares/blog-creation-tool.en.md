:::note{.info}
This english version was translated using ChatGPT.
:::

## In Short

Compared to blogging platforms like WordPress, using Git-based/Markdown for managing one's content undoubtedly provides more control and allows for more flexible migration across platforms. However, it also increases the cognitive burden of creating a blog post. Although the `hugo new` command-line tool exists, managing categories and tags still requires manual editing in `fontmatters`.

Previously, a simple tool was attempted using the `fish shell`:

```fish showLineNumbers {1-3} title="functions/blog.fish"
function blog
    cd /dest/to/blog
    set -Ux BLOG_SLUG $argv[2]

    set c $argv[1]
    argparse t/tag -- $argv
    or return

    set md (string split '"' (hugo new posts/$c/$argv[2].md) -f2)
    sed -i '' 5s/\"\"/\"$c\"/ $md
    if set -ql _flag_tag
        sed -i '' 6s/\"\"/\"$argv[3]\"/ $md
    end
    echo $md
    open $md

end
```

The idea was still to create articles using slugs, list existing blog post categories in advance, and complete them with the Tab key, which is more convenient than editing in `frontmatters`.

```shell title="completes/blog.fish"
complete -c blog  -xa "comments  drafts  shares  stories  thoughs  thoughts  translations " -n '__fish_is_first_arg'
```

Recently, the blog was refactored using Astro, adding support for `i18n` and shortlinks. This requires modifying the existing script, but maintaining a `fish` script can be cumbersome. Therefore, the decision was made to refactor using a `node` script.

## New Feature Requirements

-   Interactive command-line tool
-   Translating titles through online translation or using a large language model
-   Automatic generation of shortlinks and slugs based on English titles
-   Obtaining categories and tags from existing blog posts
-   Image management

## Implementation Plan

### Implement an Interactive Command-line Tool

Chosen technology stack:

-   [Inquirer.js](https://www.npmjs.com/package/inquirer)
-   [commander](https://www.npmjs.com/package/commander)

`inquirer` is used for command-line interaction, and `commander` is used for parsing command-line arguments. Initially, consider two commands:

1. `create`: Create a blog post
2. `upload`: Upload images, with an option `--file -f` to determine whether to upload a file or a clipboard image.
3. `activate`: Switch to the currently edited article (similar to managing conda environments)
4. `translate`: Translate a specified article (TODO)

### Implement Automatic Translation of Titles

After experimentation, direct translation yielded poor results. The decision was made to use `openai-3.5-turbo` (Azure). Based on the input title, the script will determine whether it is in Chinese or English and provide the opposite prompt for translation.

```json
{
    "messages": [
        {
            "role": "system",
            "content": "You are a Chinese-English translation assistant. Translate the following blog post title to ${dest}."
        },
        { "role": "user", "content": "${title}" }
    ]
}
```

This way, regardless of whether it is a Chinese or English title, only one input is needed, and the AI handles the rest.

### Implement Automatic Shortlink Generation

Considering that the number of blog posts won't be too large, a three-character case-sensitive alphanumeric code will be used to generate shortlinks. This ensures uniqueness and keeps the shortlink reasonably short. The [short-uuid](https://www.npmjs.com/package/short-uuid) package will be used to generate UUIDs, but only the first three characters will be used. If the generated ID already exists, a new one will be generated.

```javascript
const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
const translator = uuid(chars)
let id = translator.new().slice(0, 3)
while (keyExists(id)) {
    id = translator.new().slice(0, 3)
}
```

Shortlinks will be implemented using Vercel's [redirects](https://vercel.com/docs/concepts/projects/project-configuration#redirect-object-definition). By modifying the `vercel.json` in the root directory and redeploying, the shortlinks will work as intended.

```json
{
    "redirects": [{ "source": "/${id}", "destination": "/posts/${slug}" }]
}
```

### Image Management

Instead of using existing image hosting management tools:

1. They may not perfectly fit the existing workflow.
2. File naming conventions may not align with personal preferences.

An additional step will be taken here. When generating an article, a global environment variable will be stored, allowing image management to operate under the directory generated based on the article's slug.

-   Existing image files will be saved to a specified directory and uploaded to object storage through a command.
-   Clipboard images will first be saved locally using [pngpaste](https://formulae.brew.sh/formula/pngpaste) and then uploaded to object storage.

Finally, the URL of the image will be copied to the clipboard using `pbcopy`, allowing it to be easily pasted into the blog post, as shown below:

```shell
blog upload test-jpeg
URL: https://static.yuhang.ch/blog/blog-creation-tool/test-jpeg.jpeg
```

For a screenshot in the clipboard, with this workflow, only a slug needs to be provided, and the tool takes care of uploading it to the specified directory in object storage and copying the link to the clipboard.

## Conclusion

This blog post is created using this tool.
