#!/bin/bash
# ScreenAgent Quick Start Script
# For: akashBv6680/ScreenAgent
# Date: December 26, 2025

set -e

echo "====================================="
echo "ScreenAgent Quick Start Installation"
echo "====================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Python version
echo -e "${YELLOW}[1/6] Checking Python installation...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Python 3 not found. Please install Python 3.8+${NC}"
    exit 1
fi
PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
echo -e "${GREEN}✓ Python ${PYTHON_VERSION} found${NC}"
echo ""

# Create virtual environment
echo -e "${YELLOW}[2/6] Creating virtual environment...${NC}"
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo -e "${GREEN}✓ Virtual environment created${NC}"
else
    echo -e "${GREEN}✓ Virtual environment already exists${NC}"
fi
echo ""

# Activate virtual environment
echo -e "${YELLOW}[3/6] Activating virtual environment...${NC}"
source venv/bin/activate
echo -e "${GREEN}✓ Virtual environment activated${NC}"
echo ""

# Upgrade pip
echo -e "${YELLOW}[4/6] Upgrading pip...${NC}"
pip install --upgrade pip setuptools wheel -q
echo -e "${GREEN}✓ pip upgraded${NC}"
echo ""

# Install dependencies
echo -e "${YELLOW}[5/6] Installing dependencies...${NC}"
if [ -f "client/requirements.txt" ]; then
    pip install -r client/requirements.txt -q
    echo -e "${GREEN}✓ Dependencies installed${NC}"
else
    echo -e "${RED}⚠ client/requirements.txt not found${NC}"
fi
echo ""

# Setup configuration
echo -e "${YELLOW}[6/6] Setting up configuration...${NC}"
if [ ! -f "client/config.yml" ]; then
    echo -e "${YELLOW}ℹ No config.yml found. Creating template...${NC}"
    cat > client/config.yml << 'EOF'
# ScreenAgent Configuration
# Update this file with your VNC and LLM settings

remote_vnc_server:
  host: "127.0.0.1"
  port: 5900
  password: "your_vnc_password"
  clipboard_server_url: "http://localhost:8001"
  clipboard_token: "your_clipboard_token"

# Choose ONE LLM option below (uncomment to use)

llm_api:
  # Option 1: GPT-4V (requires OpenAI API key)
  GPT4V:
    model_name: "gpt-4-vision-preview"
    openai_api_key: "your_openai_api_key_here"
    target_url: "https://api.openai.com/v1/chat/completions"

  # Common settings for all models
  temperature: 1.0
  top_p: 0.9
  max_tokens: 500
EOF
    echo -e "${GREEN}✓ Configuration template created at client/config.yml${NC}"
    echo -e "${YELLOW}⚠ Please edit client/config.yml with your settings before running${NC}"
else
    echo -e "${GREEN}✓ client/config.yml already exists${NC}"
fi
echo ""

echo "====================================="
echo -e "${GREEN}Installation Complete!${NC}"
echo "====================================="
echo ""
echo "Next steps:"
echo "1. Edit client/config.yml with your settings"
echo "2. Make sure your VNC server is running"
echo "3. Start clipboard service: python client/clipboard_server.py"
echo "4. Run controller: python client/run_controller.py -c client/config.yml"
echo ""
echo "For detailed setup instructions, see SETUP_GUIDE.md"
echo ""
echo -e "${GREEN}Happy automating! 🚀${NC}"
