#!/bin/bash

#=========================================
# 參數設定
brew_tap_array=("snyk/tap" "hashicorp/tap") # 安裝不在 homebrew 的第三方套件
brew_array=("bash-completion" "sshpass" "watch" "kubernetes-cli" "kustomize" "helm" "terraform" "terragrunt" "kubectx" "kubecolor" "jq" "okteto" "k9s" "shellcheck")
brew_cask=("iterm2" "visual-studio-code" "gitkraken" "postman" "docker" "ticktick" "google-chrome" "telegram-desktop" "skype") # 視窗程式

#=========================================
# 腳本設定
nowtime=$(date '+%Y/%m/%d %H:%M:%S')
var=0
num=0

#=========================================
# 顏色設定
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 重置颜色

#=========================================

echo -e "============================== mac-install-kit 腳本 =============================="
echo -e "本腳本會自動安裝所需套件，可以自行調整參數及設定！"
echo -e "腳本開始時間 ${nowtime}"

#=========================================

# 安裝 Homebrew
var="$((var + 1))"
num="$((num + 1))"

if ! brew -v 1>/dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo -e "${num} _ 安裝 Homebrew: [${GREEN}安裝成功${NC}]"
else
	echo -e "${num} _ 安裝 Homebrew: [${YELLOW}已安裝${NC}]"
	var="$((var - 1))"
fi

# 安裝 Homebrew - 第三方套件(套件列表請參考參數設定 brew_tap_array)
for kit in "${brew_tap_array[@]}"; do
	var="$((var + 1))"
	num="$((num + 1))"
	if ! brew tap | grep "$kit" 1>/dev/null; then
		brew install "$kit" 1>/dev/null
		echo -e "${num} _ 安裝 Homebrew_tap 套件 ($kit): [${GREEN}安裝成功${NC}]"
	else
		echo -e "${num} _ 安裝 Homebrew_tap 套件 ($kit): [${YELLOW}已安裝${NC}]"
		var="$((var - 1))"
	fi
done

# 安裝 Homebrew - 套件(套件列表請參考參數設定 brew_array)
for kit in "${brew_array[@]}"; do
	var="$((var + 1))"
	num="$((num + 1))"

	if ! brew list | grep "$kit" 1>/dev/null; then
		brew install "$kit" 1>/dev/null
		echo -e "${num} _ 安裝 Homebrew 套件 ($kit): [${GREEN}安裝成功${NC}]"
	else
		echo -e "${num} _ 安裝 Homebrew 套件 ($kit): [${YELLOW}已安裝${NC}]"
		var="$((var - 1))"
	fi
done

# 安裝 Homebrew cask - 視窗程式(程式列表請參考參數設定 brew_cask)
for kit in "${brew_cask[@]}"; do
	var="$((var + 1))"
	num="$((num + 1))"

	if ! brew list --cask | grep "$kit" 1>/dev/null; then
		brew install --cask "$kit"
		echo -e "${num} _ 安裝 Homebrew 視窗程式 ($kit): [${GREEN}安裝成功${NC}]"
	else
		echo -e "${num} _ 安裝 Homebrew 視窗程式 ($kit): [${YELLOW}已安裝${NC}]"
		var="$((var - 1))"
	fi
done

# 設定 zsh 主題 (agnoster) 只顯示帳號名稱
var="$((var + 1))"
num="$((num + 1))"
sed -i -e 's/%n@%m/%n/g' "$ZSH"/themes/agnoster.zsh-theme
echo -e "${num} _ 設定 zsh 主題 (只顯示帳號名稱): [${GREEN}設定成功${NC}]"

# 設定 zsh 主題 (agnoster) 只顯示當前路徑
var="$((var + 1))"
num="$((num + 1))"
sed -i -e 's/%~/%c/g' "$ZSH"/themes/agnoster.zsh-theme
echo -e "${num} _ 設定 zsh 主題 (只顯示當前路徑): [${GREEN}設定成功${NC}]"

# 設定 alias (kubectl 改使用 kubecolor)
var="$((var + 1))"
num="$((num + 1))"
alias kubectl="kubecolor"
echo -e "${num} _ 設定 alias (kubectl 改使用 kubecolor): [${GREEN}設定成功${NC}]"

# 新增 terraform 自動補全
var="$((var + 1))"
num="$((num + 1))"
if ! grep "autoload -U +X bashcompinit && bashcompinit" ~/.zshrc 1>/dev/null; then
	terraform -install-autocomplete 1>/dev/null
	echo -e "${num} _ 新增 terraform 自動補全: [${GREEN}設定成功${NC}]"
else
	echo -e "${num} _ 新增 terraform 自動補全: [${YELLOW}已設定${NC}]"
	var="$((var - 1))"
fi

#=========================================
# 輸出統計

printf "\n=====================================統計輸出===================================\n"
success_rate=$(echo -e "scale=2; $var/$num*100" | bc -l)
echo -e "安裝+設定套件成功數 / 安裝+設定套件總數 / 成功率：( ${GREEN}$var${NC} ${BLUE}/ $num / ${RED}$success_rate%${NC} )"
