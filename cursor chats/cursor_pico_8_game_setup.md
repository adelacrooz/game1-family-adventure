# Pico-8 game setup
_Exported on 3/8/2026 at 16:44:58 PDT from Cursor (2.5.26)_

---

**User**

I'd like to make a Pico-8 game. Can you help me get set up?

---

**Cursor**

Checking your workspace for existing Pico-8 setup.


Here’s a short Pico-8 setup guide and what to do in your workspace.

---

## 1. Install Pico-8

- Buy Pico-8 at [lexaloffle.com](https://www.lexaloffle.com/pico-8.php) ($14.99).
- You get downloads for Windows, Mac, Linux, and Raspberry Pi.
- On **macOS**, unzip and put the Pico-8 app in your Applications folder (or anywhere you like).

---

## 2. Where Pico-8 stores files

Pico-8 uses a **carts folder** for your games:

- **macOS:** `~/Library/Application Support/pico-8/carts/`
- **Windows:** `%APPDATA%\pico-8\carts\`
- **Linux:** `~/.lexaloffle/pico-8/carts/`

Cartridge files use the `.p8` extension. You can work in the built-in editor or in an external editor like Cursor.

---

## 3. Development options

**A. Built-in Pico-8 editor**

- Run Pico-8 and use its built-in code, sprite, map, and sound editors.
- Type `load` to load a cart, `save` to save, `run` to play.

**B. Cursor/VS Code + external carts folder**

- For better editing in Cursor, you can either:
  - Use your workspace as a project folder and point Pico-8 at it, or  
  - Symlink your project folder into `carts`.
- Install the **Pico-8** or **pico8-ls** extension for syntax highlighting and basic tooling.

---

## 4. Basic cartridge format

A minimal `.p8` cart looks like:

```lua
-- game name
pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
  x=64
  y=64
end

function _update()
  if btn(0) then x-=1 end
  if btn(1) then x+=1 end
  if btn(2) then y-=1 end
  if btn(3) then y+=1 end
end

function _draw()
  cls()
  spr(1,x,y)
  print("hello world",32,64,7)
end
```

`_init`, `_update`, and `_draw` are the main lifecycle functions.

---

## Suggested next steps

If you tell me:

1. Whether Pico-8 is already installed  
2. Whether you want to work in Cursor or inside Pico-8  

I can:

- Create a starter `.p8` cartridge in your project folder  
- Add a README with setup steps  
- Add a simple `.p8` that draws a moving sprite (or a small “hello world” game)  

Say what you prefer and we’ll set it up.

---

**User**

I have Pico-8 installed already, and I want to work in Cursor.

---

**Cursor**

Here’s how to work in Cursor with Pico-8:

---

## 1. Cursor extension for Pico-8

Search in the Extensions panel for **“Pico-8”** or **“pico8-ls”** and install one. They add:

- Syntax highlighting for `.p8` and Lua
- Autocomplete for Pico-8 APIs
- Optional snippets

---

## 2. Keep your cart in your project folder

You can keep `.p8` files directly in your workspace. Pico-8 can load and save carts from any path.

---

## 3. Two ways to run your game

**A. From the terminal** (recommended)

```bash
pico8 "/Users/andredelacruz/Coding/Game experiments/Game 1/game1.p8"
```

Put your `.p8` path in that command and run it when you want to test. Add it as a script or task if you prefer.

**B. From inside Pico-8**

In the Pico-8 prompt:

```
load /users/andredelacruz/coding/game experiments/game 1/game1.p8
```

(Pico-8 uses lowercase paths.)

---

## 4. Suggested workflow

1. Edit your `.p8` in Cursor.
2. Save the file.
3. In Pico-8, press **Ctrl+R** (or **Cmd+R** on Mac) to reload the cart.
4. Run with **Ctrl+Enter** (or **Cmd+Enter**).

If Pico-8 is opened with your cart path (terminal method), it will load and save directly from your project folder.

---

## 5. Optional: Cursor task to launch Pico-8

You can add a Cursor task so you can run Pico-8 with your cart from inside the editor. I can suggest a `.vscode/tasks.json` for that if you want.

I can also create a starter `game1.p8` in your project folder and show the exact terminal command for your setup—say if you want that.

---

**User**

Yes, create a custom task and explain how to use it. Then also document this workflow from steps 1 to 5 in a new Markdown file.

---

**Cursor**

Here's what was set up:

## Custom Task: **Run Pico-8**

**How to use it**

1. **Run Task**
   - `Cmd+Shift+P` → “Tasks: Run Task” → choose **Run Pico-8**
   - Or `Cmd+Shift+B` (default build task)

2. **Behavior**
   - Runs `open -a PICO-8 game1.p8` and launches Pico-8 with your cart loaded.
   - The task points to `game1.p8` in your project folder.  
   - If your cart has a different name or path, edit `.vscode/tasks.json` and change the path in the `args` array.

3. **After it runs**
   - Pico-8 opens with your cart already loaded.
   - Edit in Cursor → Save → press `Cmd+R` in Pico-8 to reload → `Cmd+Enter` to run.

---

## Documentation

`PICO8-WORKFLOW.md` is a step-by-step guide that covers:

- Installing the Pico-8 extension  
- Adding your cart to the project  
- Editing in Cursor  
- Launching with the Run Pico-8 task  
- The edit → save → reload → run loop  

One more thing: the task expects a `game1.p8` file. Should I add a minimal starter cart for `game1.p8` so the task works immediately?

---

**User**

Please add the starter cart and also document the custom tasks for PICO-8 in our markdown file

---

**Cursor**

Here’s what was added and updated:

## Starter cart: `game1.p8`

Basic Pico-8 cart with:

- A circle that moves with the arrow keys
- Standard callbacks: `_init`, `_update`, `_draw`
- All required cartridge sections (gfx, map, sfx, music, etc.)

You can run it with the **Run Pico-8** task to test the setup.

---

## Custom Tasks section in `PICO8-WORKFLOW.md`

The workflow doc now includes a **Custom Tasks** section with:

- A table for the **Run Pico-8** task (label, shortcut, action)
- The underlying command
- How it relates to the default build task
- Instructions for changing which cart it loads

---

**User**

the run task command does not seem to open the .p8 file

---

**Cursor**


Checking how Pico-8 is invoked on macOS and which command works.



Using the `pico8` binary instead of `open -a`. Updating the task.



The task was failing because `open -a PICO-8 file.p8` doesn’t reliably pass the cart to Pico-8 on macOS.

It’s now updated to call the Pico-8 binary directly:

```
/Applications/PICO-8.app/Contents/MacOS/pico8 "${workspaceFolder}/game1.p8"
```

Run the task again with `Cmd+Shift+B` or **Tasks: Run Task** → **Run Pico-8**; Pico-8 should open with `game1.p8` loaded.

`PICO8-WORKFLOW.md` has also been updated with this command.

---

**User**

What's the shortcut to run the game on pico8?

---

**Cursor**


In Pico-8, press **`Cmd+Enter`** (Mac) or **`Ctrl+Enter`** (Windows/Linux) to run the loaded cart.

