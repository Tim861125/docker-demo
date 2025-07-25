// server.ts
console.log(
	"🟢 Bun server started. Waiting for SIGINT (Ctrl+C or docker stop)...",
);

process.on("SIGTERM", () => {
	console.log("SIGTERM, exit");
});

process.on("SIGINT", () => {
	console.log("SIGINT, exit");
});

// 模擬一個長時間運行的伺服器
setInterval(() => {
	console.log("running...");
}, 2000);
