# Mac OS 一鍵安裝環境與程式の腳本

## 說明：<br>

使用 shell script 來安裝環境與程式，並且會自動安裝一些常用的軟體，以及設定一些常用的環境變數 (這些都是我常用的，可以根據個人需求自行調整)。

1. 首先要使用該腳本，請先將該檔案給 clone 下來，並且調整該 .sh 檔案可執行權限。
2. 檢查該腳本要安裝的內容是否為你所需要的，若不是，請自行修改。
3. 需要修改的設定參數，都放置在該腳本最上方，主要會修改的是 `brew_tap_array`、`brew_array`、`brew_cask`，該參數分別代表：
   1. `brew_tap_array`：安裝不再 homebrew 的第三方套件，例如：`hashicorp/tap`。
   2. `brew_array`：需要安裝的套件，例如：`git`。
   3. `brew_cask`：需要安裝的應用程式，例如：`visual-studio-code`。
4. 修改完畢後，就可以執行該腳本，腳本會自動安裝所有的套件與應用程式，並且會自動設定環境變數 (環境變數為本人常用，不需要可以直接刪除)。

![img](https://i.imgur.com/sORPOor.png)

<br>

## 備註：<br>

1. 需要查詢能夠安裝的套件與應用程式，可以到 [brew.sh](https://brew.sh/index_zh-tw) 查詢。
2. 查看已安裝 brew_array 的套件，可以使用 `brew list`。
3. 查看已安裝 brew_cask 的應用程式，可以使用 `brew list --cask`。

<br>

## 排除錯誤：<br>

由於該腳本是 For 給新電腦要設定環境時的一鍵安裝腳本，若以你已經用其他方式安裝過相同的程式或套件，可能會遇到以下圖片錯誤。

當我們遇到時，可以使用以下方式來解決，我們這邊用 docker 為例，我先使用網站的安裝檔案來安裝 docker，先從應用程式中刪除 docker，改用腳本來跑，會看到有紅字的錯誤訊息說 `Error: It seems there is already a Binary at 'XXX'.`，代表雖然把程式本身刪除，但他對應的檔案還在，所以我們要把它們都刪除，才能重新安裝。

![img](https://i.imgur.com/dcMLOpE.png)

docker 的對應檔案有這些：<br>
(超級多，所以建議一開始就使用 shell script 來安裝，不要用網站的安裝檔案來安裝)

![img](https://i.imgur.com/wY5z8oC.png)
