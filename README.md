# 🛠️ bash-utils

A collection of Bash utility scripts for automating development setup and repetitive tasks.  
Each script is standalone and can be executed remotely or locally to speed up your workflow.

---

## 📂 Repository Structure

| File | Description |
|------|--------------|
| **boilerplate.sh** | Create a ready-to-use **React + TypeScript + Vite** project with **TailwindCSS** and **shadcn/ui** — including ESLint + Prettier configuration. |
| **format-all.sh** | Run Prettier and ESLint checks recursively in all subprojects. Useful for maintaining code consistency. |
| **git-clean.sh** | Quickly clean your Git workspace: remove untracked files, reset changes, and prune branches. |
| **deploy-static.sh** | Automate static site deployment to GitHub Pages or an S3 bucket. |
| **env-check.sh** | Check for required dependencies (Node.js, npm, git, jq, curl) and versions before running any setup. |

> 💡 Each script is modular — you can call it remotely, or download and execute locally.  
> Run `bash <(curl -s https://raw.githubusercontent.com/naeminhye/bash-utils/main/<script-name>.sh)` to use it without cloning.

---

## ⚙️ **boilerplate.sh**

### 🧠 Overview
`boilerplate.sh` creates a modern **React + TypeScript** boilerplate using **Vite**.  
It automatically installs and configures:

- 🧩 **TailwindCSS** and `@tailwindcss/vite`
- 🎨 **shadcn/ui** (with a custom beautiful Welcome page)
- ✨ **ESLint + Prettier**
- ⚡️ Path alias: `@/*`
- 🚀 Dev server auto-start after setup

---

### 🧰 Features

| Feature | Description |
|----------|-------------|
| **Vite + React + TS** | Fast project creation via `npm create vite@latest` |
| **TailwindCSS** | Fully configured with `@tailwindcss/vite` plugin |
| **shadcn/ui** | Installed and initialized automatically |
| **Custom Welcome Page** | Replaces default `App.tsx` with a styled intro screen |
| **ESLint + Prettier** | Configured for React + TypeScript projects |
| **Alias Support** | Imports with `@/components/...` |
| **Auto Start** | Runs `npm run dev` after setup |

---

### 🚀 Installation & Usage

You can run the boilerplate installer **directly from GitHub** without cloning the repo.

#### 🧠 macOS / Linux

```bash
bash <(curl -s https://raw.githubusercontent.com/naeminhye/bash-utils/main/boilerplate.sh) my-app
```

> If you encounter a permission error, run:
> ```bash
> chmod +x boilerplate.sh
> ./boilerplate.sh my-app
> ```

---

#### 🪟 Windows (Recommended: Git Bash)

Git Bash emulates a Unix-like shell, so the command is the same:

```bash
bash <(curl -s https://raw.githubusercontent.com/naeminhye/bash-utils/main/boilerplate.sh) my-app
```

If you’re using **PowerShell**, use this form instead:
```powershell
curl https://raw.githubusercontent.com/naeminhye/bash-utils/main/boilerplate.sh -UseBasicParsing | bash -s my-app
```

> ⚠️ Note: PowerShell does **not support `<( … )`**, so use the pipe (`| bash`) syntax instead.

---

#### 🧩 Result

Once complete, you’ll have:
```
my-app/
├── src/
│   ├── components/ui/button.tsx
│   ├── App.tsx
│   └── index.css
├── tsconfig.json
├── tsconfig.app.json
├── vite.config.ts
└── package.json
```

Then simply run:
```bash
cd my-app
npm run dev
```

and open [http://localhost:5173](http://localhost:5173)

---

## 🧠 **Other Scripts**

### 🧼 `format-all.sh`
Recursively runs Prettier and ESLint for all projects inside the repo.  
Useful for monorepos or multi-folder environments.

**Usage:**
```bash
bash <(curl -s https://raw.githubusercontent.com/naeminhye/bash-utils/main/format-all.sh)
```

---

### 🧹 `git-clean.sh`
Safely removes untracked files and branches, keeping your local repo clean.

**Usage:**
```bash
bash <(curl -s https://raw.githubusercontent.com/naeminhye/bash-utils/main/git-clean.sh)
```

---

### 🚀 `deploy-static.sh`
Builds your project and deploys to GitHub Pages or S3 in one step.

**Usage:**
```bash
bash <(curl -s https://raw.githubusercontent.com/naeminhye/bash-utils/main/deploy-static.sh)
```

---

### 🧩 `env-check.sh`
Checks for Node.js, npm, git, curl, and jq before running setup scripts.

**Usage:**
```bash
bash <(curl -s https://raw.githubusercontent.com/naeminhye/bash-utils/main/env-check.sh)
```

---

## 🧾 License

MIT © 2025 [@naeminhye](https://github.com/naeminhye)

---

## 💬 Contributing

Pull requests are welcome!  
If you’d like to add more Bash automation scripts, please:
1. Follow the naming convention: `function-name.sh`
2. Add a short description to this README
3. Test your script on both macOS and Windows (Git Bash)

---

## 🌟 Example

Quick create a new project in one command:
```bash
bash <(curl -s https://raw.githubusercontent.com/naeminhye/bash-utils/main/boilerplate.sh) weather-app
```

Then open the browser at [http://localhost:5173](http://localhost:5173) and start coding 🎉
