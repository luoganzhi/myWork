liunx 指令
连接远程服务端  ssh root@192.168.1.1 -p 443
查看当前进程 ps -axu
回到上一层目录 cd ..

blog更新 hexo clean && hexo g && hexo d

安装wget：yum install wget

kcp配置服务端
{
    "listen": ":36591",
    "target": "127.0.0.1:443",
    "key": "f89JvR5x",
    "crypt": "cast5",
    "mode": "fast",
    "mtu": 1400,
    "sndwnd": 1024,
    "rcvwnd": 1024,·
    "datashard": 10,
    "parityshard": 3,
    "dscp": 46,
    "nocomp": false,
    "acknodelay": false,
    "nodelay": 0,
    "interval": 20,
    "resend": 2,
    "nc": 1,
    "sockbuf": 4194304,
    "keepalive": 10
}




Client $ nc -dv <your_server_ip> 5879 -u
Server $ tcpdump -nnq host  <your_server_ip>  and not port 80  and not port 443 and not tcp

Client $ sudo nmap -sU <your_server_ip>  -p5879 -Pn



IP address:	162.219.126.54
SSH Port:	28229
远程密码： 8T8jX586URzf
Kcptun： -key "f89JvR5x" -crypt cast5 -mtu 1400 -sndwnd 50 -rcvwnd 400 -dscp 46 -mode fast

mysql:  root@localhost: j79L,w_WcpJ8 修改后密码：luoganzhi



bbrVps   IP:66.112.220.45  密码：kSoKLFdhW0th   port： 28151


cat > kcptun-mobile.json <<EOF
  {
      "listen": ":29990",
      "target": "127.0.0.1:$[shadowsocksport+1]",
      "key": "${kcppwd}",
      "crypt": "salsa20",
      "mode": "fast",
      "mtu": 1400,
      "sndwnd": 1024,
      "rcvwnd": 1024,
      "datashard": 10,
      "parityshard": 3,
      "dscp": 46,
      "nocomp": true,
      "acknodelay": false,
      "nodelay": 0,
      "interval": 20,
      "resend": 2,
      "nc": 1,
      "sockbuf": 4194304,
      "keepalive": 10
  }
  EOF

