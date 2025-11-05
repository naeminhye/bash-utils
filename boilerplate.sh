#!/usr/bin/env bash
set -e

APP_NAME=${1:-weather-app}

echo "🚀 Creating Vite React + TS app..."
yes "n" | npm create vite@latest "$APP_NAME" -- --template react-ts

cd "$APP_NAME"

echo "📦 Installing TailwindCSS plugin..."
npm install tailwindcss @tailwindcss/vite

cat > src/index.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

@import "tailwindcss";
EOF

echo "🧭 Updating tsconfig..."
cat > tsconfig.json <<'EOF'
{
  "files": [],
  "references": [
    { "path": "./tsconfig.app.json" },
    { "path": "./tsconfig.node.json" }
  ],
  "compilerOptions": {
    "baseUrl": ".",
    "paths": { "@/*": ["./src/*"] }
  }
}
EOF

cat > tsconfig.app.json <<'EOF'
{
  "compilerOptions": {
    "jsx": "react-jsx",
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src"]
}
EOF

echo "🧱 Configuring vite.config.ts..."
npm install -D @types/node

cat > vite.config.ts <<'EOF'
import path from "path"
import tailwindcss from "@tailwindcss/vite"
import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"

export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
})
EOF

echo "💻 Initializing shadcn/ui..."
npx shadcn@latest init -y

echo "✨ Adding shadcn button..."
npx shadcn@latest add button

cat > src/App.tsx <<'EOF'
import { Button } from "@/components/ui/button"
import { Github } from "lucide-react"

function App() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-white via-blue-50 to-indigo-100 text-center">
      <div className="max-w-md mx-auto p-6 rounded-2xl shadow-xl bg-white/80 backdrop-blur-sm border border-indigo-100">
        <h1 className="text-4xl font-bold bg-gradient-to-r from-indigo-600 to-blue-500 bg-clip-text text-transparent">
          Welcome to Your App 🚀
        </h1>
        <p className="mt-3 text-gray-600">
          You’ve successfully created a <strong>React + TypeScript + Vite</strong> project<br />
          with <strong>TailwindCSS</strong> and <strong>shadcn/ui</strong>.
        </p>

        <div className="mt-6 flex flex-col gap-3">
          <Button
            onClick={() => window.open("https://ui.shadcn.com", "_blank")}
            className="bg-indigo-600 hover:bg-indigo-700"
          >
            Explore shadcn/ui
          </Button>

          <Button
            variant="outline"
            onClick={() => window.open("https://vitejs.dev", "_blank")}
            className="flex items-center justify-center gap-2"
          >
            <Github size={18} />
            Visit Vite Docs
          </Button>
        </div>

        <p className="text-xs text-gray-400 mt-6">
          Built with ❤️ by <span className="font-semibold text-indigo-500">@jaceynae</span>
        </p>
      </div>
    </div>
  )
}

export default App
EOF

echo "🧹 Installing ESLint + Prettier..."
npm install -D eslint prettier eslint-config-prettier eslint-plugin-prettier \
  @typescript-eslint/parser @typescript-eslint/eslint-plugin \
  eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-import

echo "🧩 Creating ESLint & Prettier configs..."

cat > .eslintrc.cjs <<'EOF'
module.exports = {
  root: true,
  parser: "@typescript-eslint/parser",
  plugins: ["@typescript-eslint", "react", "react-hooks", "import", "prettier"],
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
    "plugin:import/recommended",
    "plugin:import/typescript",
    "prettier"
  ],
  settings: { react: { version: "detect" } },
  rules: {
    "prettier/prettier": ["error", { endOfLine: "lf" }],
    "react/react-in-jsx-scope": "off",
    "import/order": [
      "error",
      {
        "newlines-between": "always",
        alphabetize: { order: "asc", caseInsensitive: true },
        groups: ["builtin", "external", "internal", "parent", "sibling", "index"]
      }
    ]
  }
}
EOF

cat > .prettierrc <<'EOF'
{
  "semi": false,
  "singleQuote": false,
  "trailingComma": "es5",
  "printWidth": 100,
  "tabWidth": 2
}
EOF

cat > .eslintignore <<'EOF'
node_modules
dist
EOF

npm pkg set scripts.lint="eslint . --ext .ts,.tsx"
npm pkg set scripts.format="prettier --write ."

echo ""
echo "✅ Setup complete!"
echo ""
echo "Available commands:"
echo "  npm run dev      → start dev server"
echo "  npm run lint     → run ESLint"
echo "  npm run format   → run Prettier"
echo ""
echo "🚀 Starting dev server..."
npm run dev
