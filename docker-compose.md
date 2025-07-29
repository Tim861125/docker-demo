# 使用 Docker Compose 管理應用

本專案使用 `docker-compose.yml` 來定義和管理兩個核心服務：

1.  `interactive-app`: 一個互動式的命令列問候服務。
2.  `api-server`: 一個基於 `json-server` 的簡易 API 伺服器。

## 必要條件

-   已安裝 [Docker](https://www.docker.com/get-started)
-   已安裝 [Docker Compose](https://docs.docker.com/compose/install/) (較新版本的 Docker Desktop 已內建)

## 常用指令

### 1. 啟動所有服務

在專案根目錄下執行以下指令，Docker Compose 會在背景模式下建置並啟動 `docker-compose.yml` 中定義的所有服務。

```bash
docker compose up -d
```

-   `-d` (`--detach`): 讓容器在背景運行。
-   首次執行此指令時，Docker Compose 會根據 `Dockerfile` 為 `interactive-app` 服務建置一個新的映像檔。

### 2. 查看服務狀態

要確認所有容器是否正在運行，可以執行：

```bash
docker compose ps
```

您應該會看到 `interactive-app-container` 和 `api-server-container` 兩個容器的狀態。

### 3. 與互動式 App 互動

`interactive-app` 服務是一個需要使用者輸入的程式。您可以使用 `docker attach` 連接到該容器進行互動：

```bash
docker attach interactive-app-container
```

-   **如何離開 `attach` 模式**：按下 `Ctrl+P`，緊接著按下 `Ctrl+Q`。這個組合鍵可以讓您從容器中脫離，但不會終止容器的運行。

### 4. 訪問 API 伺服器

`api-server` 服務將容器的 3000 port 映射到您本機的 3000 port。您可以透過瀏覽器或 API 工具 (如 Postman) 訪問以下網址：

-   `http://localhost:3000/posts`
-   `http://localhost:3000/comments`
-   `http://localhost:3000/profile`

### 5. 查看服務日誌

如果您需要排查問題或查看某個服務的輸出，可以使用 `logs` 指令。

```bash
# 查看 api-server 的日誌
docker compose logs api-server

# 查看 interactive-app 的日誌
docker compose logs interactive-app

# 持續追蹤日誌 (類似 tail -f)
docker compose logs -f api-server
```

### 6. 停止並清理環境

當您完成工作後，可以使用 `down` 指令來停止並移除由 `docker-compose up` 建立的所有資源。

```bash
docker compose down
```

這個指令會停止並移除容器、預設的網路，但不會移除由 `build` 產生的映像檔。

---
