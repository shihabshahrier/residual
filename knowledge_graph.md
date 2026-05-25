# Codebase Knowledge Graph

This document maps out the core architecture, singletons, node interactions, and system dependencies for **RESIDUAL**.

## 1. Core Architecture (Planned)

### Singletons / Autoloads
- **GameManager**: Handles global game state, scene transitions, and pause state.
- **TemporalManager**: Manages the `Rewindable` objects circular buffers and triggers global or localized snapshot state saving/loading.
- **EpistemicManager**: Stores the current state of the Clue Board (Epistemic Graph), unlocked deductions, and tracks hypotheses.

### Node Groups
- `rewindable`: Any physics or state-based node that implements `save_state()` and `load_state()`.
- `interactable`: Any object the player can scan or inspect.
- `dialogue_npc`: NPCs containing localized Dialogue Manager state.

## 2. Directory Structure

```
res://
├── addons/          # GUT, Dialogue Manager
├── ai/              # (Optional) AI generation configurations/scripts
├── art/             # 2.5D billboards, textures
├── audio/           # Sound effects, ambient tracks
├── autoload/        # Singletons (GameManager, etc.)
├── dialogue/        # Godot Dialogue Manager (.dialogue files)
├── levels/          # Scenes (Vesper Archive zones)
├── shaders/         # Vestige scanner shaders, fog, post-processing
├── systems/         # Core mechanics (Temporal, Epistemic, Scanner)
├── tests/           # GUT test scripts
└── ui/              # Clue board, HUD, Menus
```

## 3. Data Flow
- **Input -> PlayerController -> TemporalManager** (Triggering Palimpsest scans)
- **TemporalManager -> SubViewport** (Rendering Vestige layers to main camera)
- **Clue Discovery -> EpistemicManager -> DialogueManager** (Unlocking new dialogue branches)
