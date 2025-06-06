# ==============================================================================
# STEP 1: SETUP PYTHON ENVIRONMENT
# ==============================================================================
# Install and set Python 3.13 as global version
pyenv update
pyenv install 3.13
pyenv global 3.13

# Create dedicated virtual environment for MCP tools
python -m venv C:\Users\ahmad\Documents\mcp\python

# ==============================================================================
# STEP 2: SETUP NODE.JS ENVIRONMENT
# ==============================================================================
# Install and use latest stable Node.js
nvm install lts
nvm use lts
npm install -g npm@11.4.1