### 核心概念

*   **映像檔 (Image):** 一個唯讀的模板，用來建立容器。可以把它想像成程式安裝檔。
*   **容器 (Container):** 映像檔的運行實例。可以把它想像成安裝好的程式。容器之間是隔離的。
*   **倉庫 (Repository):** 集中存放映像檔的地方，最有名的是 Docker Hub。

---

### 常用 Docker 指令大全

#### 1. 映像檔管理 (Image)

| 指令 | 用途 | 常用範例 |
| :--- | :--- | :--- |
| `docker build` | 從 Dockerfile 建立一個新的映像檔。 | `docker build -t my-app:1.0 .` |
| `docker images` | 列出本機所有的映像檔。 | `docker images` |
| `docker pull` | 從倉庫（例如 Docker Hub）下載一個映像檔。 | `docker pull ubuntu:22.04` |
| `docker push` | 將一個本機映像檔推送到倉庫。 | `docker push your-username/my-app:1.0` |
| `docker rmi` | 刪除一個或多個本機映像檔。 | `docker rmi my-app:1.0` |
| `docker tag` | 為映像檔新增一個標籤（tag），常用於版本控制。 | `docker tag my-app:1.0 my-app:latest` |

#### 2. 容器生命週期管理 (Container)

| 指令 | 用途 | 常用範例 |
| :--- | :--- | :--- |
| **`docker run`** | **(最重要)** 從一個映像檔建立並啟動一個新的容器。 | `docker run -d -p 8080:80 --name web nginx` |
| `docker ps` | 列出**正在運行中**的容器。 | `docker ps` |
| `docker ps -a` | 列出**所有**的容器（包含已停止的）。 | `docker ps -a` |
| `docker start` | 啟動一個或多個已停止的容器。 | `docker start web` |
| `docker stop` | 優雅地停止一個或多個正在運行的容器。 | `docker stop web` |
| `docker restart` | 重新啟動一個容器。 | `docker restart web` |
| `docker rm` | 刪除一個或多個已停止的容器。 | `docker rm web` |
| `docker kill` | 強制停止一個容器（立即終止）。 | `docker kill web` |

#### 3. 容器互動與監控 (Interaction & Monitoring)

| 指令 | 用途 | 常用範例 |
| :--- | :--- | :--- |
| `docker logs` | 查看容器的日誌輸出。 | `docker logs -f web` (`-f` 持續追蹤) |
| `docker exec` | 在一個**正在運行**的容器內執行指令。 | `docker exec -it web bash` (進入容器的 shell) |
| `docker attach` | 連接到一個正在運行的容器的主程序。 | `docker attach my-interactive-container` |
| `docker cp` | 在主機和容器之間複製檔案或資料夾。 | `docker cp ./index.html web:/usr/share/nginx/html/` |
| `docker stats` | 即時查看容器的資源使用情況（CPU、記憶體等）。 | `docker stats` |

#### 4. 系統與清理 (System & Cleanup)

| 指令 | 用途 | 常用範例 |
| :--- | :--- | :--- |
| **`docker system prune`** | **(非常實用)** 清理系統中未使用的資源，例如已停止的容器、懸空的映像檔和無用的網路。 | `docker system prune` |
| `docker system prune -a` | 更徹底地清理，會刪除所有未被任何容器使用的映像檔。 | `docker system prune -a` |
| `docker info` | 顯示 Docker 系統的詳細資訊。 | `docker info` |
| `docker version` | 顯示 Docker 的版本資訊。 | `docker version` |

#### 5. 網路 (Network) & 儲存 (Volume)

這些稍微進階，但在多容器應用中非常重要。

| 指令 | 用途 | 常用範例 |
| :--- | :--- | :--- |
| `docker volume ls` | 列出所有的儲存卷（Volume）。 | `docker volume ls` |
| `docker network ls` | 列出所有的網路。 | `docker network ls` |
| `docker network create` | 建立一個新的網路，讓容器可以互相通訊。 | `docker network create my-net` |

### 如何獲得幫助？

當您不確定某個指令的用法時，可以在指令後面加上 `--help` 來查看詳細說明。

```bash
# 查看 run 指令的詳細用法
docker run --help

# 查看所有可用的 Docker 指令
docker --help
```
