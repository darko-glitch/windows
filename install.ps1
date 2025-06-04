# Windows Development Environment Setup Script
# This script installs and configures a complete development environment

# ==============================================================================
# STEP 1: CONFIGURE POWERSHELL EXECUTION POLICY
# ==============================================================================
# Check current execution policy and set if needed
$currentPolicy = Get-ExecutionPolicy
Write-Host "Current execution policy: $currentPolicy"

if ($currentPolicy -eq "Restricted") {
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Host "Execution policy updated to RemoteSigned for CurrentUser"
    } catch {
        Write-Host "Could not change execution policy. Current policy should still allow script execution."
    }
} else {
    Write-Host "Execution policy is already permissive ($currentPolicy)"
}

# ==============================================================================
# STEP 2: INSTALL CHOCOLATEY PACKAGE MANAGER
# ==============================================================================
# Install Chocolatey with security protocols enabled
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# ==============================================================================
# STEP 3: INSTALL PYENV FOR PYTHON VERSION MANAGEMENT
# ==============================================================================
# Install pyenv-win via Chocolatey (moved to Step 4 with other choco installs)

# ==============================================================================
# STEP 3: INSTALL ESSENTIAL SOFTWARE VIA CHOCOLATEY
# ==============================================================================
# Runtime and development dependencies
choco install vcredist140 -y                 # Visual C++ Redistributable
choco install jre8 -y                        # Java Runtime Environment

# Productivity tools
choco install notepadplusplus.install -y     # Text editor
choco install winrar -y                      # Archive manager
choco install firefox -y                     # Web browser
choco install libreoffice-fresh -y           # Office suite
choco install claude -y                      # AI assistant

# Development tools
choco install git.install -y                 # Version control
choco install putty.install -y               # SSH client
choco install virtualbox -y                  # Virtualization platform
choco install vscodium -y                    # Code editor

# Environment managers
choco install nvm -y                         # Node Version Manager
choco install podman-cli -y                  # Container management
choco install pyenv-win -y                   # Python Version Manager

# ==============================================================================
# STEP 5: SETUP PYTHON ENVIRONMENT
# ==============================================================================
# Install and set Python 3.13 as global version
pyenv install 3.13
pyenv global 3.13

# Create dedicated virtual environment for MCP tools
python -m venv C:\Users\ahmad\Documents\env\mcp

# Upgrade pip and install MCP Python packages
C:\Users\ahmad\Documents\env\mcp\Scripts\python.exe -m pip install --upgrade pip
C:\Users\ahmad\Documents\env\mcp\Scripts\python.exe -m pip install mcp-server-git mcp-server-fetch mcp_server_time

# ==============================================================================
# STEP 5: SETUP NODE.JS ENVIRONMENT
# ==============================================================================
# Install and use latest stable Node.js
nvm install lts
nvm use lts
npm install -g npm@11.4.1

# ==============================================================================
# STEP 6: INSTALL MCP (MODEL CONTEXT PROTOCOL) TOOLS
# ==============================================================================
# Core MCP servers
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-sequential-thinking
npm install -g @modelcontextprotocol/server-memory
npm install -g @modelcontextprotocol/server-github

# Additional MCP tools
npm install -g @upstash/context7-mcp@latest      # Context/memory system
npm install -g @kazuph/mcp-fetch                 # Fetch capabilities

# Desktop automation setup
npx @wonderwhy-er/desktop-commander@latest setup

# ==============================================================================
# STEP 7: SETUP COMPLETE
# ==============================================================================
# Your development environment is now ready with:
# - Python 3.13 with MCP tools
# - Node.js LTS with MCP servers
# - Essential development and productivity software