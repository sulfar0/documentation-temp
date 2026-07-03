```
systemctl --user enable --now ssh-agent.socket
```

```
flatpak override --user --filesystem=/run/user/1000/ssh-agent.socket org.keepassxc.KeePassXC
```

```
nvim ~/.ssh/config
```

```
Host *
    IdentityAgent /run/user/1000/ssh-agent.socket
```
> angka 1000 disesuaikan dengan uid user
```
id -u
```
