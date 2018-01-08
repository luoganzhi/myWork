  ssh安装：
  wget --no-check-certificate	 https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocksR.sh
chmod +x shadowsocksR.sh
./shadowsocksR.sh 2>&1 | tee shadowsocksR.log


默认在/root文件夹下，要进入/etc文件夹下找到shadowsocks.json


{
  "server":"0.0.0.0",
  "server_ipv6":"::",
  "local_address":"127.0.0.1",
  "local_port":1080,
  "port_password":{
   #纯 SS 不带混淆 端口25 密码为123456.
   "25":"123456",
   #端口443，密码123456 ，protocol选择auth_chain_a。obfs选择tls1.2_ticket_auth，具体插件的介绍如下参考资料中
   "443":{"protocol":"auth_chain_a", "password":"123456", "obfs":"tls1.2_ticket_auth", "obfs_param":""},
  #注意无论怎么变化，最后一个端口设置，不带逗号！
   "3389":{"protocol":"auth_aes128_md5", "password":"123456", "obfs":"tls1.2_ticket_auth", "obfs_param":""}#此处没有逗号！
  },
  "timeout":400,
  #默认全局的加密方式，即上边各个端口的默认加密方式。一般为aes-256-cfb，		此处，选择为chacha20，移动设备性能较好。
  "method":"chacha20",
  #protocol.协议定义插件的默认值，origin即使用原版SS协议，不混淆。即上面端口配置中，你没有设置 protocol 和 obfs 情况下，使用的默认值。
  "protocol": "origin",
  "protocol_param": "",
   #protocol.协议定义插件的默认值，plain即使用原协议，不混淆。
  "obfs": "plain",
  "obfs_param": "",
  "redirect": "",
  "dns_ipv6": true,
 #TCP FAST OPEN ，打开
  "fast_open": true,
 "workers": 1
}

  
/etc/init.d/shadowsocks restart  //重启ssr




  用户只需要将系统安装成 Debian 8 或者 Ubuntu 16 即可，剩下的交给脚本来吧。

  https://github.com/FunctionClub/YankeeBBR

  wget -N --no-check-certificate https://raw.githubusercontent.com/FunctionClub/YankeeBBR/master/bbr.sh &amp;&amp; bash bbr.sh install

  选择NO

  bash bbr.sh start

  查看魔改BBR状态
  sysctl net.ipv4.tcp_available_congestion_control
  如果看到有 tsunami 就表示开启成功！


