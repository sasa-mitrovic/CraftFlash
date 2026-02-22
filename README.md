# CraftFlash

A World of Warcraft TBC Classic addon that flashes your Windows taskbar icon for crafting completions and important game events — your alt-tab buddy.

## Features

### Crafting
- **Batch complete flash** — taskbar flashes when your crafting queue finishes or is interrupted by a full inventory
- **Progress overlay** — shows "5/20 crafted" on the tradeskill window during a batch
- **ETA display** — estimated time remaining based on cast duration (e.g., "~45s remaining")
- **Auto-close tradeskill window** — optionally close the crafting window when the batch finishes (off by default)

### Alert Triggers
All of the following flash your taskbar when they occur:
- **Auction sold** — an item you listed on the AH sells
- **Auction outbid** — you've been outbid on an auction
- **Rare spawn** — a rare or rare-elite mob appears on your nameplates
- **Summon request** — a warlock summon or meeting stone summon
- **Ready check** — a raid/party leader starts a ready check
- **Resurrect request** — someone casts a resurrection on you
- **Trade request** — another player opens a trade window with you
- **BG queue pop** — a battleground queue is ready to join

Every trigger can be individually toggled on or off in the settings panel.

## Installation

1. Download or clone this repository
2. Copy the `CraftFlash` folder into your WoW addons directory:
   ```
   World of Warcraft\_classic_\Interface\AddOns\CraftFlash\
   ```
3. The folder should contain:
   ```
   CraftFlash/
     CraftFlash_TBC.toc
     CraftFlash.lua
     CraftFlash_Crafting.lua
     CraftFlash_Alerts.lua
     CraftFlash_Config.lua
   ```
4. Enable the addon from the character select screen addon list

## Configuration

Type `/craftflash` or `/cf` to open the settings panel, or find **CraftFlash** in Interface → AddOns.

All settings persist across reloads and sessions.

## How It Works

1. When you start a craft with your tradeskill window open, the addon tracks the batch and shows progress
2. Each successful craft updates the counter and resets a short completion timer (1.5 seconds)
3. When no new craft starts within that window, the batch is considered done and your taskbar flashes
4. If crafting is interrupted due to a full inventory, the taskbar flashes immediately
5. Non-crafting triggers (auctions, rare spawns, etc.) each listen for their specific game events

The flash only appears when WoW is not your active window — if you're already looking at the game, nothing happens.

## Supported Tradeskills

All professions that use the standard tradeskill or craft frames, including:

- Alchemy, Blacksmithing, Cooking, Engineering, Jewelcrafting, Leatherworking, Tailoring
- Enchanting (uses the separate craft frame)
- First Aid
