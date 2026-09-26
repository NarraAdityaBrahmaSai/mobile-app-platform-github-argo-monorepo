import test from "node:test";
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";

test("index contains product title", async () => {
  const html = await readFile("index.html", "utf8");
  assert.match(html, /Mobile Platform/);
});
