# 🍽️ Food Agent

A Claude-powered household food ordering agent. Plans weekly menus, orders groceries via Swiggy Instamart, tracks inventory, and responds to the household on WhatsApp.

**Current phase:** Phase 1 — Manual testing via Claude Desktop

---

## Quick Start

```bash
# 1. Clone / download this folder to your machine
cd food-agent

# 2. Run setup to verify everything is in place
bash scripts/setup.sh

# 3. Customise your data files (see Setup below)

# 4. Open Claude Desktop and configure MCPs (see Claude Desktop Setup below)

# 5. Start testing!
```

---

## Project Structure

```
food-agent/
├── data/                        # All state files (read/written by agent)
│   ├── config.json              # Household config, schedule, ordering rules
│   ├── preferences.json         # Per-person dislikes, allergies, cuisine prefs
│   ├── inventory.json           # Current kitchen stock + expiry dates
│   ├── recipes.json             # Recipe library (20 starter dishes included)
│   ├── menu.json                # Current week's menu + order schedule
│   ├── absences.json            # Who's away this week
│   ├── orders.json              # Full order history
│   ├── pending_orders.json      # Ad-hoc items waiting to be batched
│   ├── brand_preferences.json   # Preferred brands per ingredient
│   └── price_history.json       # Price tracking over time (stretch goal)
├── prompts/
│   └── system_prompt.md         # The agent's brain — paste into Claude Desktop
├── scripts/
│   └── setup.sh                 # Setup verification script
└── README.md
```

---

## Setup

### 1. Customise Your Data Files

**`data/config.json`** — Update with real names:
```json
{
  "household": {
    "members": ["Raj", "Priya", "Alice", "Bob", "Sam"],
    "default_count": 5,
    "cook_name": "Priya",
    "cook_phone": "+91XXXXXXXXXX"
  }
}
```

**`data/preferences.json`** — Update member names and add preferences:
```json
{
  "members": {
    "Raj": {
      "dislikes": ["Bitter Gourd"],
      "allergies": [],
      "cuisine_preference": ["South Indian"]
    }
  }
}
```

**`data/inventory.json`** — Update quantities to match your actual kitchen:
- Go through each item and update `quantity`
- Add items that are missing
- Update `expiry` dates where known

### 2. Claude Desktop MCP Configuration

Open Claude Desktop → **Settings → Integrations** → Add custom connectors:

#### Filesystem MCP
```
Type: stdio
Command: npx
Args: -y @modelcontextprotocol/server-filesystem /absolute/path/to/food-agent/data
```

Replace `/absolute/path/to/food-agent/data` with the actual full path on your machine.

**macOS example:** `/Users/yourname/food-agent/data`
**Linux example:** `/home/yourname/food-agent/data`

#### Swiggy Instamart MCP
```
Type: HTTP
URL: https://mcp.swiggy.com/im
```

Authenticate when prompted — you'll need to log in with your Swiggy account.

> ⚠️ Keep the Swiggy app **closed** on your phone while placing orders via Claude Desktop to avoid session conflicts.

### 3. Add System Prompt to Claude Desktop

1. Copy the entire contents of `prompts/system_prompt.md`
2. In Claude Desktop, create a new **Project**
3. Paste the system prompt into the project's **System Prompt** field
4. All conversations in this project will use the food agent behaviour

---

## Testing Guide

### Core flows to test in Phase 1:

#### Weekly Planning
```
You: run weekly planning
```
Agent will:
1. Read your recipes, inventory, preferences
2. Generate a 7-day menu
3. Ask for feedback
4. After you approve, show order schedule
5. For each order, show full ingredient list and ask for YES

#### Morning Briefing
```
You: morning briefing
```

#### Add a Recipe
```
You: Add recipe — Butter Chicken, North Indian, dinner, serves 4:
     500g chicken, 200ml cream, 3 tbsp butter, tomato puree,
     ginger garlic paste, kasuri methi, garam masala
```

#### Menu Change
```
You: Can we swap Thursday's dinner to Veg Biryani?
```

#### Report Absence
```
You: Raj is away Friday and Saturday
```

#### Ad-hoc Order
```
You: Order some Amul butter and 2L Nandini milk
```

#### Set Brand Preference
```
You: Always order Amul butter
You: We prefer Fortune sunflower oil
```

#### Inventory Correction
```
You: We ordered out last night, skip Tuesday's dinner deduction
You: We used up all the paneer
```

#### Check Expiring Items
```
You: What's expiring soon?
```

---

## Adding More Recipes

The starter set has 20 dishes. The agent needs at least 14 unique dishes to plan a full week without repeating (7 lunches + 7 dinners). 20 dishes gives reasonable variety.

Add more via Claude Desktop:
```
Add recipe — Aloo Methi, North Indian, lunch and dinner, serves 4:
300g fenugreek leaves, 3 medium potatoes, 1 onion, 
1 tsp cumin seeds, 1 tsp turmeric, 1 tsp red chilli powder, 
ginger garlic paste, 2 tbsp oil
```

---

## Phase Roadmap

| Phase | Status | What's included |
|-------|--------|----------------|
| **Phase 1** | ✅ Active | Claude Desktop, manual testing, Swiggy ordering |
| **Phase 2** | 🔜 Next | WhatsApp MCP, Swiggy proxy, cron automation |
| **Phase 3** | 🔜 Later | Mid-week changes, ad-hoc orders, monthly stock check |
| **Phase 4** | 🔜 Later | Auto brand locking, expiry alerts, price tracking |

---

## Known Constraints (Phase 1)

- **COD only** on Swiggy — someone must be home for every delivery
- **Orders cannot be cancelled** once placed on Swiggy — always review the ingredient list carefully before saying YES
- **Recipe library only** — agent will not plan dishes outside `recipes.json`
- **Manual trigger** — you need to open Claude Desktop and type "run weekly planning" each Sunday
- **No WhatsApp integration** yet — you interact directly with Claude Desktop

---

## Troubleshooting

**Agent doesn't know about my kitchen inventory:**
→ Make sure Filesystem MCP is connected and pointing to the right `data/` folder

**Swiggy items not found:**
→ Try more generic search terms — Swiggy Instamart search can be finicky with brand names

**Agent plans dishes not in my recipe library:**
→ Check that `recipes.json` is being read correctly via Filesystem MCP

**Menu ignores my preferences:**
→ Check member names in `preferences.json` exactly match names in `config.json`
