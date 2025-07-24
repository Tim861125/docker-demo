# 用最新的 BUN 映像作為基礎映像
FROM oven/bun:latest

# 加上標籤 docker inspect 查看
LABEL maintainer="Tim.ding"
LABEL description="A demo project for Docker with Bun and json-server."

# 建構階段先用 root 安裝
WORKDIR /app
COPY package*.json ./
RUN bun install

# ARG 定義建置時變數，可用 --build-arg USER=TIM 來傳遞
# 若 USER 是 TIM，則建立使用者並切換；否則，將以 root 身份執行
ARG USER
RUN if [ "$USER" = "TIM" ]; then useradd -ms /bin/bash TIM; fi
USER ${USER:-root}

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
CMD ["test"]