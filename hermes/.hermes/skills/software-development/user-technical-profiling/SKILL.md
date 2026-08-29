---
name: user-technical-profiling
description: Profile user technical identity from config files.
---

# User Technical Profiling

This skill provides a methodology for autonomously discovering a user's technical identity, expertise, and workflow preferences by auditing their local environment configuration.

## Workflow

1. **Discovery Phase**
   - Scan the home directory for "high-signal" configuration files.
   - Targets:
     - Shell: `.bashrc`, `.zshrc`, `.bash_profile`, `.zprofile`, `.profile`.
     - Editors: `.vimrc`, `.vim/`, `.config/nvim/init.lua`, `.config/nvim/init.vim`.
     - Window Managers/Desktop: `.config/i3/`, `.config/sway`, `.xinitrc`, `.config/kwinrc`.
     - Version Control: `.gitconfig`.
     - Terminal/Multiplexers: `.screenrc`, `.tmux.conf`.
     - Package Managers: `.npmrc`, `.pip/pip.conf`, `.ruby-gems`.
   - **Hardware & FS Probes**: Run `lsblk -f`, `lspci`, and `df -h` to identify OS distribution, disk layout (e.g., Btrfs, LVM), and hardware capabilities (GPU, Network).
   - **Intellectual Audit**: Scan `~/books`, `~/Documents`, or `~/library` (try both singular and plural) for technical PDFs, man pages, or textbooks to infer the user's learning trajectory.

2. **Analysis Phase**
   - **Toolchain Detection**: Identify languages (C++, Python, Rust, etc.), build systems (CMake, Ninja, Make), and frameworks (Qt, React, etc.) from aliases, PATH exports, and plugin lists.
   - **Workflow Extraction**: Analyze keybindings and aliases to determine the user's "interaction philosophy" (e.g., keyboard-driven, Vi-centric, automation-heavy).
   - **System Rigor**: Look for strict compiler flags (`-Werror`, `-Wall`), optimization levels, or specialized system tuning.
   - **Infrastructure**: Identify proxy setups, VPNs, or specialized OS kernels/distros.
   - **Trajectory Analysis**: Map the technical literature found to determine if the user is moving from high-level to low-level (or vice versa) and identify their current focus area.

3. **Synthesis Phase**
   - Group findings into a "Technical Portrait" with the following sections:
     - **Core Tech Stack**: The primary languages and tools.
     - **Workflow & Philosophy**: How the user interacts with the machine (e.g., "Tiling WM Power User").
     - **Infrastructure & Environment**: OS, hardware, and network specifics.
     - **Learning Trajectory**: Current study focus and evolution of expertise.
     - **Personal Traits**: Inferred habits (e.g., "Extreme efficiency seeker", "Low-level enthusiast").

4. **Verification & Persistence**
   - Present the portrait to the user for correction.
   - Once verified, update the `user` memory store to prevent future redundant discovery.

## Pitfalls
- **Avoid Assumptions**: Do not assume the user's skill level based on a single file; look for patterns across multiple configs.
- **Privacy Respect**: Only read configuration files. Do not search for private data, keys, or personal documents unless explicitly asked.
- **False Positives**: Distinguish between "default config" and "user-modified config". Default files provide little signal.

## Verification
- The deliverable is a structured "Technical Portrait" that the user recognizes as accurate.
- The final step must be a `memory` call to persist the high-level persona.
