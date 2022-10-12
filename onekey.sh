#!/bin/bash

function command_1(){
    echo "开始一键一键安装原神及环境！"
	echo "安装运行环境!"
	if type java >/dev/null 2>&1; 
	then
		echo "java 已安装，跳过"
	else
		cd /opt
		wget https://list.1ioi.cn/d/resources/java/jdk-17.0.4.1_linux-x64_bin.tar.gz 
		tar -xzvf jdk-17.0.4.1_linux-x64_bin.tar.gz
		rm -f jdk-17.0.4.1_linux-x64_bin.tar.gz
		echo "export PATH=/opt/jdk-17.0.4.1/bin:$PATH" >> /etc/profile
		echo "export JAVA_HOME=/opt/jdk-17.0.4.1" >> /etc/profile
		echo "export CLASSPATH=." >> /etc/profile
		source /etc/profile
		echo "java 安装完毕"
	fi
	wget https://list.1ioi.cn/d/resources/mongodb/mongodb-linux-x86_64-rhel70-4.0.28.tgz
	tar -zxvf mongodb-linux-x86_64-rhel70-4.0.28.tgz
	rm -f mongodb-linux-x86_64-rhel70-4.0.28.tgz
	mv mongodb-linux-x86_64-rhel70-4.0.28 mongodb
	mkdir -p ./mongodb/data ./mongodb/log ./mongodb/conf
	echo "mongodb 安装完毕"
	yum -y install -y screen
	echo "screen 安装完毕"
	yum -y install -y git
	echo "git 安装完毕"
	cd ~
	if [ -d "Genshin" ]; then
		rm -rf Genshin
	fi
	mkdir Genshin
	cd Genshin
	wget "https://ghproxy.com/https://github.com/Grasscutters/Grasscutter/releases/download/"$tag"/grasscutter-"${tag:1:5}".jar"
	wget "https://ghproxy.com/https://github.com/cool-chill/GC-onekey/raw/main/ssl/keystore.p12"
	git clone https://ghproxy.com/https://github.com/tamilpp25/Grasscutter_Resources.git
	cp -r Grasscutter_Resources/Resources .
	mv Resources resources
	rm -rf Grasscutter_Resources
	chmod -R 777 /root/Genshin
	echo "服务端准备完毕！开始启动服务端！"
	command_2
}


function command_2(){
    echo "服务端启动中!"
	chmod -R 777 /root/Genshin
	cd /opt/mongodb/
	bin/mongod --port=27017 --dbpath=/opt/mongodb/data --logpath=/opt/mongodb/log/mongodb.log --fork
	cd /root/Genshin
	source /etc/profile
	screen_name="Genshin" 
	screen -dmS $screen_name
	screen -x -S $screen_name -p 0 -X stuff "cd /root/Genshin && java -jar *.jar
	"
	sleep 5
	my_ip=`curl -s https://ipv4.ipw.cn/api/ip/myip`
	grep -q "127.0.0.1" /root/Genshin/config.json && sed -i 's#127.0.0.1#'$my_ip'#g' /root/Genshin/config.json || echo ""
	grep -q ""$my_ip"" /root/Genshin/config.json && echo "config.json文件中IP已修改为"$my_ip",若此处IP不对，请自行前往更改!" || echo ""
	sed -i 's/"language": "en_US"/"language": "zh_CN"/' /root/Genshin/config.json
	sed -i 's/"fallback": "en_US"/"fallback": "zh_CN"/' /root/Genshin/config.json
	sed -i 's/"document": "EN"/"document": "ZH"/' /root/Genshin/config.json
	echo "服务端启动完毕!"
}

function command_3(){
    echo "正在关闭服务端!"
	cd /opt/mongodb/
	bin/mongod --port=27017 --dbpath=/opt/mongodb/data --shutdown
	screen -ls|awk 'NR>=2&&NR<=5{print $1}'|awk '{print "screen -S "$1" -X quit"}'|sh
	echo "服务端已关闭!"
}

function command_4(){
    screen -r Genshin
}

function command_5(){
    command_3
	while true
	do
		if [ ! -e "/root/Genshin/config.json" ]; then
			echo "未找到配置文件，如已安装游戏，请尝试卸载重装！"
			break
		fi
		echo "*--------------------------------------------------------*"
		echo "                   自定义配置修改菜单                     "
		echo "*--------------------------------------------------------*"
		echo "1.  打开自动注册                                          "
		echo "2.  关闭自动注册                                          "
		echo "3.  打开注册自动给予权限                                  "
		echo "4.  关闭注册自动给予权限                                  "
		echo "5.  修改服务器名称                                        "
		echo "6.  修改进服左下角聊天框提示语                            "
		echo "7.  修改指令小助手名称                                    "
		echo "8.  修改指令小助手名称下方签名                            "
		echo "9.  修改进服邮件标题                                      "
		echo "10. 修改进服邮件内容（不是邮件附带的道具）                "
		echo "11. 修改进服邮件发送者名称                                "
		echo "                                                          "
		echo "0. 返回上一级菜单                                         "
		echo "                                                          "
		echo "*--------------------------------------------------------*"
		echo "**********************************************************"
		echo "请输入操作编号："
		read number
		case $number in
			"1")sed -i 's/"autoCreate":[^,]*/"autoCreate": true/' /root/Genshin/config.json
			echo "修改成功！"
			;;
			"2")sed -i 's/"autoCreate":[^,]*/"autoCreate": false/' /root/Genshin/config.json
			echo "修改成功！"
			;;
			"3")sed -i 's/"defaultPermissions":[^,]*/"defaultPermissions": [*]/' /root/Genshin/config.json
			echo "修改成功！"
			;;
			"4")sed -i 's/"defaultPermissions":[^,]*/"defaultPermissions": []/' /root/Genshin/config.json
			echo "修改成功！"
			;;
			"5")echo "请输入服务器名称："
				read sever_name
				sed -i 's/"defaultName":[^,]*/"defaultName": "'$sever_name'"/' /root/Genshin/config.json
				echo "修改成功！"
			;;
			"6")echo "请输入您想要设置的提示语："
				read huanying
				sed -i 's/"welcomeMessage":[^,]*/"welcomeMessage": "'$huanying'"/' /root/Genshin/config.json
				echo "修改成功！"
			;;
			"7")echo "请输入指令小助手名称："
				read nick_name
				sed -i 's/"nickName":[^,]*/"nickName": "'$nick_name'"/' /root/Genshin/config.json
				echo "修改成功！"
			;;
			"8")echo "请输入指令小助手名称下方签名："
				read nick_yu
				sed -i 's/"signature":[^,]*/"signature": "'$nick_yu'"/' /root/Genshin/config.json
				echo "修改成功！"
			;;
			"9")echo "请输入进服邮件标题："
				read mail_title
				sed -i 's/"title":[^,]*/"title": "'$mail_title'"/' /root/Genshin/config.json
				echo "修改成功！"
			;;
			"10")echo "请输入进服邮件内容："
				read mail_content
				sed -i 's/"content":.*$/"content": "'$mail_content'",/' /root/Genshin/config.json
				echo "修改成功！"
			;;
			"11")echo "请输入进服邮件发送者名称："
				read mail_sender
				sed -i 's/"sender":[^,]*/"sender": "'$mail_sender'"/' /root/Genshin/config.json
				echo "修改成功！"
			;;
			"0")echo "不要忘记启动游戏哦！"
				break
			;;
		esac
	done
}

function command_6(){
    command_3
	cd ~
	rm -rf Genshin/resources
	rm -rf Genshin/data
	rm -f Genshin/*.jar
	cd Genshin
	rm -f config.json
	wget "https://ghproxy.com/https://github.com/Grasscutters/Grasscutter/releases/download/"$tag"/grasscutter-"${tag:1:5}".jar"
	git clone https://ghproxy.com/https://github.com/tamilpp25/Grasscutter_Resources.git
	cp -r Grasscutter_Resources/Resources .
	mv Resources resources
	rm -rf Grasscutter_Resources
	chmod -R 777 /root/Genshin
	echo "服务端更新完成！自动启动服务端！"
	command_2
}

function command_0(){
    echo "退出菜单!"
}

function command_886(){
    echo "开始一键卸载环境及服务端"
	cd ~
	command_3
	rm -fr /root/Genshin
	rm -fr /opt/mongodb
	rm -fr /opt/jdk-17.0.4.1
	yum -y remove screen
	yum -y remove git
	sed -i '$d' /etc/profile
	sed -i '$d' /etc/profile
	sed -i '$d' /etc/profile
	source /etc/profile
	rm /root/onekey.sh
	echo "已完全卸载相关环境及文件并清理残留！"
}

while true
do
	cd ~
	if [ -d "/root/Genshin" ]; then
		cd Genshin
		genshin_local=`ls -f *.jar`
		genshin_local=${genshin_local:12:5} 
		echo $genshin_local
	fi
	if [ ! -d "/root/Genshin" ]; then
		genshin_local='未安装'
	fi
	tag=`wget -qO- -t1 -T2 "https://api.github.com/repos/Grasscutters/Grasscutter/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'`
	genshin_new=${tag:1:5}
	cd ~
	echo "*--------------------------------------------------------*"
	echo "               原神(Grasscutter)一键脚本                  "
	echo "                   coolchill && ioi                       "
	echo "                        已开源                            "
	echo "     开源地址：https://github.com/cool-chill/GC-onekey    "
	echo "*--------------------------------------------------------*"
	echo "1. 一键安装环境并部署最新服务端                           "
	echo "2. 启动服务端                                             "
	echo "3. 关闭服务端                                             "
	echo "                                                          "
	echo "4. 进入控制台(按住ctrl+A并按D切出，进入控制台请勿乱输)    "
	echo "                                                          "
	echo "5. 修改配置(自动注册,自动授权,服务器名称,提示语等信息)    "
	echo "  -修改配置默认会先关闭服务器，修改完毕后记得启动服务端   "
	echo "                                                          "
	echo "已安装服务端版本：$genshin_local                          "
	echo "最新服务端版本：  $genshin_new                            "
	echo "6. 更新服务端(不会删除玩家数据，config中配置会重置)       "
	echo "                                                          "
	echo "0. 退出菜单                                               "
	echo "                                                          "
	echo "886.一键卸载原神及环境                                    "
	echo "*--------------------------------------------------------*"
	echo "**********************************************************"
	echo "请输入操作编号："
	read number
	case $number in
		"1")command_1
		;;
		"2")command_2
		;;
		"3")command_3
		;;
		"4")command_4
		;;
		"5")command_5
		;;
		"6")command_6
		;;
		"0")command_0
			break
		;;
		"886")command_886
			break
		;;
	esac
done