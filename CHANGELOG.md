# v2.0.1

- Fixed overlay counting unrelated spells (e.g., Disenchant) while a tradeskill window is open
- Fixed clicking a different recipe mid-batch breaking the progress tracker
- Fixed config panel error on newer Classic builds (Settings API compatibility)
- Fixed overlay not showing by reparenting to the tradeskill frame with correct strata

# v2.0.0

- Added crafting batch progress overlay showing "5/20 crafted" on the tradeskill window
- Added estimated time remaining during crafting batches
- Added optional auto-close tradeskill window when batch finishes (off by default)
- Added taskbar flash triggers for: auction sold, rare spawns, summon requests, ready checks, resurrect requests, trade windows, and BG queue pops
- Added settings panel with per-trigger toggles — type `/craftflash` or `/cf` to open
- All settings persist across reloads via SavedVariables

# v1.0.0

- Initial release
- Flash taskbar when a crafting batch completes or is interrupted by a full inventory
