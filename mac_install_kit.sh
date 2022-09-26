#!/bin/sh

#=========================================
# 參數設定
brew_tap_array=("snyk/tap" "hashicorp/tap") # 安裝不在 homebrew 的第三方套件
brew_array=("sshpass" "minikube" "kubernetes-cli" "kustomize" "helm" "snyk" "hashicorp/tap/terraform")

#=========================================
# 腳本設定

nowtime=$(date '+%Y/%m/%d %H:%M:%S')
var=0
num=0

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

var=$(expr $var '+' 1)
num=$(expr $num '+' 1)
brew -v 1>/dev/null
if [ "$?" = "0" ]; then
	echo "${num} _ 安裝 Homebrew: [${yellow}已安裝${white}]"
	var=$(expr $var '-' 1)
else
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo "${num} _ 安裝 Homebrew: [${green}安裝成功${white}]"
fi

# 安裝 Homebrew - 第三方套件(套件列表請參考參數設定 brew_tap_array)

for kit in ${brew_tap_array[@]}; do
	var=$(expr $var '+' 1)
	num=$(expr $num '+' 1)
	brew tap | grep $kit 1>/dev/null
	if [ "$?" = "0" ]; then
		echo "${num} _ 安裝 Homebrew_tap ($kit): [${yellow}已安裝${white}]"
		var=$(expr $var '-' 1)
	else
		brew install $kit 1>/dev/null
		echo "${num} _ 安裝 Homebrew_tap ($kit): [${green}安裝成功${white}]"
	fi
done

# 安裝 Homebrew - 套件(套件列表請參考參數設定 brew_array)

for kit in ${brew_array[@]}; do
	var=$(expr $var '+' 1)
	num=$(expr $num '+' 1)
	brew list | grep $kit 1>/dev/null
	if [ "$?" = "0" ]; then
		echo "${num} _ 安裝 Homebrew ($kit): [${yellow}已安裝${white}]"
		var=$(expr $var '-' 1)
	else
		brew install $kit 1>/dev/null
		echo "${num} _ 安裝 Homebrew ($kit): [${green}安裝成功${white}]"
	fi
done

# 設定 zsh 主題 (agnoster) 只顯示帳號名稱
var=$(expr $var '+' 1)
num=$(expr $num '+' 1)
sed -i -e 's/%n@%m/%n/g' $ZSH/themes/agnoster.zsh-theme
echo "${num} _ 設定 zsh 主題 (只顯示帳號名稱): [${green}設定成功${white}]"

# 設定 zsh 主題 (agnoster) 只顯示當前路徑
var=$(expr $var '+' 1)
num=$(expr $num '+' 1)
sed -i -e 's/%~/%c/g' $ZSH/themes/agnoster.zsh-theme
echo "${num} _ 設定 zsh 主題 (只顯示當前路徑): [${green}設定成功${white}]"

#=========================================
# 輸出統計

echo "\n=====================================統計輸出==================================="
success_rate=$(echo "scale=2; $var/$num*100" | bc -l)
echo "${blue}安裝套件成功數 / 安裝套件總數 / 成功率：( ${green}$var${white} ${blue}/ $num / ${red}$success_rate%${white} )"
