# ScreenAgent Setup & Deployment Guide

**For User: akashBv6680**
Forked from: niuzaisheng/ScreenAgent
Date: December 26, 2025

---

## 📋 Quick Overview

ScreenAgent is a computer control agent driven by Visual Language Large Models (VLMs) that can:
- Observe desktop screenshots in real-time
- Execute mouse and keyboard operations autonomously
- Complete multi-step computer tasks
- Plan, execute, and reflect on actions

**Key Features:**
- Vision-Language Model (VLM) powered automation
- Planning → Execution → Reflection workflow
- Universal action space (mouse/keyboard operations)
- Supports multiple VLMs: GPT-4V, LLaVA-1.5, CogAgent, ScreenAgent
- Comprehensive dataset for training

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Clone Your Fork
```bash
git clone https://github.com/akashBv6680/ScreenAgent.git
cd ScreenAgent
```

### Step 2: Create Virtual Environment
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### Step 3: Install Dependencies
```bash
pip install -r client/requirements.txt
```

### Step 4: Configure Settings
- Copy `client/config.yml.example` to `client/config.yml`
- Edit configuration for your VNC server and LLM choice

### Step 5: Run Controller
```bash
cd client
python run_controller.py -c config.yml
```

---

## 💻 Local Development Setup (Detailed)

### Prerequisites
- Python 3.8+
- pip package manager
- Git
- VNC Server (TightVNC or Docker)
- 8GB RAM minimum

### Installation Steps

1. **Clone Repository**
```bash
git clone https://github.com/akashBv6680/ScreenAgent.git
cd ScreenAgent
```

2. **Setup Python Environment**
```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip
```

3. **Install Client Dependencies**
```bash
pip install -r client/requirements.txt
```

4. **Install VLM Inferencer (Choose ONE)**

**Option A: GPT-4V (API-based)**
```bash
pip install openai
# Set OPENAI_API_KEY environment variable
export OPENAI_API_KEY="your-api-key"
```

**Option B: LLaVA-1.5 (Local)**
```bash
git clone https://github.com/haotian-liu/LLaVA.git
cd LLaVA
pip install -e .
cd ..
# Copy model worker
cp model_workers/llava_model_worker.py LLaVA/llava/serve/
```

**Option C: CogAgent (Local)**
```bash
# Download from: https://huggingface.co/THUDM/CogAgent
# Place in: train/saved_models/cogagent-chat
```

---

## 🖥️ Desktop Environment Setup

### Option 1: Docker (Recommended)
```bash
docker run -d \
  --name ScreenAgent \
  -e RESOLUTION=1024x768 \
  -p 5900:5900 \
  -p 8001:8001 \
  -e VNC_PASSWORD=your_password \
  -e CLIPBOARD_SERVER_SECRET_TOKEN=your_token \
  -v /dev/shm:/dev/shm \
  niuniushan/screenagent-env:latest
```

### Option 2: Local Desktop with TightVNC
1. Install TightVNC: https://www.tightvnc.com/download.php
2. Configure VNC Server with your IP and port
3. Update `client/config.yml` with VNC details

### Option 3: Linux Desktop
```bash
# Install dependencies
pip install fastapi pydantic uvicorn pyperclip

# Set clipboard password
export CLIPBOARD_SERVER_SECRET_TOKEN="your_token"

# Start clipboard service
python client/clipboard_server.py
```

---

## ⚙️ Configuration Guide

### client/config.yml Structure

```yaml
# VNC Server Configuration
remote_vnc_server:
  host: "127.0.0.1"
  port: 5900
  password: "your_vnc_password"
  clipboard_server_url: "http://localhost:8001"
  clipboard_token: "your_token"

# Select ONE LLM
llm_api:
  GPT4V:
    model_name: "gpt-4-vision-preview"
    openai_api_key: "your_key"
    target_url: "https://api.openai.com/v1/chat/completions"
  
  # OR LLaVA
  LLaVA:
    model_name: "LLaVA-1.5"
    target_url: "http://localhost:40000/worker_generate"
  
  # OR CogAgent
  CogAgent:
    target_url: "http://localhost:40000/worker_generate"
  
  # Common settings
  temperature: 1.0
  top_p: 0.9
  max_tokens: 500
```

---

## 🔧 Troubleshooting

### VNC Connection Issues
```bash
# Test VNC connection
echo "check" | nc -v your_host 5900

# Verify clipboard service
curl -X POST http://localhost:8001/clipboard \
  -H "Content-Type: application/json" \
  -d '{"text":"test","token":"your_token"}'
```

### Python Dependency Issues
```bash
# Reinstall requirements
pip install --force-reinstall -r client/requirements.txt

# Check specific package
pip show package_name
```

### PyPerclip Errors
```bash
# Set DISPLAY variable
export DISPLAY=:0.0
python client/clipboard_server.py
```

---

## 📦 Project Structure

```
ScreenAgent/
├── client/              # Controller application
│   ├── config.yml       # Configuration file
│   ├── run_controller.py
│   ├── interface_api/   # LLM API interfaces
│   ├── prompt/          # Prompt templates
│   ├── clipboard_server.py
│   └── requirements.txt
├── model_workers/       # VLM inference workers
│   ├── llava_model_worker.py
│   └── ...
├── train/              # Model training code
├── data/               # Datasets
│   ├── COCO/
│   ├── Rico/
│   ├── Mind2Web/
│   └── ScreenAgent/
├── README.md
└── SETUP_GUIDE.md      # This file
```

---

## 🚢 GitHub Deployment Options

### Option 1: GitHub Pages (for documentation)
1. Go to Settings → Pages
2. Select source: main branch /docs
3. Custom domain: (optional)

### Option 2: GitHub Actions (for CI/CD)
Create `.github/workflows/test.yml`:
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
      - run: pip install -r client/requirements.txt
      - run: pytest
```

### Option 3: GitHub Releases
```bash
git tag v1.0.0
git push origin v1.0.0
```
Then create release from tag in GitHub UI

---

## 📚 Next Steps

1. **Local Testing**: Run controller with GPT-4V API first (easiest)
2. **VLM Integration**: Try with LLaVA-1.5 or CogAgent
3. **Custom Tasks**: Create task definitions in `client/tasks.txt`
4. **Training**: Fine-tune on custom datasets
5. **Deployment**: Set up GitHub Actions for CI/CD

---

## 🔗 Useful Links

- **Original Paper**: https://arxiv.org/abs/2402.07945
- **CogAgent**: https://github.com/THUDM/CogVLM
- **LLaVA**: https://github.com/haotian-liu/LLaVA
- **Mind2Web Dataset**: https://osu-nlp-group.github.io/Mind2Web/
- **VNC Documentation**: https://www.tightvnc.com/

---

## 📝 License

- Code: MIT
- Dataset: Apache-2.0
- Models: CogVLM License

---

**Last Updated**: December 26, 2025
**Maintainer**: akashBv6680
