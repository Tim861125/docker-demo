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
