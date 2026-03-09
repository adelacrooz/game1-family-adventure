# Pico-8 Development Workflow in Cursor

This guide explains how to develop Pico-8 games in Cursor with the full edit-run cycle.

---

## 1. Install the Pico-8 Extension

1. Open the Extensions panel (`Cmd+Shift+X` on Mac, `Ctrl+Shift+X` on Windows/Linux).
2. Search for **"Pico-8"** or **"pico8-ls"**.
3. Install one of them for syntax highlighting and autocomplete.

---

## 2. Add a Cart to the Project

A starter cart `game1.p8` is included. It has a movable circle (arrow keys) and the standard `_init`, `_update`, and `_draw` callbacks. The **Run Pico-8** task loads `game1.p8` by default. To use a different file, edit `.vscode/tasks.json` and change the path in the `args` array.

---

## 3. Edit in Cursor

Edit your cartridge code in Cursor and save often. All changes are written to the file immediately, so Pico-8 can reload them.

---

## 4. Launch Pico-8 with the Run Pico-8 Task

Use the built-in task to open Pico-8 with your cart:

1. **Command Palette:** `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
2. Run **Tasks: Run Task**
3. Choose **Run Pico-8**

**Shortcut:** `Cmd+Shift+B` (Mac) or `Ctrl+Shift+B` (Windows/Linux) runs the default build task, which is set to **Run Pico-8**.

Pico-8 starts with your cart loaded and saves go directly to your project folder.

---

## 5. Edit → Save → Reload → Run

1. **Edit** your `.p8` in Cursor.
2. **Save** the file (`Cmd+S` / `Ctrl+S`).
3. In Pico-8, press **`Cmd+R`** (Mac) or **`Ctrl+R`** (Linux/Windows) to **reload** the cart.
4. Press **`Cmd+Enter`** (Mac) or **`Ctrl+Enter`** (Linux/Windows) to **run** the game.

Pico-8 stays open while you iterate; reload after each save to test your latest changes.

---

## 6. Capture a Label (for HTML Export)

Before exporting to HTML (e.g. for itch.io or GitHub Pages), you must capture a **label** — the 128×128 preview image that Pico-8 uses in the web export.

1. **Run** your game (`Cmd+Enter` / `Ctrl+Enter`).
2. Let the game show the screen you want as the preview (gameplay, title, etc.).
3. Press **F7** (or **Ctrl+7** on Mac) to capture the current screen as the label.
4. Press **Esc** to open the command line.
5. Run `export game1.html` (or your cart name) — the export should succeed.

**Note:** Typing `label` in the command line gives a syntax error; the label is captured via the keyboard shortcut, not a command.

---

## Custom Tasks

Tasks are defined in `.vscode/tasks.json`. To run a task: open the Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`), choose **Tasks: Run Task**, then pick the task.

### Run Pico-8

| Property | Value |
|----------|-------|
| **Label** | Run Pico-8 |
| **Shortcut** | `Cmd+Shift+B` (Mac) / `Ctrl+Shift+B` (Windows/Linux) |
| **Action** | Launches the Pico-8 app witHa!h `game1.p8` loaded |

**Command:** `/Applications/PICO-8.app/Contents/MacOS/pico8 "${workspaceFolder}/game1.p8"` (macOS)

This task is set as the default build task, so it runs when you use the build shortcut. Pico-8 opens with your cart ready to edit and run. Saves in Pico-8 write directly to `game1.p8` in your project folder.

**To load a different cart:** Edit `.vscode/tasks.json` and change the path in the `args` array, e.g. `"${workspaceFolder}/mygame.p8"`.
