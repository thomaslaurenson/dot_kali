# dot_kali

A bootstrap script to auto install a fresh Kali Linux VM with useful packages and shell aliases.

Make sure to configure VirtualBox shared folder using the following configuration:

- Folder Name: `share`
- Mount Point: `/media/share`

To install or update, you should run the [bootstrap script](https://github.com/thomaslaurenson/dot_kali/blob/v0.1.0/bootstrap.sh). To do that, you may either download and run the script manually, or use the following cURL or Wget command:

```
curl -o- https://github.com/thomaslaurenson/dot_kali/releases/latest/download/bootstrap.sh | zsh
```

```
wget -qO- https://github.com/thomaslaurenson/dot_kali/releases/latest/download/bootstrap.sh | zsh
```
