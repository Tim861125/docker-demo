import * as readline from "readline";

const rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout,
});

async function fetchApiData() {
	try {
		// 關鍵點：直接使用服務名稱 "api-server" 作為主機名！
		// Docker Compose 會在內部網路中將它解析到正確的容器 IP。
		const response = await fetch("http://api-server:3000/profile");
		if (!response.ok) {
			throw new Error(`API 請求失敗: ${response.statusText}`);
		}
		const data = await response.json();
		console.log("從 API 伺服器獲取的資料:", data);
	} catch (error) {
		console.error("無法連接到 API 伺服器:", error.message);
	}
}

function askName() {
	rl.question("請輸入你的名字 (輸入 'exit' 來離開): ", async (name: string) => {
		if (name.toLowerCase() === "exit") {
			console.log("再見！");
			rl.close();
			return;
		}
		console.log(`你好，${name}`);

		// 在這裡呼叫 API
		await fetchApiData();

		// 再次呼叫自己，形成循環
		askName();
	});
}

// 啟動程式
console.log("歡迎來到互動式問候服務！");
askName();
