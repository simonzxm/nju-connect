# nju-connect

南大 aTrust VPN 免安装命令行客户端（基于开源项目 [ZJU-Connect](https://github.com/Mythologyli/zju-connect)）。

## 用法

```bash
./nju-connect.sh          # 首次运行自动下载客户端；连接（首次登录输一次短信验证码）
./nju-connect.sh trust    # 绑定授信终端 → 之后登录免短信
```

日常使用只需 `./nju-connect.sh`。连接成功后本机代理：SOCKS5 `127.0.0.1:1080`，HTTP `127.0.0.1:1081`。
