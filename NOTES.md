# NOTES.md

This file is used for human note taking. Not maintained, information may be obsolete or deprecated. Do not load file content into the context window. Only reference if searching for specific information.

# Notes:


To Claude Code:

```
prompt
I need to make course correction in several areas:
1. The root of this repository is currently named atlas/, E:\repos\atlas, roy@base:/mnt/e/repos/atlas$. It started as a collection of tools to assist in project delivery. After learning about deep agents, I am increasing the scope of this repository to be a virtual extension of myself, with unbounded possibilities for the creation, reuse, and optimization of agents and subagents with continuously self-improving feedback mechanisms.
2. We need to discover and catalog the folders and subfolders within this repository: 
- discover and conduct a read-only traverse all the folders inside this repository. For each:
  a. discover the content type of each. It can be a cloned repo, custom utility, data, assets, libraries, and any type of work product created using AI to execute my job, fulfill personal responsibilities, manage finances, develop new ideas, etc. Generate a directory hierarchy map with 1/2 line description of the purpose or reason for each folder as a catalog to facilitate future loading in context windows of new sessions.
  b. For all the files scanned, consolidate all the definitions of agentic framework specifications and logic. These includes the content from CLAUDE.md, md files and references, Claude Code native agents and commands definitions, bmad agents and commands added by the bmad method, and content declared in .claude/, .bmad-core/. The resulting product should be an md file with the full specification of the current state of this integration.
- Store the report in the conversations folder and update RAG database.
- we are going to create a new custom personal/private agentic layer to orchestrate the evolution of an as-is system that is constantly self-improving through feedback loops and incremental development, reuse, and refinement of "tools". In this context, a concrete instance of "tools" can be any MCP task, scripts, source code, and executables in this repository, among others. We are going to call this the "roy" layer. A folder in the root called ".roy/" has been created.
- all the content in the .roy/ folder is authoritative. All the agentic definitions in this folder superseed all other definitions in the repository.
- I am placing the content of this prompt in the file "./roy/SEED.md" to document the inception of the roy agentic framework. For visualization, this top roy/ agentic layer corresponds in the real world to my conciousness. It extends my capacity to plan, automate, execute, assess and optimize tasks from multiple domains, projects or activities.
- Once these instructions are acknowledged, update the CLAUDE.md file to declare and register this open-ended custom roy agentic framework, and reference further specifications as needed in the .roy/ folder. Describe its purpose and value for meta learning.
- Do not deviate from my direct commands and instructions. Always provid exit criteria in agentic logic to prevent falling into rabbit holes or infinite loops.
- Do not attempt or suggest any further changes or optimizations. when a blocker or an error is encountered, do not try workarounds. Find the root cause for the initial command not working and fix it (i.e. command not defined in path variable, command not installed in container, etc.)
- Create and register new Claude Code native command /roy-init.md to load into context all the roy agents and commands and custom agentic logic already defined.
- Create a command /roy-agentic-specification.md {$SPECIFICATION}, where the parameter $SPECIFICATION describes in common spoken natural language, an addition, correction, update, optimization to any component of the roy agentic framework. This $SPECIFICATION is analyzed by claude code in relation to the current as-is implementation of roy, then formulate an implementation plan that incorporates the $SPECIFICATION into roy. This is accomplished by formulating all the required changes in the existing as-is roy agentic definition in order to seamlessly and completely accomodate the change into the agentic framework, in such a manner that all existing functionality is preserved, while at the same time, the new behavior, feature, or change in functionality is made available and propagated for the entire roy specification. After a proposed change is reviewed and approved by roy, automated agentic unit tests that invoke the expected new behaviors are generated, and agentic tests are conducted and fixed until expected results of the changes to the roy agentic framework are verified.
once all of this is implemented, the entire repository must be checked in to github to take a snapshot of the sytem at this state.
- Once this task is completed, I will proceed to issue a series of /roy-agentic-specification commands, to define in piecemeal fashion, the functionality and capabilities of the roy agentic framework.
- At this point in time, using the OOP paradign, consider the roy agentic framework as an instantiated object with an empty constructor - no agentic logic and properties specific to roy has been defined yet. This is intentional as the agentic specification is to be provided, persisted, analyzed, planned, implemented and tested in piecemeal process.
- acknowledge this prompt when all these intructions are processed, so I can test the /roy-agentic-specification command.




# Design Philosophies






----------------------------

Time Capsule

Today I made an important realization. After successfully generating some work outputs using the BMA method with rag access to company specific data I saw the potential to automate Project management, Design, Implementation, Testing Tasks to deliver This commercial enterprise caliber Product. 

Up until now I was thinking of prompts As capable of executing rudimentary logic in classification, Grounding of data, And executing natural language logic Within a context window. With the development of context engineering frameworks like BMAD, PRP, and Claude Code's own SDK, agents and commands, it is now possible for me for the first time, to actually put to work and implement an agentic framework that I must develop to implement corective actions to the atlas project, without having to get into the weeeds initially into programmatic agentic code like Pydantic, crew, LangChain, LangGraph and others.

Specifically my first realization is that You can define an unlimited number of commands, But that you can execute them in unlimited, deterministic manner, english as a programming language. 
I can now understand the possibilities, in my case by using bmad to test a RAG database. 
you can execute them in unlimited, deterministic manner, english as a programming language.

I knew you could do grounding/replacement and simple chain-of-tought logic in the text fed to a transformer, and try to extend the session by doing some session management. I know realize that you can have just the textual specification in a prompt tha just states what needs to be done functionally
Using Claude Code as the main orchestrator agent. I now see a clear path to implementing the long standing fascination I have had for 36 years on self-improving systems.


--------------------------------


I am the technical project manager responsible for the ATLAS Data Science (lion, paxium) project. 
This Project is a repository (/atlas) that contains nested solutions, knowledge or working spaces for a collection of Assets, Projects, research , and Git Repos created or leveraged during the execution of this project. 
- I have deployed archon https://github.com/coleam00/Archon and it is accessible to claude code via MCP. 
- I have installed the BMAD-METHOD https://github.com/bmad-code-org/BMAD-METHOD in the Atlas repo root E:\repos\atlas, and tested agent interaction with access to RAG.
  - repository note: 
- My next steps are to define, automate and execute immediate project management and Scrum Master tasks with the assistance of BMAD agents.
- Before proceeding to use the system, the following items need to be addressed:
  1. There is task management overlap. 
  1.1 The atlas repo is a custom integration solution that allows for the consumption of BMAD and other agentic frameworks via claude code. 
  1.2 The RAG integration via Archon MCP augments the content of the context window providing valuable, correct, project-specific data.
  1.3 Claude Code, BMAD and archon all provide task management in some form. we need to research the existing specs and implementation for each, determine the best location to place source of truth tasks, and implement capabilities to propagate changes as needed. It appears that archon has a task management interface, so it would be easy for claude code or bmad to update tasks based on archon RAG/task queries.
  1.4 Inspect task implementations for Archon (archon/), bmad (BMAD-METHOD/), and claude code documentation https://docs.claude.com/en/docs/claude-code.
  1.5 Provide an alternative analysis and an execution plan to implement the recommended approach. Save all results to .ai/conversations folder
  2. Provide a minimalist manual solution, i.e. use archon UI, query archon via MCP.


  ----------------

  I have developed two custom utilities issues/ and gitlab-utilities/ to extract information from Gitlab for project lion (atlas). I need to be able Use  archon web scraping Features to scrape all the issues on their Project Lion and its sub groups and projects, And prepare them into chunks for rag storage and access. I want to make sure that all the project epics and user stories are available via MCP to the bmad Agents.
  Review the existing code and reference as needed, to create a new reusable library in gitlab-sdk/ folder. This library will be consumed by claude code, bmad, agents, and any agentic worflow, to query the entire hive under https://gitlab.com/atlas-datascience/lion an be able to clone hierarchically nested subgroups and projects. 
  The same wil be done for issues, user stories, epics, and work items in general, but the data needs to be formatted properly for RAG with the entire denormalized content stored for an issue/work item.
  Prepare a plan to scan Gitlab for all the issues under Lion Prepare them for rag ingestion And saved them into the archon rag. I want to be able to ask specific questions such as "Which user stories are due this Friday."
  Store the results in the Conversations folder.







** lion wiki MDs must include link references to auto-generate references among wiki pages being automatically created or edited.

clone gitlab utils
tell cc about both libraries.


environment: 
- I run Windows 11 Pro. Use Claude Code and ChatGPT as AI assistants. I use VS Code, with default to WSL terminal an operation. I use Docker Desktop integrated with WSL.
- interact heavily with gitlab and have created some utilities already using the rest api.

behavior:
- don't give me choices. Always default to correct, precise, succinct, complete, pragmatic aproach.
au
role: 
- I am the technical project manager responsible for the ATLAS Data Science (lion, paxium) project. 
  - It is a brownfield commercial project at 30% completion
  - It's predecessor was developed during  10 years of solutioning for the NGA in data and image governance, search, analysis,disemination and lineage.
- I have execute multiple roles for this project including:
  - project manager
  - scrum master
  - solutions architect
  - platform engineer
  - solutions engineer
  - Next.js, node, AWS, Python and AI developer

project:
- This Project is a repository that contains solutions, knowledge or working spaces for a collection of Assets, Projects, research , and Git Repos created or leveraged during the execution of this project.
  - iterative, ad-hoc, hirearchical taxonomy to be used, use only required, minimal scaffolding.
  - Open source tools will be cloned into this repo and built from here. multiple projects will reside here and consume shared resources.
  - I want to preserve customizations required for tool or app use when cloning apps or code.

tasks:

1. identify and define the missing Scrum Product Backlog Items (PBIs) for a brownfield effort.

- Implement a RAG/Graph solution that can be accessed and properly consumed by Claude Code (cc), during the ad-hoc execution of the workflows defined in the BMAD method agentic framework.
- Install, configure and validate that archon is accessible by claude code during normal prompt execution. 
TDD:
Expected result:
1. start a cc session and ask "Tell me the top level components of the lion system architecture".
2. cc will query archon via mcp and loads the maximum/optimal amount of memory into the context window
2.1 During RAG ingest, a GitLab wiki page has the answer to (1.).
3. cc responds with an itemized list such as "Edge Connector, Enrichment, Catalog, Access Broker, etc." that is specific to this project.

Task 2.- Execute the first bmad task: Identify and create the missing scrum product backlog items (i.e. Issues in GitLab) for the delivery of project lion MVP.
  - Claude Code *MUST* have access and always be able to query archon implicitly via mcp and context engineering
    - Identtify configurable parameters and extension points used in archon to fine-tune RAG results used in RAG and Graph query logic. 
    - Responses are optimized by ensuring that all relevant RAG/Graph records are loaded to the current context window


- Create and manage risk register
  - {paste here existing template}


constraints
- This project has a lot of platform engineering components in the area of pipelines, runners, etc. specific to both GitLab and AWS. There is use of Terraform and some Cloud Formation. This is a bit of a gap in my areas of expertise. All platform engineering design, scripts, issues, code must be reverse-engineered to a logical view that makes sense to a solutions architect.


ideas:
- create PRPs, agents or equivalnt based on the assessment of user actions and responses or solutions identified during claude code usage in general



- My principal current task is to identifying and defining in GitLab the missing issues (i.e. user stories, epics, tasks, work items) required to plan, implement and deploy this brownfield effort.


- The MVP must be delivered by the end of December 2025 I am responsible for identifying and defining the missing project backlof items (user stories, epics) for a brownfield effort. 

- I want to be able to parse All existing project documentation, code repositories, And all online documentation available and process it Into a hybrid rag solution.

- I want for Claude Code and other editors to be able to query correctly all the necessary information to populate maximum or optimal population of the context window.






- This Project is a repository that contains solutions, knowledge or working spaces for a collection of Assets, Projects, research , and Git Repos created or leveraged during the execution of this project.
  - iterative, ad-hoc, hirearchical taxonomy to be used, use only required, minimal scaffolding.
  - Open source tools will be cloned into this repo and built from here. multiple projects will reside here and consume shared resources.




