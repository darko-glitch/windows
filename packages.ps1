# ==============================================================================
# STEP 1: INSTALL ESSENTIAL SOFTWARE VIA CHOCOLATEY
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