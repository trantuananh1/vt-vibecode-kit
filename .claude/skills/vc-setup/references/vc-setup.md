# VibeCo Agent Harness Setup - Reference

Detailed instructions for each phase of the vc-setup skill.

## DETECT Phase

### Package Manager Detection

Read `package.json` and check these signals in order:

1. `packageManager` field (e.g., `"pnpm@9.0.0"`, `"yarn@4.0.0"`, `"npm@10.0.0"`)
2. Lockfile presence:
   - `pnpm-lock.yaml` -> pnpm
   - `yarn.lock` -> yarn
   - `package-lock.json` -> npm
   - `bun.lockb` or `bun.lock` -> bun
3. Default to `npm` if no signal found

### Framework Detection

Read `dependencies` and `devDependencies` in `package.json`:

- `next` -> Next.js (check version for App Router vs Pages Router)
- `nuxt` -> Nuxt
- `@angular/core` -> Angular
- `svelte` or `@sveltejs/kit` -> Svelte/SvelteKit
- `vue` -> Vue
- `remix` or `@remix-run/react` -> Remix
- `astro` -> Astro
- `express` or `fastify` or `hono` or `koa` -> Node.js server
- None of the above -> generic Node.js/TypeScript project

### Test Setup Detection

Read `scripts` in `package.json`:

- Look for `test`, `test:unit`, `test:e2e`, `test:integration` scripts
- Detect test runner from devDependencies: `vitest`, `jest`, `mocha`, `@playwright/test`, `cypress`
- Record test commands for use in seed files

### Monorepo Detection

Check these signals:

- `workspaces` field in `package.json` (npm/yarn workspaces)
- `pnpm-workspace.yaml` file exists
- `apps/` directory exists
- `packages/` directory exists
- `lerna.json` exists
- `turbo.json` or `nx.json` exists

### Existing Process Scan

Check for:

- `process/` directory (existing harness)
- `docs/` directory (existing documentation)
- `.github/` directory (CI/CD)
- `README.md` content (project description)

### Detection Summary Format

Present to user:

```
Project Detection Summary:
- Package manager: {detected_pm}
- Framework: {framework} {version} ({details like "App Router", "Pages Router"})
- Runtime: {node/bun/deno} {version from engines or .node-version}
- Monorepo: {yes/no} ({workspace count} workspaces)
- Database: {ORM} + {DB type} (or "none detected")
- Auth: {provider} (or "none detected")
- Test runner: {runners with per-package breakdown}
- Test commands: {commands}
- Existing process/: {none/partial/full} ({details})
- Project name: {from package.json name field}
- Detected context groups: {list of groups to create}
- Detected feature areas: {list of features to create}

Proceed with scaffolding? (y/n)
```

## SCAFFOLD Phase

### Managed vs User Files

CLAUDE.md, AGENTS.md, and agent prompts are **managed protocol files**. They are copied as-is from the harness source and should NOT be adapted per-project. They contain zero project-specific content.

Project-specific information lives in `process/context/all-context.md`, populated during the STUDY phase.

### Seed Location

All seed templates live in `process/_seeds/` (read-only during setup -- never modified by the scaffold process). The SCAFFOLD phase reads from `_seeds/` and copies to the real working directories.

Context group seed folders use `-seed` suffix (e.g., `tests-seed/`, `planning-seed/`). When copying to real locations, drop the `-seed` suffix.

### Seed Directory Tree

```
process/_seeds/
  _GUIDE.md                              -- explains the process/ directory
  context/
    all-context.md.seed                  -- root context router template
    _all-group-template.md.seed          -- template for new context group entrypoints
    tests-seed/
      all-tests.md.seed                  -- testing context template
    planning-seed/
      all-planning.md.seed               -- planning context template
  features/
    _GUIDE.md                            -- feature folders guide (verbatim)
    _feature-template/
      _GUIDE.md.seed                     -- template for new feature folder guides
      active/
        _GUIDE.md                        -- active plans guide
      completed/
        _GUIDE.md                        -- completed plans guide
      backlog/
        _GUIDE.md                        -- backlog guide
      reports/
        _GUIDE.md                        -- reports guide
      references/
        _GUIDE.md                        -- references guide
  general-plans/
    active/
      _GUIDE.md                          -- active plans guide
    completed/
      _GUIDE.md                          -- completed plans guide
    backlog/
      _GUIDE.md                          -- backlog guide
    reports/
      _GUIDE.md                          -- reports guide
    references/
      _GUIDE.md                          -- references guide
```

### Target Directory Tree (after SCAFFOLD)

```
process/
  _seeds/                                -- read-only seed templates (copied from above)
  development-protocols/
    all-development-protocols.md
    orchestration.md
    implementation-standards.md
    plan-lifecycle.md
    phase-programs.md
    context-maintenance.md
  context/
    all-context.md
    all-context.md.seed              -- structural reference companion
    _all-group-template.md.seed      -- template for new context group entrypoints
    planning/
      all-planning.md
      all-planning.md.seed           -- structural reference companion
      example-simple-prd.md
      example-complex-prd.md
    tests/
      all-tests.md
      all-tests.md.seed              -- structural reference companion
  general-plans/
    active/
      _GUIDE.md
    completed/
      _GUIDE.md
    backlog/
      _GUIDE.md
    reports/
      _GUIDE.md
    references/
      _GUIDE.md
  features/
    _GUIDE.md
    _feature-template/
      _GUIDE.md.seed                 -- template for new feature folder guides
      active/
        _GUIDE.md
      completed/
        _GUIDE.md
      backlog/
        _GUIDE.md
      reports/
        _GUIDE.md
      references/
        _GUIDE.md
```

### Migration Mode Decision Logic

| Signal | Mode |
|--------|------|
| No `process/` directory exists | Fresh |
| `process/` exists but no `development-protocols/` | Merge |
| `process/` exists with `development-protocols/` | Refresh |
| `process/context/all-context.md` exists | Merge or Refresh (preserve it) |

### Fresh Mode

Create everything from `process/_seeds/` (read-only source, never modified during setup):

1. Create all directories in the target tree
2. Copy all files from `process/_seeds/` to their real locations
3. Process `.seed` files: copy with `.seed` removed, replace `{{project_name}}` with detected project name
4. Copy non-seed files verbatim (example PRDs, development protocols, `_GUIDE.md` files)
5. Context group seed folders: copy from `-seed` suffix dirs to real dirs (e.g., `tests-seed/` -> `tests/`, `planning-seed/` -> `planning/`)
6. Retain `.seed` originals: copy the original `.seed` files alongside the populated real files in the target `process/` directory. These serve as structural reference companions -- agents and future `vc-update` runs can diff populated files against their `.seed` originals to detect structural drift or missing sections

### Merge Mode

Preserve existing content, migrate old layouts, fill gaps (read from `process/_seeds/`, never modify seeds):

**Step 0 — Layout Migration (before creating anything new):**

Detect old directory layouts and reorganize them into the harness standard structure. Print every move to the user.

| Old Layout | Migration Action |
|------------|-----------------|
| `process/plans/` exists, no `process/general-plans/` | Create `process/general-plans/active/` and `process/general-plans/completed/`. For each file in `process/plans/`: scan for "COMPLETE", "DONE", or "✅" markers — move matches to `completed/`, move the rest to `active/`. Remove empty `process/plans/`. |
| `process/reports/` exists at top level | Move `process/reports/*` → `process/general-plans/reports/`. Remove empty `process/reports/`. |
| `process/skills/` exists at top level | Move `process/skills/*` → `process/general-plans/references/`. Remove empty `process/skills/`. |
| `process/context/example-*.md` outside `planning/` | Move to `process/context/planning/`. |
| `process/context/backlog.md` | Move to `process/general-plans/backlog/backlog.md`. |

**Migration rules:**
- Never overwrite existing files at the destination. If a same-name file exists, keep both (rename the migrated copy with a `-migrated` suffix).
- Print every move action so the user can verify.
- After all moves, remove empty source directories.
- If a plan file contains phase patterns (`phase-00-`, `phase-01-`, etc.) and a master plan file exists alongside them, keep them grouped in the same destination directory.

**Step 1–6 — Standard merge (after migration):**

1. Create only missing directories
2. Add `_GUIDE.md` to empty directories that lack them (source: `process/_seeds/`)
3. Copy seed files only where the target file does not exist
4. Copy development protocols only where the target file does not exist
5. Retain `.seed` originals alongside populated files (same as Fresh mode step 6)
6. Never overwrite existing files

### Refresh Mode

Update protocols, preserve user content (read from `process/_seeds/`, never modify seeds):

1. Overwrite development protocol files from `process/development-protocols/` (these are managed system files that live in the real directory, not in `_seeds/`)
2. Add missing seed files (do not overwrite existing ones)
3. Add missing `_GUIDE.md` files from `process/_seeds/`
4. Update `.seed` companion files to latest versions from `process/_seeds/` (these are structural references, not user content)
5. Preserve all user-created plans, reports, references, and context docs

### Placeholder Reference

The only placeholder used in seed templates is:

| Placeholder | Source |
|-------------|--------|
| `{{project_name}}` | `package.json` name field |

All other content is populated by the STUDY phase using real codebase analysis, not string replacement.

## STUDY Phase

The STUDY phase is the core value of vc-setup v3. It transforms scaffolded seed files into ready-to-use context by actively scanning the codebase.

### Parallel Subagent Delegation Strategy

The STUDY phase is the most resource-intensive part of vc-setup. The executing agent SHOULD spawn parallel subagents to maximize throughput and avoid context window exhaustion.

**Round 0 -- Migration Gap Analysis (only when existing process/ is found):**

Spawn a single subagent that reads all existing `process/` content and produces a gap analysis. Round 1 subagents receive this gap analysis to avoid duplicating existing content.

**Round 1 -- Parallel Research (read-only, no file writes):**

Spawn 4 parallel subagents. Each produces a structured findings report as its output.

| Subagent | Task | Output |
|----------|------|--------|
| A: Architecture and Stack Scanner | Source directory scan, tech stack detection with versions, import alias mapping, env var cataloging, key patterns and conventions | Structured findings: stack details, directory tree, aliases, entry points, patterns |
| B: Test and Quality Scanner | Test runners, config files, test directories, test commands per package/workspace | Structured findings: runners, configs, commands, known quirks |
| C: Context Group Detector | Scan for database, auth, CI/CD, container, UI, workflow signals using the detection table below | List of recommended context groups with evidence for each |
| D: Feature Area Detector | Route groups, package names, README features, doc structure | List of recommended feature folders with evidence for each |

Wait for all Round 1 subagents to complete. Present the combined detection summary to the user. User confirms or adjusts the detected groups and features before Round 2.

**Round 2 -- Parallel Writers (file writes, non-overlapping targets):**

Spawn up to 4 parallel subagents. Each writes to a distinct set of files with no overlap.

| Subagent | Consumes | Writes to |
|----------|----------|-----------|
| E: all-context.md Writer | Findings from A + C | `process/context/all-context.md` |
| F: all-tests.md Writer | Findings from B | `process/context/tests/all-tests.md` |
| G: Context Group Scaffolder | Findings from C | `process/context/{group}/all-{group}.md` for each group |
| H: Feature Folder Scaffolder | Findings from D | `process/features/{feature}/` dirs + `_GUIDE.md` files |

Wait for all Round 2 subagents to complete. Proceed to VALIDATE.

**For SMALL projects (fewer than 5 source directories, no monorepo):**

Skip parallel delegation. A single agent can handle the entire STUDY phase sequentially, following the same checklists below in order: codebase analysis, context groups, feature areas, then file population.

### Deep Codebase Analysis Checklist

The agent (or Subagent A) must scan and document:

**Source directory scan:**
- List all top-level source directories (src/, lib/, app/, pages/, etc.)
- For monorepos: list all workspace packages with their purpose
- Identify entry points (main files, route handlers, server starts)

**Tech stack specifics:**
- Framework + version (e.g., "Next.js 15 with App Router", not just "Next.js")
- Runtime (Node, Bun, Deno) + version from `package.json` engines or `.node-version`
- Database (ORM + DB type from dependencies + config files)
- UI library + CSS approach from dependencies
- Auth solution from dependencies
- API layer (REST/GraphQL/tRPC) from dependencies + route files

**Import alias mapping:**
- Read `tsconfig.json` / `jsconfig.json` paths field
- Read `vite.config` resolve.alias if present
- Document every alias -> actual path

**Environment variables:**
- Scan `.env.example`, `.env.local.example`, or env schema files (e.g., `env.ts`, `env.mjs`)
- Group by category (auth, database, API keys, URLs)
- List variable names only, never values

**Key patterns:**
- Error handling convention (throws vs result pattern)
- State management (Redux, Zustand, Jotai, context)
- API patterns (REST conventions, middleware chains, RPC)
- Naming conventions (file naming, function naming from existing code)

### Context Group Detection Table

| Project Signal | Context Group | all-*.md Content |
|---|---|---|
| Prisma/Drizzle/TypeORM/Sequelize + DB config | `database/` | Schema location, migration commands, client setup, key models |
| Docker/Dockerfile/docker-compose present | `container/` | Image structure, services, ports, build commands |
| Auth dependency (Clerk/NextAuth/Auth.js/Passport/Lucia) | `auth/` | Provider, config location, protected routes pattern |
| CI/CD config (.github/workflows, .circleci, .gitlab-ci) | `cicd/` | Pipeline stages, deployment targets, required secrets |
| Infrastructure code (terraform, pulumi, CDK, SST) | `infra/` | Provider, resource types, deployment commands |
| 3+ UI component directories or design system | `uxui/` | Component library, styling approach, design tokens |
| Workflow/queue system (BullMQ, Temporal, Inngest, etc.) | `workflows/` | Queue config, worker setup, job types |

**Rule:** Only create a group when the project has SUBSTANTIAL content for it -- at minimum 2+ source files dedicated to that domain. A single config file is not enough.

### Feature Detection Heuristics

Scan these locations for feature identification:

- Route directories (`app/*`, `pages/*`) -- each major route group is a potential feature
- Package names in monorepos -- each package with business logic is a potential feature
- README sections listing features
- Existing `docs/` or wiki content

**Feature folder creation threshold:**
- Create a feature folder only when the feature has 3+ source files AND is a distinct product area (not a utility)
- For monorepos: each app or business-logic package is a candidate
- For single apps: each major route group with its own components/API is a candidate

**Each feature folder gets:**
- `active/`, `completed/`, `backlog/`, `reports/`, `references/` subdirectories
- `_GUIDE.md` explaining the feature scope, key files, and current state

### all-context.md Population Instructions

After scanning (or receiving Round 1 findings), write real content into `all-context.md`. Replace the seed template sections with actual project data:

1. **Title**: Replace `{{project_name}}` with the actual project name
2. **Quick Start section**: Keep the generic routing instructions from the template
3. **Current Root Entry Points table**: Populate with actual context files that were created
4. **Current Context Groups table**: Populate with groups created by the context group detection step
5. **Task Routing table**: Fill based on what context groups exist, mapping task types to the relevant entry points
6. **Repository Structure**: Write actual directory tree output (2-3 levels deep, showing key directories and files)
7. **Technology Stack**: Write specific framework names, versions, and combinations discovered during analysis
8. **Key Patterns and Conventions**: Document actual patterns found in the codebase (error handling, state management, API patterns, naming conventions, import aliases)
9. **Environment and Configuration**: List actual env var groups found (names only, never values)
10. **Context Group Lifecycle**: Keep the generic instructions from the template
11. **Scan Metadata** (add at bottom):
    ```
    ## Scan Metadata

    - Generated: {ISO timestamp}
    - HEAD: {git rev-parse HEAD, if available}
    - Mode: {fresh/merge/refresh}
    - Package manager: {detected_pm}
    ```

### all-tests.md Population Instructions

After scanning test setup (or receiving Round 1 findings from Subagent B), write real content into `all-tests.md`:

1. **Title**: Replace `{{project_name}}` with the actual project name
2. **Quick Decision Guide**: Replace placeholder with actual test runner name(s) and when to use each. For monorepos with multiple runners, list each runner with its scope.
3. **Commands section**: List actual test commands per package/workspace in a table or code blocks
4. **Debugging Quick Reference**: Note any test config quirks found (e.g., "uses jsdom environment", "needs .env.test", "requires running database")
5. **Known Gaps**: Leave empty but remove any placeholder comments

### Migration Intelligence (for Merge/Refresh modes)

When existing `process/` content is found, follow these rules:

1. **Read every existing `.md` file under `process/context/`**
2. **For each file**:
   - Parse section headings
   - Identify which sections have real content vs placeholders/TODOs
   - Mark sections that need updating
3. **Compare existing content against fresh scan results**:
   - If existing content is MORE detailed than scan results -> preserve it
   - If existing content is a placeholder or stale -> replace with scanned data
   - If section is missing entirely -> add it with scanned data
4. **For context groups**:
   - Map existing groups to detected groups
   - Preserve groups that exist even if not detected (user may have created them intentionally)
   - Add only MISSING groups
5. **For feature folders**:
   - Preserve all existing feature folders and their contents
   - Add only MISSING feature folders that meet the detection threshold
6. **For all-context.md routing tables**:
   - Merge: add new entries, preserve existing entries
   - Update entries whose paths changed

## VALIDATE Phase

### Directory Existence Checks

Verify all directories from the target tree exist:

```bash
ls -d process/development-protocols/ process/context/ process/context/planning/ process/context/tests/ process/general-plans/active/ process/general-plans/completed/ process/general-plans/backlog/ process/general-plans/reports/ process/general-plans/references/ process/features/
```

### STUDY Output Quality Checks

Verify the STUDY phase produced real content:

1. **No remaining placeholders**: Grep `all-context.md` for `{{` -- only `{{project_name}}` is acceptable (and only if the seed was just created without a project name)
2. **Repository Structure populated**: `all-context.md` contains a code block under "Repository Structure" with actual directory names
3. **Technology Stack populated**: `all-context.md` contains specific framework names and versions under "Technology Stack"
4. **Test commands populated**: `all-tests.md` contains actual test commands (not `{{test_commands}}` or placeholder text)
5. **Context group routing**: Every context group directory under `process/context/` has a corresponding entry in the "Current Context Groups" table in `all-context.md`
6. **Feature folder guides**: Every feature folder under `process/features/` (excluding the root `_GUIDE.md`) has a `_GUIDE.md` file with a real scope description

### Agent Parity Check

Verify that agent names match between Claude and Codex surfaces:

```bash
ls .claude/agents/*.md | sed 's|.claude/agents/||;s|\.md$||' | sort > /tmp/claude-agents.txt
ls .codex/agents/*.toml | sed 's|.codex/agents/||;s|\.toml$||' | sort > /tmp/codex-agents.txt
diff /tmp/claude-agents.txt /tmp/codex-agents.txt
```

### Skill Discovery Check

Verify the symlink resolves:

```bash
ls -la .agents/skills
ls .agents/skills/vc-setup/SKILL.md
```

### Post-Setup

After validation passes, suggest these next steps to the user:

1. Review `process/context/all-context.md` and refine any sections that need more detail
2. Review detected context groups and feature folders -- add or remove as needed
3. Run `audit-context` skill to validate context discovery wiring
4. Start using the harness: describe a feature request to trigger the RIPER-5 workflow
