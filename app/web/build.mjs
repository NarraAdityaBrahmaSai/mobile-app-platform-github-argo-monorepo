import { mkdir, writeFile } from "node:fs/promises";
import { createHash } from "node:crypto";

const release = process.env.RELEASE_ID;
if (!release) {
  throw new Error("RELEASE_ID is required");
}

const input = await import("node:fs/promises").then((fs) => fs.readFile("index.html"));
const hash = createHash("sha256").update(input).digest("hex").slice(0, 16);

await mkdir("dist/assets", { recursive: true });

const script = `console.log("mobile-platform web ${release} ${hash}");`;
await writeFile(`dist/assets/app.${hash}.js`, script, "utf8");

const html = input
  .toString()
  .replace("/assets/app.js", `/releases/${release}/assets/app.${hash}.js`);

await writeFile("dist/index.html", html, "utf8");
