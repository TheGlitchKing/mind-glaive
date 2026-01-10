#!/bin/bash
# mind-glaive Plugin Installer
#
# Usage:
#   ./install.sh --scope user --template full-stack
#   ./install.sh --scope project --template minimal
#   ./install.sh --help

set -e

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Defaults
SCOPE="user"
TEMPLATE="minimal"
INSTALL_DIR=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --scope) SCOPE="$2"; shift 2 ;;
        --template) TEMPLATE="$2"; shift 2 ;;
        --help)
            cat << 'HELP'
mind-glaive Installer

Usage: ./install.sh [OPTIONS]

Options:
  --scope {user|project}    Install scope (default: user)
  --template {template}     Template type (minimal, full-stack, data-science)
  --help                    Show this help

Examples:
  ./install.sh --scope user --template full-stack
  ./install.sh --scope project --template minimal

Templates:
  minimal       - Small projects, learning (1KB)
  full-stack    - Web applications (8KB)
  data-science  - ML/research projects (6KB)

Scopes:
  user          - Install globally (~/.claude/)
  project       - Install in current project (.claude/)
HELP
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

# Determine install directory
if [ "$SCOPE" = "user" ]; then
    INSTALL_DIR="$HOME/.claude"
elif [ "$SCOPE" = "project" ]; then
    INSTALL_DIR=".claude"
else
    echo -e "${RED}❌ Invalid scope: $SCOPE${NC}"
    exit 1
fi

# Validate template
TEMPLATE_PATH="./templates/$TEMPLATE"
if [ ! -d "$TEMPLATE_PATH" ]; then
    echo -e "${RED}❌ Template not found: $TEMPLATE${NC}"
    echo "Available: minimal, full-stack, data-science"
    exit 1
fi

echo -e "${BLUE}mind-glaive Plugin Installer${NC}"
echo "=============================="
echo ""
echo -e "${GREEN}Installation Details:${NC}"
echo "  Scope: $SCOPE ($INSTALL_DIR)"
echo "  Template: $TEMPLATE"
echo ""

# Create directory structure
echo -e "${BLUE}Creating directories...${NC}"
mkdir -p "$INSTALL_DIR"/{rules,archives,context,commands,agents}
mkdir -p "$INSTALL_DIR/commands"/{context,learn,resume}

# Copy template CLAUDE.md
echo -e "${BLUE}Installing template...${NC}"
cp "$TEMPLATE_PATH/CLAUDE.md" "$INSTALL_DIR/CLAUDE.md"
echo -e "${GREEN}✓ Template copied${NC}"

# Copy rules
if [ -d "$TEMPLATE_PATH/rules" ]; then
    cp -r "$TEMPLATE_PATH/rules/"* "$INSTALL_DIR/rules/" 2>/dev/null || true
    echo -e "${GREEN}✓ Rules installed${NC}"
fi

# Copy hooks (user scope only)
if [ "$SCOPE" = "user" ]; then
    echo -e "${BLUE}Installing hooks...${NC}"
    cp ./hooks/default-hooks.json "$INSTALL_DIR/hooks.json" 2>/dev/null || true
    cp -r ./scripts/*.sh "$INSTALL_DIR/" 2>/dev/null || true
    echo -e "${GREEN}✓ Hooks installed${NC}"
fi

# Copy commands (user scope only)
if [ "$SCOPE" = "user" ]; then
    echo -e "${BLUE}Installing commands...${NC}"
    cp -r ./commands/* "$INSTALL_DIR/commands/" 2>/dev/null || true
    echo -e "${GREEN}✓ Commands installed${NC}"
fi

# Copy agents (user scope only)
if [ "$SCOPE" = "user" ]; then
    echo -e "${BLUE}Installing agents...${NC}"
    cp -r ./agents/*.md "$INSTALL_DIR/" 2>/dev/null || true
    echo -e "${GREEN}✓ Agents installed${NC}"
fi

# Add to .gitignore if project scope
if [ "$SCOPE" = "project" ]; then
    echo -e "${BLUE}Updating .gitignore...${NC}"
    if [ ! -f ".gitignore" ]; then
        touch .gitignore
    fi
    grep -q ".claude/" .gitignore || echo ".claude/" >> .gitignore
    echo -e "${GREEN}✓ .gitignore updated${NC}"
fi

echo ""
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "  1. Edit your context: ${YELLOW}claude /memory${NC}"
echo "  2. Check status: ${YELLOW}/context/status${NC}"
echo "  3. Review templates: ${YELLOW}ls $INSTALL_DIR/${NC}"
echo ""
echo -e "${BLUE}Documentation:${NC}"
echo "  - ./README.md - Project overview"
echo "  - ./docs/LAYER_1_MEMORY.md - Memory system guide"
echo "  - ./templates/README.md - Template reference"
echo ""
