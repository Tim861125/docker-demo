# Docker 容器互動模式學習筆記

本次我們學習了如何建立一個可互動的 Docker 容器，讓它在背景持續運行，並能隨時透過 `docker attach` 連接進行操作。

## 核心問題

當一個 Docker 容器的主要程序結束時，容器本身也會隨之停止。如果我們的應用程式是一個需要使用者輸入的互動式腳本（例如使用 Node.js 的 `readline` 模組），它在沒有輸入來源時會立刻結束，導致容器無法在背景持續運行。

## 解決方案

要讓一個互動式應用程式的容器在背景持續運行，需要在 `docker run` 指令中結合使用 `-d` 和 `-i` 旗標。

- `-d` (`--detach`): 讓容器在背景模式下運行。
- `-i` (`--interactive`): **即使在背景模式下，也為容器保持標準輸入（stdin）的開啟狀態。** 這是讓互動式程式能持續等待輸入而不會退出的關鍵。
- `-t` (`--tty`): (建議使用) 為容器分配一個虛擬終端機，這能讓後續 `attach` 的互動體驗更佳。

### 關鍵指令

1.  **建置映像檔** (假設 Dockerfile 已設定好 `CMD`)
    ```bash
    docker build -t <image-name> .
    ```

2.  **在背景啟動容器** (使用 `-d` 和 `-it`)
    ```bash
    docker run -d -it --name <container-name> <image-name>
    ```

3.  **連接到正在運行的容器**
    ```bash
    docker attach <container-name>
    ```

4.  **(可選) 從 attach 脫離而不關閉容器**
    按下 `Ctrl+P` 然後 `Ctrl+Q`。

## 程式碼修改：讓腳本持續運行

為了讓容器的主程序永不結束，我們可以將互動式腳本改寫成一個無限循環的模式。同時，提供一個明確的退出指令（例如輸入 `exit`）是個好習慣。

**範例 `index.ts` 修改：**

```typescript
import * as readline from "readline";

const rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout,
});

function askName() {
	rl.question("請輸入你的名字 (輸入 'exit' 來離開): ", (name: string) => {
		if (name.toLowerCase() === "exit") {
			console.log("再見！");
			rl.close();
			return;
		}
		console.log(`你好，${name}`);
		// 再次呼叫自己，形成循環
		askName();
	});
}

// 啟動程式
console.log("歡迎來到互動式問候服務！");
askName();
```

透過以上方法，我們就能成功建立一個可以長期在背景運行並隨時進行互動的 Docker 服務了。

---

# 如何在 WSL 2 中設定與使用 Docker

這是在 Windows Subsystem for Linux 2 (WSL 2) 中設定和使用 Docker 的詳細步驟教學。

### 事前準備：確認並設定 WSL 2

在安裝 Docker 之前，您必須確保您的 Windows 系統已啟用 WSL 2，並且您使用的 Linux 發行版正在 WSL 2 模式下執行。

1.  **檢查 WSL 版本**
    打開 Windows 的 PowerShell 或命令提示字元（CMD），然後輸入以下指令：

    ```bash
    wsl -l -v
    ```

    您會看到類似以下的輸出：

    ```
      NAME            STATE           VERSION
    * Ubuntu-22.04    Running         2
    ```

    請確保您想使用的 Linux 發行版（例如 `Ubuntu-22.04`）旁邊的 `VERSION` 顯示為 `2`。

2.  **處理版本不符的情況**
    *   **如果沒有安裝 WSL：** 請以系統管理員身分打開 PowerShell，執行 `wsl --install`，然後重新啟動電腦。
    *   **如果版本是 1：** 您需要將其轉換為 WSL 2。執行以下指令（將 `<DistroName>` 換成您的發行版名稱）：
        ```bash
        wsl --set-version <DistroName> 2
        ```

### 步驟一：下載並安裝 Docker Desktop for Windows

1.  **前往官網下載**
    訪問 Docker 官方網站的下載頁面：[https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)

2.  **執行安裝程式**
    下載完成後，執行安裝檔。在安裝過程中，請確保勾選了 "Use WSL 2 instead of Hyper-V (recommended)" 選項。

3.  **完成安裝並重新啟動**
    安裝完成後，依照指示重新啟動 Windows。

### 步驟二：設定 Docker Desktop 與 WSL 2 整合

1.  **啟動 Docker Desktop**
    從 Windows 的「開始」功能表啟動 Docker Desktop。

2.  **進入設定**
    打開 Docker Desktop 應用程式視窗，點擊右上角的**齒輪圖示 (⚙️)** 進入設定。

3.  **啟用 WSL 整合**
    *   前往 `Resources` > `WSL Integration`。
    *   找到您想要在其中使用 Docker 的發行版，並**打開它旁邊的開關**。
    *   點擊 "Apply & Restart" 按鈕。

### 步驟三：在 WSL 2 中驗證 Docker 是否運作正常

1.  **打開您的 WSL 2 終端機**
    從 Windows 的「開始」功能表打開您的 Linux 發行版（例如 "Ubuntu"）。

2.  **檢查 Docker 版本**
    在終端機中，輸入以下指令：
    ```bash
    docker --version
    ```
    如果成功，會顯示 Docker 的版本資訊。

3.  **執行一個測試容器**
    執行 `hello-world` 映像檔來確認所有設定都正確：
    ```bash
    docker run hello-world
    ```
    如果您看到 "Hello from Docker!" 的訊息，代表您已成功在 WSL 2 中設定好 Docker。