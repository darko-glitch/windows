# ==============================================================================
# STEP 1: INSTALL MCP (MODEL CONTEXT PROTOCOL) TOOLS
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
# STEP 2: INSTALL MCP (MODEL CONTEXT PROTOCOL) TOOLS
# ==============================================================================
# Core python MCP servers
# Set the Python path as a variable for reuse
$PythonPath = "$env:USERPROFILE\Documents\mcp\python\Scripts\python.exe"

# Install commands
& $PythonPath -m pip install --upgrade pip
& $PythonPath -m pip install mcp-neo4j-cypher mcp-server-git mcp-server-fetch mcp-server-time mcp-neo4j-memory