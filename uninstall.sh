#!/bin/bash
# Context Preservation System Uninstaller
#
# Cleanly removes CPS without deleting user data

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Context Preservation System Uninstaller${NC}"
echo "========================================"
echo ""

# Ask which scope to uninstall
echo -e "${YELLOW}Which scope to uninstall?${NC}"
echo "  1) User (\$HOME/.claude) - RECOMMENDED"
echo "  2) Project (.claude)"
echo "  3) Both"
echo "  4) Cancel"
read -p "Enter choice [1-4]: " CHOICE

case $CHOICE in
    1) SCOPES=("user") ;;
    2) SCOPES=("project") ;;
    3) SCOPES=("user" "project") ;;
    4) echo "Cancelled"; exit 0 ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

for SCOPE in "${SCOPES[@]}"; do
    if [ "$SCOPE" = "user" ]; then
        REMOVE_DIR="$HOME/.claude"
    else
        REMOVE_DIR=".claude"
    fi

    if [ ! -d "$REMOVE_DIR" ]; then
        echo -e "${YELLOW}⚠️  Directory not found: $REMOVE_DIR${NC}"
        continue
    fi

    echo ""
    echo -e "${YELLOW}Backing up...${NC}"
    BACKUP_FILE="claude-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    tar -czf "$BACKUP_FILE" "$REMOVE_DIR" 2>/dev/null || true
    echo -e "${GREEN}✓ Backup created: $BACKUP_FILE${NC}"

    echo -e "${YELLOW}Removing $SCOPE scope...${NC}"
    rm -rf "$REMOVE_DIR"
    echo -e "${GREEN}✓ Removed: $REMOVE_DIR${NC}"
done

echo ""
echo -e "${GREEN}✅ Uninstall Complete!${NC}"
echo ""
echo "Your backup is available for restore:"
echo "  tar -xzf claude-backup-*.tar.gz"
echo ""
