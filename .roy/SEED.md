Please execute the following course correction tasks:

## 1. Repository Context & Vision
The root of this repository is currently named `atlas/` at `E:\repos\atlas` (WSL path: `/mnt/e/repos/atlas`). It began as a collection of tools to assist in project delivery. After learning about deep agents, I am expanding the scope of this repository to become a virtual extension of myself, with unbounded possibilities for the creation, reuse, and optimization of agents and subagents with continuously self-improving feedback mechanisms.

## 2. Repository Discovery & Cataloging
Discover and catalog all folders and subfolders within this repository:

- **Conduct a read-only traversal** of all folders inside this repository. For each folder:
  
  a. **Identify content type**: Determine if it contains a cloned repo, custom utility, data, assets, libraries, or any work product created using AI to execute my job, fulfill personal responsibilities, manage finances, develop new ideas, etc. Generate a **directory hierarchy map** with a 1-2 line description of the purpose or reason for each folder. This catalog will facilitate future loading in context windows of new sessions.
  
  b. **Consolidate agentic framework specifications**: For all files scanned, consolidate all definitions of agentic framework specifications and logic, including:
     - Content from `CLAUDE.md`, other `.md` files and references
     - Claude Code native agents and command definitions
     - bmad agents and commands added by the bmad method
     - Content declared in `.claude/` and `.bmad-core/` directories
     
     The resulting product should be an `.md` file containing the full specification of the current state of this integration.

- **Store outputs**: Save the directory hierarchy report in the `conversations/` folder and update the RAG database.

## 3. The "roy" Agentic Layer
We are creating a new custom personal/private agentic layer to orchestrate the evolution of an as-is system that is constantly self-improving through feedback loops and incremental development, reuse, and refinement of "tools". 

- **Definition of "tools"**: In this context, a concrete instance of "tools" can be any MCP task, scripts, source code, executables in this repository, or other computational assets.

- **Naming**: This layer is called the **"roy" layer**.

- **Location**: A folder in the root called `.roy/` has been created.

- **Authority**: All content in the `.roy/` folder is **authoritative**. All agentic definitions in this folder supersede all other definitions in the repository.

- **Conceptual model**: The top-level `roy/` agentic layer corresponds to my consciousness in the real world. It extends my capacity to plan, automate, execute, assess, and optimize tasks from multiple domains, projects, or activities.

- **Seed documentation**: The content of this prompt is being placed in the file `.roy/SEED.md` to document the inception of the roy agentic framework.

## 4. CLAUDE.md Registration
Once these instructions are acknowledged, update the `CLAUDE.md` file to:
- Declare and register this open-ended custom roy agentic framework
- Reference further specifications as needed in the `.roy/` folder
- Describe its purpose and value for meta-learning

## 5. Execution Constraints
- **Do not deviate** from my direct commands and instructions
- **Always provide exit criteria** in agentic logic to prevent falling into rabbit holes or infinite loops
- **Do not attempt or suggest** any further changes or optimizations beyond what is explicitly requested
- **When encountering blockers or errors**: Do not try workarounds. Find the root cause for the initial command not working and fix it (e.g., command not defined in PATH variable, command not installed in container, missing dependencies, etc.)

## 6. New Claude Code Commands

### Command: `/roy-init`
Create and register a new Claude Code native command `/roy-init.md` that loads into context all the roy agents, commands, and custom agentic logic already defined.

### Command: `/roy-agentic-specification`
Create a command `/roy-agentic-specification.md {$SPECIFICATION}`, where:

- **Parameter `$SPECIFICATION`**: Describes in common spoken natural language an addition, correction, update, or optimization to any component of the roy agentic framework.

- **Processing workflow**:
  1. Analyze `$SPECIFICATION` in relation to the current as-is implementation of roy
  2. Formulate an implementation plan that incorporates the `$SPECIFICATION` into roy
  3. Identify all required changes to the existing as-is roy agentic definition
  4. Ensure changes seamlessly and completely accommodate the specification such that:
     - All existing functionality is preserved
     - New behavior, feature, or change in functionality is made available and propagated throughout the entire roy specification
  5. After a proposed change is reviewed and approved by roy:
     - Generate automated agentic unit tests that invoke the expected new behaviors
     - Conduct agentic tests and fix issues until expected results of the changes to the roy agentic framework are verified

## 7. Version Control
Once all of this is implemented, the entire repository must be checked in to GitHub to take a snapshot of the system at this state.

## 8. Next Steps
Once this task is completed, I will proceed to issue a series of `/roy-agentic-specification` commands to define, in piecemeal fashion, the functionality and capabilities of the roy agentic framework.

## 9. Current State Declaration
At this point in time, using the OOP paradigm, consider the roy agentic framework as an instantiated object with an **empty constructor** — no agentic logic and properties specific to roy have been defined yet. This is intentional, as the agentic specification is to be provided, persisted, analyzed, planned, implemented, and tested in a piecemeal process.

## 10. Acknowledgment Request
Acknowledge this prompt when all these instructions are processed, so I can test the `/roy-agentic-specification` command.