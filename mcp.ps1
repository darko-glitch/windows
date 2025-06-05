# ==============================================================================
# STEP 2: INSTALL MCP (MODEL CONTEXT PROTOCOL) TOOLS
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