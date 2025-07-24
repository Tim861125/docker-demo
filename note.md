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
