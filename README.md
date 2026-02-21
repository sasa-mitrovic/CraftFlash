# CraftFlash

A lightweight World of Warcraft TBC Classic addon that flashes your Windows taskbar icon when a crafting batch completes or is interrupted by a full inventory.

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
   ```
4. Enable the addon from the character select screen addon list
5. No configuration needed — it works automatically

## How It Works

1. When you start a craft with your tradeskill window open, the addon begins tracking the batch
2. Each successful craft resets a short timer (1.5 seconds by default)
3. When no new craft starts within that window, the batch is considered done and your taskbar flashes
4. If crafting is interrupted due to a full inventory, the taskbar flashes immediately
5. The flash only appears when WoW is not your active window — if you're already looking at the game, nothing happens

## Supported Tradeskills

All professions that use the standard tradeskill or craft frames, including:

- Alchemy, Blacksmithing, Cooking, Engineering, Jewelcrafting, Leatherworking, Tailoring
- Enchanting (uses the separate craft frame)
- First Aid

## Configuration

The `BATCH_DELAY` value at the top of `CraftFlash.lua` controls how long the addon waits after the last successful craft before flashing. The default is `1.5` seconds. Increase this if you experience false flashes between crafts.
