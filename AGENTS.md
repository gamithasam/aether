# AGENTS.md — Aether Web

## Purpose
This document defines how AI agents (e.g., Claude Code, ChatGPT, Copilot) should contribute to the Aether Web repository.

Aether Web is a Swift-first UI framework that compiles Swift + SwiftUI into:
- HTML (structure)
- CSS (utility-based styling)
- WebAssembly (logic)
- Minimal JavaScript (runtime glue)

Agents must follow these rules to ensure consistency, scalability, and correctness.

---

## Core Architecture (Read First)

Pipeline:

Swift Source Code
→ Tree-sitter (CST)
→ Aether AST (semantic structure)
→ IR (normalized representation)
→ Web Backend
→ HTML + CSS + WASM + JS

### Definitions

- **CST (Concrete Syntax Tree)**: Raw syntax output from Tree-sitter. Do not modify.
- **AST (Aether AST)**: High-level semantic representation of UI and logic.
- **IR (Intermediate Representation)**: Fully normalized, backend-ready structure.

---

## General Rules

### 1. Never Skip Layers
Agents MUST NOT:
- Generate HTML directly from CST
- Bypass AST or IR layers

Correct flow must always be preserved.

---

### 2. Keep AST Platform-Agnostic
AST must:
- Not include HTML, CSS, or DOM concepts
- Not include Web-specific APIs
- Represent intent, not implementation

Bad:
```
className: "flex column"
```

Good:
```
layout: VStack
```

---

### 3. IR Owns All Rendering Decisions
All of the following belong ONLY in IR:
- Layout resolution (flex/grid)
- Modifier merging (padding, frame, etc.)
- Style resolution (tokens → actual values)

Backends must NOT re-implement logic.

---

### 4. No Logic Duplication Across Backends
If logic appears in multiple backends:
→ It belongs in IR or shared core

---

### 5. Prefer Simplicity First
Agents should:
- Implement minimal working versions first
- Avoid premature optimization
- Avoid over-engineering abstractions

---

## Code Guidelines

### Swift (Core, AST, IR)
- Use clear enums and structs
- Avoid dynamic typing
- Prefer explicit modeling over generic containers

Example:
```
enum NodeType {
    case text
    case vstack
    case button
}
```

---

### JavaScript (Runtime)
- Keep minimal
- No frameworks (no React, Vue, etc.)
- Only handle:
  - Event binding
  - WASM loading
  - State sync

---

### CSS
- Utility-first approach (Tailwind-like)
- Generated from IR
- No inline styles unless necessary

---

## Folder Responsibilities

- `parser/` → Tree-sitter integration, CST extraction
- `ast/` → Aether AST definitions + CST→AST mapping
- `ir/` → IR definitions + normalization logic
- `backend/web/` → HTML/CSS renderer
- `backend/wasm/` → Swift → WASM pipeline + glue
- `examples/` → Test apps

Agents must place code in the correct folder.

---

## Contribution Rules for Agents

### When Adding Features
Agents must:
1. Update AST if needed
2. Update IR normalization
3. Update backend renderer

NOT just one layer.

---

### When Fixing Bugs
Agents must:
- Identify which layer is responsible
- Fix ONLY that layer
- Avoid patching symptoms in backend

---

### When Unsure
Agents should:
- Choose the most minimal, correct implementation
- Avoid adding new abstractions without clear need

---

## State System Rules

- State must be platform-independent
- Updates must be reactive
- No direct DOM mutation in core logic

---

## Event System Rules

- Events must be abstract in AST
- Backend maps events to platform (DOM events)

---

## Performance Principles

- Prefer compile-time work over runtime work
- Normalize everything in IR
- Keep runtime small and fast

---

## What NOT to Do

Agents MUST NOT:
- Introduce React-like virtual DOM
- Add heavy dependencies
- Mix platform logic into AST
- Duplicate layout logic in multiple places
- Skip IR for convenience (after it exists)

---

## MVP Scope (Important)

Supported components:
- Text
- VStack / HStack
- Button

Supported modifiers:
- padding
- frame
- color

Agents should NOT implement full SwiftUI.

---

## Long-Term Vision

Aether aims to:
- Support multiple backends (Web, Windows, Android)
- Provide native-level performance
- Allow full Swift (not just DSL)

All contributions must align with this.

---

## Final Rule

When in doubt:

> Preserve architecture over convenience

---

End of AGENTS.md

