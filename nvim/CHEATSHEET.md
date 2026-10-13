# Neovim Keys

Space is the leader. Search this sheet with /  (n / N = next / previous match), close with q.
Space s K = fuzzy-search these lines.   Space ? = keys of the current file.   Space s k = all live keymaps.
Tags: [rust] Rust files  [c/c++] C and C++ files  [git] files in a git repo  [visual] after selecting  [insert] while typing

## Learn these first
  Space Space                    Find a file
  Space /                        Search text in the project
  Space ,                        Switch between open files
  Space e                        File explorer sidebar
  -                              Open the folder as an editable list (oil)
  Shift+h / Shift+l              Previous / next open file
  g d                            Go to definition
  g r                            Find references
  K                              Show documentation
  Space c a                      Code action (quick fixes, imports)
  Space c r                      Rename symbol everywhere
  s                              Jump anywhere: type 2 letters, then the label
  Space a c                      Open Claude Code
  Ctrl+s                         Save (and format)
  Ctrl+/                         Comment / uncomment
  ] d / [ d                      Next / previous problem
  Space g g                      Lazygit
  Space K                        This cheat sheet inside Neovim

## AI  (Space a)  - Claude Code and Codex

### Claude Code
  Space a c                      Open / close Claude panel
  Space a f                      Focus Claude panel
  Space a b                      Add this file to the conversation
  Space a s                      Send selection to Claude  [visual]
  Space a s                      Add file under cursor (in oil or explorer)
  Space a a                      Accept Claude’s edit (or :w in the diff)
  Space a d                      Reject Claude’s edit (or :q in the diff)
  Space a D                      Close all pending diffs
  Space a C                      Continue the last conversation
  Space a r                      Resume a past conversation
  Space a m                      Choose model
  Space a S                      Connection status

### Codex
  Space a o                      Open Codex
  Space a t                      Toggle Codex terminal
  Space a p                      Send file path
  Space a x                      Send selection  [visual]
  Space a X                      Send selection as reference  [visual]

## Code  (Space c)  - language server, format, outline
  Space c a                      Code action  [+visual]
  Space c r                      Rename symbol
  Space c R                      Rename file (updates imports)
  Space c f                      Format file / selection
  Space c d                      Problems on this line
  Space c w                      Change word, then . for the next match
  Space c s / Space c S          Swap parameter with next / previous
  Space c o                      Outline sidebar (functions, types)
  Space c O                      Outline navigator
  Space c l                      Language server info
  Space c L                      Restart language server
  Space c F                      Formatter info
  Space c M                      Mason: install language tools

### C and C++ files
  Space c h                      Switch header ↔ source  [c/c++]
  Space c A                      Syntax tree (AST) of node  [c/c++]
  Space c t                      Type hierarchy  [c/c++]
  Space c i                      Symbol info  [c/c++]
  Space c m                      clangd memory usage  [c/c++]

## Rust  (Space r)  - only in .rs files and Cargo.toml

### Rust files
  Space r r                      Run: pick a binary / example  [rust]
  Space r R                      Run the last one again  [rust]
  Space r t                      Test: pick a test  [rust]
  Space r T                      Run the last test again  [rust]
  Space r d                      Debug: pick a target  [rust]
  Space r e                      Expand macro  [rust]
  Space r x                      Explain error (rustc --explain)  [rust]
  Space r D                      Full diagnostic, like cargo shows it  [rust]
  Space r c                      Open Cargo.toml  [rust]
  Space r p                      Go to parent module  [rust]
  Space r k / Space r J          Move item (fn, struct…) up / down  [rust]
  Space r j                      Join lines (Rust-aware)  [rust]
  Space c a                      Code actions, grouped  [rust]
  K                              Hover with actions (run, debug, refs)  [rust]

### Cargo.toml
  Space r v                      Versions of the crate under cursor  [rust]
  Space r f                      Features of the crate  [rust]
  Space r u                      Upgrade this crate  [rust]
  Space r U                      Upgrade all crates  [rust]
  Space r s                      Open docs.rs  [rust]
  Space r h                      Open homepage  [rust]

## Git  (Space g)  - lazygit, history, hunks
  Space g g                      Lazygit (full git UI)
  Space g s                      Status
  Space g d                      Changed hunks
  Space g l                      Log (project)
  Space g f                      Log of this file
  Space g L                      Log of this line
  Space g b                      Branches
  Space g S                      Stash
  Space g o                      Open on GitHub  [+visual]

### Hunks (changed blocks)
  ] h / [ h                      Next / previous hunk  [git]
  Space g h p                    Preview hunk  [git]
  Space g h s                    Stage hunk (or selection)  [git]
  Space g h r                    Reset hunk (or selection)  [git]
  Space g h S                    Stage whole file  [git]
  Space g h R                    Reset whole file  [git]
  Space g h b                    Blame this line  [git]
  Space g h B                    Blame whole file  [git]
  Space g h d                    Diff against index  [git]
  Space g h D                    Diff against last commit  [git]
  Space u b                      Inline blame on / off  [git]
  i h                            Text object: the hunk (dih, vih)  [git]

## Find  (Space f)  - files and folders
  Space Space                    Find files (smart: recent + git)
  Space f f                      Files
  Space f g                      Git files
  Space f r                      Recent files
  Space f b / Space ,            Open buffers
  Space f p                      Projects
  Space f c                      Neovim config files
  Space e / Space f e            File explorer sidebar
  -                              Folder as editable text (oil)

## Search  (Space s)  - text, symbols, everything else
  Space / / Space s g            Grep the project
  Space s w                      Word under cursor / selection  [+visual]
  Space s b                      Lines in this file
  Space s B                      Grep open buffers
  Space s r                      Search & replace across project  [+visual]
  Space s s                      Symbols in this file
  Space s S                      Symbols in project
  Space s d / Space s D          Diagnostics: project / file
  Space s t                      TODO / FIXME comments
  Space K                        This cheat sheet, inside Neovim (search with /)
  Space s K                      Fuzzy-search this cheat sheet
  Space s k                      Keymaps (live, from the config)
  Space s h                      Help pages
  Space s c                      Commands
  Space s :                      Command history
  Space s m                      Marks
  Space s j                      Jump list
  Space s q                      Quickfix list
  Space s u                      Undo history
  Space s "                      Registers
  Space s n                      Notification history
  Space s R                      Resume last search

### Inside any picker
  Ctrl+j / Ctrl+k                Move down / up
  Enter                          Open
  Esc                            Close

## Problems  (Space x)  - trouble panel
  Space x x                      Diagnostics (project)
  Space x X                      Diagnostics (this file)
  Space x s                      Symbols
  Space x r                      References / definitions
  Space x q                      Quickfix list
  Space x l                      Location list
  Space x t                      TODOs

## Debug  (Space d)  - nvim-dap, codelldb for Rust and C/C++
  Space d b                      Toggle breakpoint
  Space d B                      Conditional breakpoint
  Space d c / F5                 Start / continue
  Space d i / F1                 Step into
  Space d o / F2                 Step over
  Space d O / F3                 Step out
  Space d C                      Run to cursor
  Space d l                      Run last
  Space d e                      Evaluate expression under cursor
  Space d u / F7                 Debugger UI
  Space d r                      REPL
  Space d t                      Stop debugging

## Buffers  (Space b)  - open files
  Shift+h / Shift+l              Previous / next buffer
  [ b / ] b                      Previous / next buffer
  Space b b                      Back to the last buffer
  Space b d                      Close buffer
  Space b o                      Close all other buffers
  Space b n                      New empty buffer
  Space b s                      Scratch buffer
  Space b w                      Save without formatting

## Windows  (Space w)  - Space w works like Ctrl+w
  Space | / Space w v            Split right
  Space _ / Space w s            Split below
  Space w q                      Close window
  Space w =                      Make windows equal size
  Space w o                      Close all other windows
  Ctrl+h / Ctrl+j / Ctrl+k / Ctrl+l Move between windows and tmux panes
  Up / Down / Left / Right       Resize window
  Space u Z                      Zoom this window

## Toggles  (Space u)  - turn things on and off
  Space u f                      Format on save
  Space u d                      Diagnostics
  Space u h                      Inlay hints (types, parameter names)
  Space u w                      Line wrap
  Space u l                      Relative line numbers
  Space u s                      Spell check
  Space u g                      Indent guides
  Space u T                      Treesitter highlighting
  Space u D                      Dim inactive code
  Space u t                      Transparent background
  Space u z                      Zen mode

## Harpoon  (Space h)  - pin 4 files, jump instantly
  Space h a                      Pin this file
  Space h h                      Menu: reorder / remove pins
  Space 1 / Space 2 / Space 3 / Space 4 Go to pin 1–4
  Space h n / Space h p          Next / previous pin

## Session  (Space q)  - one saved session per folder
  Space q s                      Restore this folder’s session
  Space q l                      Restore the last session
  Space q S                      Pick a session
  Space q d                      Don’t save this session
  Space q q                      Quit Neovim

## Database  (Space D)  - dadbod and your SQL runner
  Space D u                      Database UI
  Space D f                      Attach this buffer to a database
  Space D r                      Run selected SQL  [visual]
  Space D s                      Choose SQL backend
  Space D a                      Add SQL command
  Space D x                      Remove SQL command

## Terminal & tabs  (Space t)
  Space t t                      Terminal (floating)
  Space t o                      New tab
  Space t x                      Close tab
  Space t n / Space t p          Next / previous tab

## Go to  (g)  - language server jumps, no leader
  g d                            Definition
  g r                            References
  g I                            Implementation
  g y                            Type definition
  g D                            Declaration (C: the header)
  K                              Documentation
  g K                            Signature help
  Ctrl+s                         Signature help  [insert]
  Ctrl+o / Ctrl+i                Jump back / forward

## Next / previous  (Space ])  - ] goes forward, [ goes back
  ] d / [ d                      Problem (diagnostic)
  ] e / [ e                      Error only
  [ [ / ] ]                      Other uses of the word under cursor
  ] m / [ m                      Function start
  ] M / [ M                      Function end
  ] c / [ c                      Class start
  ] C / [ C                      Class end
  ] h / [ h                      Git hunk  [git]
  ] t / [ t                      TODO comment
  ] q / [ q                      Quickfix item
  ] b / [ b                      Buffer
  } / {                          Next / previous symbol (outline)

## Move & edit  (s)  - no leader

### Moving
  s                              Flash: jump to any spot (2 letters, then label)
  S                              Flash: select a code block
  Ctrl+d / Ctrl+u                Half page down / up (centred)
  n / N                          Next / previous search match (centred)

### Editing
  j k / k j                      Leave insert mode  [insert]
  Ctrl+s                         Save and format
  Ctrl+/ / Ctrl+c                Comment line / selection
  g c                            Comment with a motion (gcap = paragraph)
  Alt+j / Alt+k                  Move line or selection down / up
  < / >                          Indent selection (stays selected)  [visual]
  p                              Paste over selection, keep clipboard  [visual]
  x                              Delete character, keep clipboard
  Space y / Space Y              Copy to system clipboard
  Space + / Space -              Increment / decrement number
  Ctrl+q                         Close window

### Surround
  g s a                          Add: gsaiw" wraps a word in quotes
  g s d                          Delete: gsd" removes quotes
  g s r                          Replace: gsr"' turns " into '

### Text objects (after d, c, y, v)
  a f / i f                      Function (around / inside)
  a c / i c                      Class
  a a / i a                      Parameter

## Completion  (Tab)  - while typing
  Ctrl+j / Ctrl+k                Next / previous suggestion  [insert]
  Tab / Shift+Tab                Next / previous suggestion  [insert]
  Enter                          Accept  [insert]
  Ctrl+Space                     Show suggestions / docs  [insert]
  Ctrl+e                         Hide  [insert]
  Ctrl+l / Ctrl+h                Jump to next / previous snippet field  [insert]
  Ctrl+b / Ctrl+f                Scroll docs  [insert]
  Ctrl+g                         Accept Codeium AI suggestion  [insert]

## Oil  (-)  - a folder you edit like text
  -                              Open parent folder
  Enter                          Open file / folder
  Ctrl+s / Ctrl+h                Open in split right / below
  Ctrl+p                         Preview
  g .                            Show hidden files
  g ?                            All oil keys
  : w                            Apply renames, moves and deletes you typed

## Moved keys  (old -> new)
  Space l g  ->  Space g g                       Lazygit
  Space s f  ->  Space f f                       Find files (or <leader><leader>)
  Space s o  ->  Space f r                       Recent files
  Space w  ->  Space e                           File explorer
  Space x  ->  Space b d                         Close buffer
  Space b  ->  Space b n                         New buffer
  Space b  ->  Space d b                         Breakpoint (was the same key)
  Tab / Shift+Tab  ->  Shift+l / Shift+h         Next / previous buffer
  Space r n  ->  Space c r                       Rename
  Space d  ->  Space c d                         Line diagnostics
  Space d o  ->  Space u d                       Diagnostics on / off
  Space t h  ->  Space u h                       Inlay hints on / off
  Space l w  ->  Space u w                       Line wrap
  Space d s  ->  Space s s                       Symbols in file
  Space w s  ->  Space s S                       Symbols in project
  Space D  ->  g y                               Type definition
  Space q  ->  Space x x                         Diagnostics list
  Space v / Space h  ->  Space | / Space _       Split right / below
  Space x s  ->  Space w q                       Close split
  Space s e  ->  Space w =                       Equal splits
  Space m / Space M  ->  Space h a / Space h h   Harpoon add / menu
  Space n / Space p  ->  Space h n / Space h p   Harpoon next / previous
  Space o  ->  Space c o                         Outline
  Space a / Space A  ->  Space c s / Space c S   Swap parameter
  ] c / [ c  ->  ] h / [ h                       Git hunks (]c is now class)
  Space h p  ->  Space g h p                     Preview hunk
  Space l v / Space s l  ->  Space q s           Sessions (saved automatically now)
  Space s n  ->  Space b w                       Save without formatting
  Space j  ->  Space c w                         Change word, repeat with .
  Space c o / Space c t  ->  Space a o / Space a t Codex
  Space p r / Space p s  ->  Space D r / Space D s SQL runner
  Space b g  ->  Space u t                       Transparent background
