```
systemctl --user enable --now ssh-agent.socket
```

```
flatpak override --user --filesystem=/run/user/1000/ssh-agent.socket org.keepassxc.KeePassXC
```
