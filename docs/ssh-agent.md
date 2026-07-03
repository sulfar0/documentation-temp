```
systemctl --user enable --now ssh-agent.socket
```

```
flatpak override --user --filesystem=/run/user/1000/ssh-agent.socket org.keepassxc.KeePassXC
```


## pengaturan global keepassxc

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/e552c221-5957-479d-8df7-8fbafffc8fb3" />

> pastikan hijau

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
