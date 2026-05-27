import {spawnSync} from "node:child_process";

const taskName = process.argv[2];

if (!taskName) {
  console.error("Usage: node ./scripts/rake.mjs <rake-task>");
  process.exit(1);
}

const isWindows = process.platform === "win32";

const command = isWindows ? "cmd" : "bundle";
const args = isWindows
  ? ["/c", "bundle", "exec", "rake", taskName]
  : ["exec", "rake", taskName];

const result = spawnSync(command, args, {
  stdio: "inherit",
  shell: false,
  env: process.env,
});

if (result.error) {
  console.error(result.error.message);
  process.exit(1);
}

process.exit(result.status ?? 1);
