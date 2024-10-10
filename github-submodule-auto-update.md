---
title: github submodule auto update
---
PAT 权限

You can also use a [fine-grained personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token) (beta). It needs the following permissions on the target repositories:

- `contents: read & write`
- `metadata: read only` (automatically selected when selecting the contents permission)

push需要token。