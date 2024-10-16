---
title: obsidian
---
## vim ime switch
今天发现之前的 VIM 插件不能用了，应该是Obsidian的版本更新造成的。

换成一个23天前更新的插件解决了问题，叫 [im-control](obsidian://show-plugin?id=vim-im-control)。


## command palette

如何将自己的一行shell 命令直接在 obsidian的command palette中使用？

使用这个插件：[Shell commands](https://publish.obsidian.md/shellcommands/Index) 。可惜不支持fish。


## mdx

提供新建和编辑MDX的能力。[Edit MDX](https://github.com/timppeters/obsidian-edit-mdx)


## image-to-link

自己做的自用小工具。[repo](https://github.com/yuhangch/obsidian-image-to-link)


## obcommand


```editor:follow-link
editor:open-link-in-new-leaf
editor:open-link-in-new-window
workspace:toggle-pin
editor:open-link-in-new-split
editor:focus-top
editor:focus-bottom
editor:focus-left
editor:focus-right
workspace:split-vertical
workspace:split-horizontal
workspace:toggle-stacked-tabs
workspace:edit-file-title
workspace:copy-path
workspace:copy-url
workspace:undo-close-pane
workspace:export-pdf
editor:rename-heading
workspace:open-in-new-window
workspace:move-to-new-window
workspace:next-tab
workspace:goto-tab-1
workspace:goto-tab-2
workspace:goto-tab-3
workspace:goto-tab-4
workspace:goto-tab-5
workspace:goto-tab-6
workspace:goto-tab-7
workspace:goto-tab-8
workspace:goto-last-tab
workspace:previous-tab
workspace:new-tab
workspace:show-trash
obsidian-git:edit-gitignore
obsidian-git:open-git-view
obsidian-git:open-history-view
obsidian-git:open-diff-view
obsidian-git:view-file-on-github
obsidian-git:view-history-on-github
obsidian-git:pull
obsidian-git:fetch
obsidian-git:switch-to-remote-branch
obsidian-git:add-to-gitignore
obsidian-git:push
obsidian-git:backup-and-close
obsidian-git:commit-push-specified-message
obsidian-git:commit
obsidian-git:commit-specified-message
obsidian-git:commit-staged
obsidian-git:commit-amend-staged-specified-message
obsidian-git:commit-staged-specified-message
obsidian-git:push2
obsidian-git:stage-current-file
obsidian-git:unstage-current-file
obsidian-git:edit-remotes
obsidian-git:remove-remote
obsidian-git:set-upstream-branch
obsidian-git:delete-repo
obsidian-git:init-repo
obsidian-git:clone-repo
obsidian-git:list-changed-files
obsidian-git:switch-branch
obsidian-git:create-branch
obsidian-git:delete-branch
obsidian-git:discard-all
obsidian-git:toggle-line-author-info
remotely-save:start-sync
remotely-save:start-sync-dry-run
remotely-save:export-sync-plans-1-only-change
remotely-save:export-sync-plans-1
remotely-save:export-sync-plans-5
remotely-save:export-sync-plans-all
obsidian-auto-link-title:auto-link-title-paste
obsidian-auto-link-title:auto-link-title-normal-paste
obsidian-auto-link-title:enhance-url-with-title
obsidian-linter:lint-file
obsidian-linter:lint-file-unless-ignored
obsidian-linter:lint-all-files
obsidian-linter:lint-all-files-in-folder
obsidian-linter:paste-as-plain-text
obsidian-weread-plugin:sync-weread-notes-command
obsidian-weread-plugin:Force-sync-weread-notes-command
obsidian-weread-plugin:open-weread-reading-view
leader-hotkeys-obsidian:register-modal
app:go-back
app:go-forward
app:open-vault
theme:use-dark
theme:use-light
theme:switch
app:open-settings
app:show-release-notes
markdown:toggle-preview
markdown:add-metadata-property
markdown:add-alias
markdown:edit-metadata-property
markdown:clear-metadata-properties
workspace:close
workspace:close-window
workspace:close-others
workspace:close-tab-group
workspace:close-others-tab-group
app:delete-file
app:toggle-ribbon
app:toggle-left-sidebar
app:toggle-right-sidebar
app:toggle-default-new-pane-mode
app:open-help
app:reload
app:show-debug-info
app:open-sandbox-vault
window:toggle-always-on-top
window:zoom-in
window:zoom-out
window:reset-zoom
file-explorer:new-file
file-explorer:new-file-in-current-tab
file-explorer:new-file-in-new-pane
open-with-default-app:open
file-explorer:move-file
file-explorer:duplicate-file
open-with-default-app:show
editor:toggle-source
editor:open-search
editor:open-search-replace
editor:focus
editor:toggle-fold-properties
editor:toggle-fold
editor:fold-all
editor:unfold-all
editor:fold-less
editor:fold-more
editor:insert-wikilink
editor:insert-embed
editor:insert-link
editor:insert-tag
editor:set-heading
editor:set-heading-0
editor:set-heading-1
editor:set-heading-2
editor:set-heading-3
editor:set-heading-4
editor:set-heading-5
editor:set-heading-6
editor:toggle-bold
editor:toggle-italics
editor:toggle-strikethrough
editor:toggle-highlight
editor:toggle-code
editor:toggle-inline-math
editor:toggle-blockquote
editor:toggle-comments
editor:clear-formatting
editor:toggle-bullet-list
editor:toggle-numbered-list
editor:toggle-checklist-status
editor:cycle-list-checklist
editor:insert-callout
editor:insert-codeblock
editor:insert-horizontal-rule
editor:insert-mathblock
editor:insert-table
editor:swap-line-up
editor:swap-line-down
editor:attach-file
editor:delete-paragraph
editor:add-cursor-below
editor:add-cursor-above
editor:toggle-spellcheck
editor:table-row-before
editor:table-row-after
editor:table-row-up
editor:table-row-down
editor:table-row-copy
editor:table-row-delete
editor:table-col-before
editor:table-col-after
editor:table-col-left
editor:table-col-right
editor:table-col-copy
editor:table-col-delete
editor:table-col-align-left
editor:table-col-align-center
editor:table-col-align-right
editor:context-menu
file-explorer:open
file-explorer:reveal-active-file
file-explorer:new-folder
global-search:open
switcher:open
graph:open
graph:open-local
graph:animate
backlink:open
backlink:open-backlinks
backlink:toggle-backlinks-in-document
outgoing-links:open
outgoing-links:open-for-current
tag-pane:open
properties:open
properties:open-local
insert-template
insert-current-date
insert-current-time
note-composer:merge-file
note-composer:split-file
note-composer:extract-heading
command-palette:open
outline:open
outline:open-for-current
file-recovery:open
```