import * as readline from "readline";

const rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout,
});

rl.question("請輸入你的名字: ", (name: string) => {
	console.log(`你好，${name}`);
	rl.close();
});
