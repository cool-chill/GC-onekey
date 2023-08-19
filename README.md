# 脚本已失效，本作者不再维护，请根据[Grasscutters](https://github.com/Grasscutters/Grasscutter)项目进行修改适配再使用
## GC-onekey

脚本同步[Grasscutters](https://github.com/Grasscutters/Grasscutter)项目，想要自定义其他版本请自行Fork


### 一键部署

鉴于国内访问Github网络不佳，默认使用 https://ghproxy.com/ 进行加速

```shell
yum install wget -y && wget https://ghproxy.com/https://github.com/cool-chill/GC-onekey/raw/main/onekey.sh && sed -i 's/\r//' *.sh && chmod +x  onekey.sh && ./onekey.sh
```

**执行此命令可一键部署服务端，小白直接执行然后根据菜单操作即可**
退出后使用以下命令进入菜单

```shell
./onekey.sh
```

### 界面展示

![](/images/1.png)

![](/images/2.png)


### 注意事项

>   **一键卸载会删除通过脚本产生的所有文件以及环境配置，包括脚本本身，还原到使用脚本以前的状态，请放心使用！**

### Thanks

[Grasscutters](https://github.com/Grasscutters/Grasscutter)
[GitHub Proxy](https://ghproxy.com/)
