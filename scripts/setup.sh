#!/bin/bash

# Food Agent — Setup Script
# Run once to verify your environment is ready for Phase 1 testing

set -e

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

echo ""
echo -e "${BOLD}🍽️  Food Agent — Phase 1 Setup${RESET}"
echo "================================="
echo ""

# Check data directory
echo -e "${BOLD}Checking data files...${RESET}"

FILES=(
  "data/config.json"
  "data/preferences.json"
  "data/inventory.json"
  "data/recipes.json"
  "data/menu.json"
  "data/absences.json"
  "data/orders.json"
  "data/pending_orders.json"
  "data/brand_preferences.json"
  "data/price_history.json"
)

ALL_OK=true
for FILE in "${FILES[@]}"; do
  if [ -f "$FILE" ]; then
    echo -e "  ${GREEN}✓${RESET} $FILE"
  else
    echo -e "  ${RED}✗${RESET} $FILE — MISSING"
    ALL_OK=false
  fi
done

echo ""

if [ "$ALL_OK" = false ]; then
  echo -e "${RED}Some data files are missing. Make sure you're running this from the food-agent/ directory.${RESET}"
  exit 1
fi

# Check recipe count
RECIPE_COUNT=$(python3 -c "import json; data=json.load(open('data/recipes.json')); print(len(data['recipes']))" 2>/dev/null || echo "0")
echo -e "${BOLD}Recipe library:${RESET} $RECIPE_COUNT dishes"
if [ "$RECIPE_COUNT" -lt 10 ]; then
  echo -e "  ${YELLOW}⚠️  Add more recipes before planning a full week (minimum 10 recommended)${RESET}"
else
  echo -e "  ${GREEN}✓${RESET} Enough recipes to plan a week"
fi

echo ""

# Check system prompt
echo -e "${BOLD}Checking system prompt...${RESET}"
if [ -f "prompts/system_prompt.md" ]; then
  PROMPT_LINES=$(wc -l < prompts/system_prompt.md)
  echo -e "  ${GREEN}✓${RESET} prompts/system_prompt.md ($PROMPT_LINES lines)"
else
  echo -e "  ${RED}✗${RESET} prompts/system_prompt.md — MISSING"
fi

echo ""

# Remind user to customise config
echo -e "${BOLD}⚙️  Before you start — customise these:${RESET}"
echo ""
echo -e "  1. ${YELLOW}data/config.json${RESET}"
echo "     → Replace Member1-5 with real names"
echo "     → Set cook_name and cook_phone"
echo ""
echo -e "  2. ${YELLOW}data/preferences.json${RESET}"
echo "     → Update member names to match config.json"
echo "     → Add any dislikes or allergies per person"
echo "     → Set cuisine preferences if desired"
echo ""
echo -e "  3. ${YELLOW}data/inventory.json${RESET}"
echo "     → Update quantities to reflect what's actually in your kitchen"
echo "     → Add any items that are missing from the list"
echo ""
echo -e "  4. ${YELLOW}data/recipes.json${RESET}"
echo "     → 20 starter recipes are included"
echo "     → Add more via Claude Desktop: 'Add recipe — [name], [cuisine]...'"
echo ""

# Claude Desktop setup instructions
echo -e "${BOLD}🖥️  Claude Desktop Setup:${RESET}"
echo ""
echo "  1. Open Claude Desktop"
echo "  2. Go to Settings → Integrations"
echo "  3. Add the following MCP servers:"
echo ""
echo "     Filesystem MCP:"
echo "     Command: npx"
echo "     Args: -y @modelcontextprotocol/server-filesystem $(pwd)/data"
echo ""
echo "     Swiggy Instamart MCP:"
echo "     Type: HTTP"  
echo "     URL: https://mcp.swiggy.com/im"
echo ""
echo "  4. Copy the contents of prompts/system_prompt.md"
echo "     into Claude Desktop as a Project System Prompt"
echo ""
echo "  5. Authenticate Swiggy when prompted"
echo ""

echo -e "${BOLD}🧪  Phase 1 Test Checklist:${RESET}"
echo ""
echo "  □ Run weekly planning:  type 'run weekly planning'"
echo "  □ Check morning briefing: type 'morning briefing'"
echo "  □ Add a recipe: 'Add recipe — Butter Chicken, North Indian, dinner...'"
echo "  □ Request a menu change: 'Can we swap Wednesday's lunch?'"
echo "  □ Report absence: 'Member1 is away Thursday and Friday'"
echo "  □ Ad-hoc order: 'Order some Amul butter'"
echo "  □ Set brand preference: 'Always order Amul butter'"
echo "  □ Check inventory: 'What's expiring soon?'"
echo ""

echo -e "${GREEN}${BOLD}✅ Setup complete! You're ready for Phase 1 testing.${RESET}"
echo ""
echo "  See README.md for full testing guide."
echo ""
