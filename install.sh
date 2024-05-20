#!/bin/bash

#=========================================
# 參數設定
brew tap k8sgpt-ai/k8sgpt
brew tap hashicorp/tap
brew_array=("zsh" "bash-completion" "watch" "kubernetes-cli" "kustomize" "helm" "hashicorp/tap/terraform" "terragrunt" "kubectx" "jq" "okteto" "k9s" "shellcheck" "autojump" "hugo" "wget" "telnet" "tree" "k6" "fzf" "kor" "kubent" "k8sgpt" "k3d" "pv" "dialog" "ipcalc") # 套件
brew_cask=("1password" "google-chrome" "iterm2" "visual-studio-code" "gitkraken" "postman" "docker" "telegram-desktop" "spotify" "lens" "raycast" "logi-options-plus" "notion" "notion-calendar")                                                                           # 視窗程式

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

# 判斷系統架構
if [ "$(uname -a | awk -F " " '{print $(NF-1)}' | grep 'X86')" ]; then
	brew_Path="/usr/local"
else
	brew_Path="/opt"
	# 支援多使用者
	sudo chown -R $(whoami) ${brew_Path}/homebrew ${brew_Path}/homebrew/share/zsh ${brew_Path}/homebrew/share/zsh/site-functions ${brew_Path}/homebrew/var/homebrew/locks
fi

# 安裝 Homebrew
var="$((var + 1))"
num="$((num + 1))"
if ! command -v brew 1>/dev/null; then
	echo "export PATH=${brew_Path}/homebrew/bin:\$PATH" >>"$HOME"/.bash_profile && source "$HOME"/.bash_profile
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo -e "${num} _ 安裝 Homebrew : [${GREEN}安裝成功${NC}]"
else
	echo -e "${num} _ 安裝 Homebrew : [${YELLOW}已安裝${NC}]"
	var="$((var - 1))"
fi

# 安裝 Homebrew - 套件(套件列表請參考參數設定 brew_array)
for kit in "${brew_array[@]}"; do
	var="$((var + 1))"
	num="$((num + 1))"
	if ! brew list | grep "$kit" 1>/dev/null; then
		brew install "$kit"
		echo -e "${num} _ 安裝 Homebrew 套件 ($kit) : [${GREEN}安裝成功${NC}]"
	else
		echo -e "${num} _ 安裝 Homebrew 套件 ($kit) : [${YELLOW}已安裝${NC}]"
		var="$((var - 1))"
	fi
done

# 安裝 Homebrew - 套件+設定 alias (kubectl 改使用 kubecolor)
var="$((var + 1))"
num="$((num + 1))"
if ! command -v kubecolor 1>/dev/null; then
	brew install hidetatz/tap/kubecolor 1>/dev/null
	if ! grep "alias kubectl=\"kubecolor\"" "$HOME"/.bash_profile 1>/dev/null; then
		echo "alias kubectl=\"kubecolor\"" >>"$HOME"/.bash_profile
	fi
	echo -e "${num} _ 安裝 Homebrew 套件 (kubecolor) + 設定 alias : [${GREEN}安裝成功${NC}]"
else
	echo -e "${num} _ 安裝 Homebrew 套件 (kubecolor) + 設定 alias : [${YELLOW}已安裝${NC}]"
	var="$((var - 1))"
fi

# 安裝 Homebrew cask - 視窗程式(程式列表請參考參數設定 brew_cask)
for kit in "${brew_cask[@]}"; do
	var="$((var + 1))"
	num="$((num + 1))"
	if ! brew list --cask | grep "$kit" 1>/dev/null; then
		brew install --cask "$kit"
		echo -e "${num} _ 安裝 Homebrew 視窗程式 ($kit) : [${GREEN}安裝成功${NC}]"
	else
		echo -e "${num} _ 安裝 Homebrew 視窗程式 ($kit) : [${YELLOW}已安裝${NC}]"
		var="$((var - 1))"
	fi
done

# 安裝 oh-my-zsh
var="$((var + 1))"
num="$((num + 1))"
if [ ! -f "$HOME/.zshrc" ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	sed -i -e 's/ZSH_THEME=.*/ZSH_THEME="clean"/g' "$HOME"/.zshrc
	echo -e "${num} _ 安裝 oh-my-zsh (clean 主題) : [${GREEN}安裝成功${NC}]"
else
	echo -e "${num} _ 安裝 oh-my-zsh (clean 主題) : [${YELLOW}已安裝${NC}]"
	var="$((var - 1))"
fi

# 安裝 zsh-autosuggestions
var="$((var + 1))"
num="$((num + 1))"
if [ ! -d "${ZSH_CUSTOM:-"$HOME"/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions ]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-"$HOME"/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions 1>/dev/null
	sed -i -e 's/plugins=(.*/plugins=(git zsh-autosuggestions)/g' "$HOME"/.zshrc
	echo -e "${num} _ 安裝 zsh-autosuggestions : [${GREEN}安裝成功${NC}]"
else
	echo -e "${num} _ 安裝 zsh-autosuggestions : [${YELLOW}已安裝${NC}]"
	var="$((var - 1))"
fi

# 安裝 zsh-syntax-highlighting
var="$((var + 1))"
num="$((num + 1))"
if [ ! -d "${ZSH_CUSTOM:-"$HOME"/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting "${ZSH_CUSTOM:-"$HOME"/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting 1>/dev/null
	sed -i -e 's/plugins=(.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' "$HOME"/.zshrc
	echo -e "${num} _ 安裝 zsh-syntax-highlighting : [${GREEN}安裝成功${NC}]"
else
	echo -e "${num} _ 安裝 zsh-syntax-highlighting : [${YELLOW}已安裝${NC}]"
	var="$((var - 1))"
fi

# 設定 autojump
var="$((var + 1))"
num="$((num + 1))"
if ! grep "git zsh-autosuggestions zsh-syntax-highlighting autojump" "$HOME"/.zshrc 1>/dev/null; then
	sed -i -e 's/plugins=(.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting autojump)/g' "$HOME"/.zshrc
	echo -e "${num} _ 設定 autojump : [${GREEN}設定成功${NC}]"
else
	echo -e "${num} _ 設定 autojump : [${YELLOW}已設定${NC}]"
	var="$((var - 1))"
fi

# 設定 terraform 自動補全
var="$((var + 1))"
num="$((num + 1))"
if ! grep "autoload -U +X bashcompinit && bashcompinit" ~/.zshrc 1>/dev/null; then
	terraform -install-autocomplete 1>/dev/null
	echo -e "${num} _ 設定 terraform 自動補全 : [${GREEN}設定成功${NC}]"
else
	echo -e "${num} _ 設定 terraform 自動補全 : [${YELLOW}已設定${NC}]"
	var="$((var - 1))"
fi

# 設定常用 alias
var="$((var + 1))"
num="$((num + 1))"
if ! grep "alias k=\"kubectl\"" "$HOME"/.bash_profile 1>/dev/null; then
	echo "alias k=\"kubectl\"" >>"$HOME"/.bash_profile && source "$HOME"/.bash_profile
	echo -e "${num} _ 設定 alias (kubectl) : [${GREEN}設定成功${NC}]"
else
	echo -e "${num} _ 設定 alias (kubectl) : [${YELLOW}已設定${NC}]"
	var="$((var - 1))"
fi

var="$((var + 1))"
num="$((num + 1))"
if ! grep "alias kns=\"kubens\"" "$HOME"/.bash_profile 1>/dev/null; then
	echo "alias kns=\"kubens\"" >>"$HOME"/.bash_profile && source "$HOME"/.bash_profile
	echo -e "${num} _ 設定 alias (kubens) : [${GREEN}設定成功${NC}]"
else
	echo -e "${num} _ 設定 alias (kubens) : [${YELLOW}已設定${NC}]"
	var="$((var - 1))"
fi

var="$((var + 1))"
num="$((num + 1))"
if ! grep "alias ktx=\"kubectx\"" "$HOME"/.bash_profile 1>/dev/null; then
	echo "alias ktx=\"kubectx\"" >>"$HOME"/.bash_profile && source "$HOME"/.bash_profile
	echo -e "${num} _ 設定 alias (kubectx) : [${GREEN}設定成功${NC}]"
else
	echo -e "${num} _ 設定 alias (kubectx) : [${YELLOW}已設定${NC}]"
	var="$((var - 1))"
fi

# 設定 .zshrc
var="$((var + 1))"
num="$((num + 1))"
if ! grep "source \$HOME/.bash_profile" "$HOME"/.zshrc 1>/dev/null; then
	echo -e "\nsource \$HOME/.bash_profile" >>"$HOME"/.zshrc
	echo -e "${num} _ 設定 .zshrc : [${GREEN}設定成功${NC}]"
else
	echo -e "${num} _ 設定 .zshrc : [${YELLOW}已設定${NC}]"
	var="$((var - 1))"
fi

# 設定 .vimrc (vim option 向右單字切換)
var="$((var + 1))"
num="$((num + 1))"
if ! grep -s ":map f w" "$HOME"/.vimrc 1>/dev/null; then
	echo -e ":map f w" >>"$HOME"/.vimrc
	echo -e "${num} _ 設定 .vimrc : [${GREEN}設定成功${NC}]"
else
	echo -e "${num} _ 設定 .vimrc : [${YELLOW}已設定${NC}]"
	var="$((var - 1))"
fi

#=========================================
# 輸出統計

printf "\n=====================================統計輸出===================================\n"
success_rate=$(echo -e "scale=2; $var/$num*100" | bc -l)
echo -e "安裝 + 設定套件成功數 / 安裝 + 設定套件總數 / 成功率：( ${GREEN}$var${NC} ${BLUE}/ $num / ${RED}$success_rate%${NC} )"
