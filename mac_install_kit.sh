#!/bin/sh

#=========================================
# 參數設定

brew_array=("sshpass" "wget" "nginx" "mysql" "php@8.0" "phpmyadmin" "minikube" "kubernetes-cli")

#=========================================
# 腳本設定

nowtime=$(date '+%Y/%m/%d %H:%M:%S')
var=0;num=0;

#=========================================
# 顏色設定

red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
blue="\033[1;34m"
white="\033[0m"

#=========================================

echo "==============================mac-install-kit 腳本=============================="
echo "本腳本會自動安裝所需套件，可以自行調整參數及設定！"
echo "腳本開始時間 ${nowtime}"

#=========================================

# 安裝 Homebrew

var=`expr $var '+' 1`; num=`expr $num '+' 1`;
brew -v 1>/dev/null
if [ "$?" = "0" ];then
echo "${num} _ 已安裝 Homebrew:                  [${yellow}Warning${white}]"
var=`expr $var '-' 1`;
else
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "${num} _ 安裝 Homebrew:                    [${green}Success${white}]"
fi

# 安裝 Homebrew - 套件(套件列表請參考參數設定 brew_array)

for kit in ${brew_array[@]}
do
	var=`expr $var '+' 1`; num=`expr $num '+' 1`;
	brew list | grep $kit > /tmp/install.log 
	if [ "$?" = "0" ];then
	echo "${num} _ 已安裝 Homebrew ($kit):   [${yellow}Warning${white}]"
	var=`expr $var '-' 1`;
	else
	brew install $kit
	echo "${num} _ 安裝 Homebrew ($kit):     [${green}Success${white}]"
	fi
done


#=========================================

# 輸出統計

echo "\n=====================================統計輸出==================================="
echo "${blue}安裝套件成功數 / 安裝套件總數 / 成功率：( ${green}$var${white} ${blue}/ $num / )"
