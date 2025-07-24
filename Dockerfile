# ARG 必須在 FROM 之前或之中定義，才能在 FROM 中使用
# 我們定義一個建置時變數 BUN_VERSION，並給予預設值 "1.0"
ARG BUN_VERSION=1.0

# 使用官方的 bun 映像作為基礎，版本由 ARG 決定
FROM oven/bun:${BUN_VERSION}

# 為映像加上標籤，提供作者、版本和描述等元數據
LABEL maintainer="Tim.ding"
LABEL version="1.0.0"
LABEL description="A demo project for Docker with Bun and json-server."


# 建構階段先用 root 安裝
WORKDIR /app
COPY package*.json ./
RUN bun install

# 建立 Tim 並切換
# docker exec -it <container_id> bash
RUN useradd -ms /bin/bash Tim
USER Tim

# 複製 package.json 到工作目錄
COPY package.json ./
# 複製 bun.lock 以確保依賴版本一致
COPY bun.lock ./

# 複製所有本地檔案到工作目錄
COPY . .

# 可以用 -e 來覆寫: -e PORT=8080
ENV PORT=3000

# 讓容器對外開放 $PORT 變數指定的端口
EXPOSE ${PORT}

# 設定容器的主要執行檔為 bun
ENTRYPOINT ["bun"]

# 提供給 ENTRYPOINT 的預設參數
CMD ["start"]