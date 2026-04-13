#!/usr/bin/env bash
# ================================================
# Astra AI Boilerplate Setup Script
# ================================================
# This boilerplate is created for the project in the book:
# "Build AI-Enhanced Web Apps: How to get reliable results with React, Next.js, and Vercel"
# by Theo Despoudis
#
# Purpose:
#   - Frontend: React + TypeScript + Vite + Tailwind CSS (Simple interface)
#   - Backend: Node.js + Express + OpenAI REST API
#   - Follows the initial iteration requirements:
#       • Uses OpenAI’s REST APIs (no custom model)
#       • Ephemeral storage (no conversation history)
#       • Basic error handling with user-friendly messages
#       • Basic security: input validation & sanitization
#       • No user authentication in this iteration
# ================================================

set -e  # Exit immediately if a command exits with a non-zero status

# Colors for better output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Astra AI Boilerplate Setup...${NC}"
echo -e "${YELLOW}Book Project: Build AI-Enhanced Web Apps by Theo Despoudis${NC}"
echo ""

# Check for project name parameter
if [ -z "$1" ]; then
  read -p "Enter project name (e.g. astra-ai): " PROJECT_NAME
else
  PROJECT_NAME=$1
fi

if [ -z "$PROJECT_NAME" ]; then
  echo -e "${RED}❌ Project name cannot be empty!${NC}"
  exit 1
fi

echo -e "${YELLOW}📁 Creating project: ${PROJECT_NAME}${NC}"

# Create root directory
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# ============================
# 1. Create Frontend (React + TypeScript + Vite + Tailwind)
# ============================
echo -e "${GREEN}🔨 Creating Frontend with Vite + React + TypeScript...${NC}"

npm create vite@latest frontend -- --template react-ts
cd frontend

npm install
npm install -D tailwindcss @tailwindcss/vite
npm install lucide-react

cd ..

# ============================
# 2. Create Backend (Node.js + Express + OpenAI)
# ============================
echo -e "${GREEN}🔨 Creating Backend with Node.js + Express + OpenAI...${NC}"

mkdir -p backend
cd backend

npm init -y

npm install express openai cors dotenv
npm install -D nodemon concurrently

# Create main backend file
cat > index.js << 'EOF'
const express = require('express');
const cors = require('cors');
const { OpenAI } = require('openai');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Basic input sanitization
const sanitizeInput = (str) => {
  return str.trim().replace(/[<>\"']/g, '');
};

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

app.post('/chat', async (req, res) => {
  try {
    const { message } = req.body;

    if (!message || typeof message !== 'string') {
      return res.status(400).json({ error: 'Message is required and must be a string.' });
    }

    const sanitizedMessage = sanitizeInput(message);
    if (sanitizedMessage.length === 0) {
      return res.status(400).json({ error: 'Message cannot be empty.' });
    }

    const completion = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [
        { role: "system", content: "You are Astra AI, a helpful and friendly AI assistant." },
        { role: "user", content: sanitizedMessage }
      ],
      max_tokens: 1000,
      temperature: 0.7,
    });

    const aiResponse = completion.choices[0]?.message?.content || 
                       "Sorry, I couldn't generate a response at this time.";

    res.json({ 
      response: aiResponse,
      model: "gpt-4o-mini"
    });

  } catch (error) {
    console.error('OpenAI API Error:', error);
    
    if (error.status === 401) {
      return res.status(401).json({ error: 'Invalid OpenAI API key. Please check your .env file.' });
    }
    
    res.status(500).json({ 
      error: 'Something went wrong while processing your request. Please try again later.' 
    });
  }
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'Astra AI backend is running successfully.' });
});

app.listen(PORT, () => {
  console.log(`🚀 Astra AI Backend is running on http://localhost:${PORT}`);
});
EOF

# Create .env.example
cat > .env.example << 'EOF'
OPENAI_API_KEY=sk-your-openai-api-key-here
PORT=5000
EOF

cd ..

# ============================
# 3. Create start-dev.sh (Run both frontend and backend)
# ============================
echo -e "${GREEN}🔨 Creating development startup script...${NC}"

cat > start-dev.sh << 'EOF'
#!/usr/bin/env bash
echo "🚀 Starting Astra AI - Frontend + Backend..."

npx concurrently \
  "cd frontend && npm run dev" \
  "cd backend && npm run dev" \
  --names "Frontend,Backend" \
  --prefix-colors "blue,green"
EOF

chmod +x start-dev.sh

# ============================
# 4. Configure Tailwind CSS + Simple Chat UI
# ============================
echo -e "${GREEN}🎨 Configuring Tailwind CSS and creating chat interface...${NC}"

cd frontend

# Update vite.config.ts
cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [react(), tailwindcss()],
})
EOF

# Update index.css
cat > src/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

body {
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.chat-container {
  scrollbar-width: thin;
  scrollbar-color: #4b5563 #1f2937;
}

.chat-container::-webkit-scrollbar {
  width: 6px;
}

.chat-container::-webkit-scrollbar-thumb {
  background-color: #4b5563;
  border-radius: 20px;
}
EOF

# Create clean chat UI in App.tsx
cat > src/App.tsx << 'EOF'
import { useState } from 'react';
import { Send, Bot, User } from 'lucide-react';

interface Message {
  role: 'user' | 'assistant';
  content: string;
}

function App() {
  const [messages, setMessages] = useState<Message[]>([
    { role: 'assistant', content: 'Hello! I am Astra AI. How can I assist you today?' }
  ]);
  const [input, setInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const sendMessage = async () => {
    if (!input.trim() || isLoading) return;

    const userMessage: Message = { role: 'user', content: input.trim() };
    setMessages(prev => [...prev, userMessage]);
    const currentInput = input.trim();
    setInput('');
    setIsLoading(true);

    try {
      const response = await fetch('http://localhost:5000/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: currentInput }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'Failed to get response from AI.');
      }

      setMessages(prev => [...prev, { 
        role: 'assistant', 
        content: data.response 
      }]);
    } catch (error: any) {
      console.error(error);
      setMessages(prev => [...prev, { 
        role: 'assistant', 
        content: `❌ Error: ${error.message || 'Cannot connect to the backend. Please make sure the backend server is running.'}` 
      }]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  };

  return (
    <div className="min-h-screen bg-gray-950 text-white flex flex-col">
      <header className="border-b border-gray-800 bg-gray-900 py-4">
        <div className="max-w-4xl mx-auto px-4 flex items-center gap-3">
          <Bot className="w-8 h-8 text-blue-400" />
          <h1 className="text-2xl font-semibold">Astra AI</h1>
          <span className="text-sm text-gray-400">— Initial Iteration</span>
        </div>
      </header>

      <div className="flex-1 max-w-4xl mx-auto w-full p-4 flex flex-col">
        <div className="flex-1 bg-gray-900 rounded-2xl p-6 overflow-y-auto chat-container space-y-6 mb-4">
          {messages.map((msg, index) => (
            <div key={index} className={`flex gap-4 ${msg.role === 'user' ? 'justify-end' : 'justify-start'}`}>
              <div className={`max-w-[80%] rounded-2xl px-5 py-3 ${
                msg.role === 'user' 
                  ? 'bg-blue-600 text-white' 
                  : 'bg-gray-800 text-gray-100'
              }`}>
                <div className="flex items-center gap-2 mb-1 text-xs opacity-70">
                  {msg.role === 'user' ? <User className="w-4 h-4" /> : <Bot className="w-4 h-4" />}
                  {msg.role === 'user' ? 'You' : 'Astra AI'}
                </div>
                <p className="whitespace-pre-wrap leading-relaxed">{msg.content}</p>
              </div>
            </div>
          ))}

          {isLoading && (
            <div className="flex gap-4">
              <div className="bg-gray-800 rounded-2xl px-5 py-3">
                <div className="flex items-center gap-2 mb-2">
                  <Bot className="w-4 h-4" />
                  <span className="text-xs opacity-70">Astra AI is thinking...</span>
                </div>
                <div className="flex gap-1">
                  <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
                  <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{animationDelay: '150ms'}}></div>
                  <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{animationDelay: '300ms'}}></div>
                </div>
              </div>
            </div>
          )}
        </div>

        <div className="flex gap-3">
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyPress={handleKeyPress}
            placeholder="Type your message here..."
            className="flex-1 bg-gray-900 border border-gray-700 rounded-2xl px-6 py-4 focus:outline-none focus:border-blue-500 placeholder-gray-500"
            disabled={isLoading}
          />
          <button
            onClick={sendMessage}
            disabled={!input.trim() || isLoading}
            className="bg-blue-600 hover:bg-blue-700 disabled:bg-gray-700 px-8 rounded-2xl flex items-center justify-center transition-all"
          >
            <Send className="w-6 h-6" />
          </button>
        </div>
      </div>

      <footer className="text-center text-gray-500 text-sm py-6">
        Astra AI • First Iteration • Ephemeral mode — No conversation history is stored
      </footer>
    </div>
  );
}

export default App;
EOF

cd ..

# ============================
# Final Message
# ============================
echo -e "${GREEN}✅ Astra AI boilerplate setup completed successfully!${NC}"
echo ""
echo -e "📁 Project created at: ./${PROJECT_NAME}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Go to the backend folder and set up your OpenAI API key:"
echo "   cd ${PROJECT_NAME}/backend && cp .env.example .env"
echo ""
echo "2. Start the full application:"
echo "   cd ${PROJECT_NAME}"
echo "   ./start-dev.sh"
echo ""
echo -e "${GREEN}Frontend → http://localhost:5173${NC}"
echo -e "${GREEN}Backend  → http://localhost:5000${NC}"
echo ""
echo -e "This boilerplate follows the requirements from the book \"Build AI-Enhanced Web Apps\" by Theo Despoudis."
echo -e "Happy coding! 🎉"
