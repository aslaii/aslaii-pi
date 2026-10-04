import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const required = {
  skills: ["name", "description"],
  agents: ["name", "description", "model", "tools"],
  prompts: ["description"],
};

const files = [
  ...readdirSync("skills").map((dir) => ["skills", join("skills", dir, "SKILL.md")]),
  ...readdirSync("agents").map((file) => ["agents", join("agents", file)]),
  ...readdirSync("prompts").map((file) => ["prompts", join("prompts", file)]),
];

const errors = [];
for (const [kind, path] of files) {
  const match = readFileSync(path, "utf8").match(/^---\n([\s\S]*?)\n---\n/);
  if (!match) {
    errors.push(`${path}: missing frontmatter`);
    continue;
  }
  const keys = new Set(match[1].split("\n").map((line) => line.split(":")[0].trim()));
  for (const key of required[kind]) {
    if (!keys.has(key)) errors.push(`${path}: missing "${key}"`);
  }
}

JSON.parse(readFileSync("package.json", "utf8"));

if (errors.length) {
  console.error(errors.join("\n"));
  process.exit(1);
}
console.log(`ok: ${files.length} files`);
