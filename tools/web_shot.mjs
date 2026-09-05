#!/usr/bin/env node
// Full-page screenshot of a site URL through Chrome DevTools, no dependencies.
// usage: node tools/web_shot.mjs <url> <out.png> [width=1280] [light|dark] [chunkHeight] [scrollY]
// With scrollY, only the 900px viewport at that scroll offset is captured (for sticky/scroll states).
// The page loads in a viewport as tall as itself so lazy images are in view;
// chunkHeight splits a tall page into out-N.png. SHOT_PORT lets several run at once.
import { spawn } from "node:child_process";
import { writeFileSync } from "node:fs";

const [url, out, w = "1280", scheme = "light", chunk = "0", scrollY] = process.argv.slice(2);
const port = process.env.SHOT_PORT ?? "9333";
const chrome = spawn("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome", [
  "--headless=new", "--disable-gpu", "--hide-scrollbars", "--no-first-run",
  `--remote-debugging-port=${port}`, `--user-data-dir=${process.env.TMPDIR}witness-shot-${port}`,
  `--window-size=${w},900`, "about:blank",
], { stdio: "ignore" });
const quit = (code) => { chrome.kill("SIGKILL"); process.exit(code); };
setTimeout(() => { console.error("timed out"); quit(2); }, 60000);

let target;
for (let i = 0; i < 80 && !target; i++) {
  await new Promise((r) => setTimeout(r, 250));
  target = await fetch(`http://127.0.0.1:${port}/json`).then((r) => r.json()).then((t) => t.find((x) => x.type === "page")).catch(() => undefined);
}
if (!target) { console.error("no chrome target"); quit(1); }

const ws = new WebSocket(target.webSocketDebuggerUrl);
await new Promise((r) => (ws.onopen = r));
let id = 0; const pending = new Map();
ws.onmessage = (e) => { const m = JSON.parse(e.data); if (m.id && pending.has(m.id)) { pending.get(m.id)(m.result ?? m.error); pending.delete(m.id); } };
const send = (method, params = {}) => new Promise((r) => { pending.set(++id, r); ws.send(JSON.stringify({ id, method, params })); });

await send("Emulation.setEmulatedMedia", { features: [{ name: "prefers-color-scheme", value: scheme }] });
await send("Emulation.setDeviceMetricsOverride", { width: +w, height: 12000, deviceScaleFactor: 1, mobile: +w < 768 });
await send("Page.navigate", { url });
await new Promise((r) => setTimeout(r, 3500));
// Back to a normal viewport so the layout reports its true height (the body is min-h-full).
await send("Emulation.setDeviceMetricsOverride", { width: +w, height: 900, deviceScaleFactor: 1, mobile: +w < 768 });
await new Promise((r) => setTimeout(r, 500));
if (scrollY !== undefined) {
  await send("Runtime.evaluate", { expression: `window.scrollTo(0, ${+scrollY})` });
  await new Promise((r) => setTimeout(r, 900));
  const { data } = await send("Page.captureScreenshot", { format: "png" });
  writeFileSync(out, Buffer.from(data, "base64"));
  console.log(`${url} @ ${scrollY}px`);
  ws.close();
  quit(0);
}
const { cssContentSize } = await send("Page.getLayoutMetrics");
const height = Math.ceil(cssContentSize.height);
const step = +chunk || height;
for (let y = 0, i = 0; y < height; y += step, i++) {
  const h = Math.min(step, height - y);
  const { data } = await send("Page.captureScreenshot", { format: "png", captureBeyondViewport: true, clip: { x: 0, y, width: +w, height: h, scale: 1 } });
  writeFileSync(step === height ? out : out.replace(/\.png$/, `-${i}.png`), Buffer.from(data, "base64"));
}
console.log(`${url} → ${height}px tall`);
ws.close();
quit(0);
