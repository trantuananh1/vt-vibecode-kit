# Skill Development Reference

## Skill Naming and Path Conventions

- Use `vc-` prefix for skill folder names (e.g., `vc-debug`, `vc-security`, `vc-design-system`)
- Use kebab-case for folder names (e.g., `vc-create-skill`, not `vcCreateSkill` or `vc_create_skill`)
- Use `vc:*` format for public frontmatter names when following existing repo convention (e.g., folder `vc-design-system` → `name: vc:design-system`)
- Names should be descriptive but concise (2-3 words max)

### Root-Level Skill Path

Use this for general-purpose skills:

```
.claude/skills/vc-frontend/
└── SKILL.md
```

### Role-Scoped Skill Path

Use this when the user supplies a role/scope such as `role-sa`:

```
.claude/skills/role-sa/vc-design-system/
└── SKILL.md
```

The folder path carries the role/scope. The frontmatter name remains the public skill identifier:

```yaml
---
name: vc:design-system
description: This skill should be used when the user asks to "generate a design-system diagram", "create visual explanation", or needs role-sa design-system outputs.
version: 0.1.0
---
```

## Frontmatter Patterns

### Standard Frontmatter
```yaml
---
name: vc:skill-name
description: This skill should be used when the user asks to "phrase 1", "phrase 2", "phrase 3". Be concrete and specific.
version: 0.1.0
---
```

### Agent Skill Frontmatter (for agent-defining skills)
```yaml
---
name: vc:my-agent
description: This agent should be used for [specific domain]. Triggers when user says "do [something]", "help with [task]".
version: 0.1.0
agent_type: vc-execute-agent  # or other agent type
---
```

## Trigger Phrase Patterns

### Good Examples
```yaml
description: This skill should be used when the user asks to "create a hook", "add a PreToolUse hook", "validate tool use", or mentions hook events (PreToolUse, PostToolUse, Stop).
```

```yaml
description: This skill should be used when the user asks to "debug an issue", "find the bug", "trace an error", "investigate why X is failing", or needs root cause analysis for unexpected behavior.
```

### Bad Examples
```yaml
description: Use this skill when you need help.  # Second person, vague
description: Helps with debugging.  # No trigger phrases
description: Provides guidance for working with hooks.  # Weak, generic
```

## Directory Structure Patterns

### Minimal Skill
```
vc-skill-name/
└── SKILL.md
```

### Standard Skill (Recommended)
```
vc-skill-name/
├── SKILL.md
├── references/
│   └── detailed-topic.md
└── examples/
    └── working-example.sh
```

### Role-Scoped Skill
```
role-sa/
└── vc-design-system/
    ├── SKILL.md
    ├── references/
    │   └── visual-patterns.md
    └── examples/
        └── diagram.html
```

### Complex Skill
```
vc-skill-name/
├── SKILL.md
├── references/
│   ├── patterns.md
│   └── advanced.md
├── examples/
│   ├── example1.sh
│   └── example2.json
└── scripts/
    └── validate.sh
```

## Imperative Form Examples

### Correct
```markdown
To validate the input, check that all required fields are present.
Use the grep tool to search for patterns.
Run the validation script before proceeding.
```

### Incorrect
```markdown
You should validate the input first.
You need to check that all fields are present.
The user can run the validation script.
```

## Progressive Disclosure Template

### SKILL.md (Core - ~1,500-2,500 words)
```markdown
# Skill Name

One paragraph overview.

## Core Concepts
Essential ideas (1-2 sentences each).

## Workflow
Step-by-step procedure in imperative form.

## Quick Reference
Essential tables, checklists.

## Additional Resources
Reference bundled files clearly.
```

### references/detailed.md (Detailed - as needed)
```markdown
# Detailed Topic

Comprehensive content here. Use clear headings. Include:
- Detailed patterns
- Edge cases
- Troubleshooting
- Full examples
```

## Skill Triggering Logic

Skills appear in `available_skills` with name + description. The model decides whether to consult a skill based on:
1. Description matching the current task
2. Complexity of the task (simple tasks may not trigger skills)
3. Specific trigger phrases in the description

**Best practices for triggering:**
- Include 3-5 specific trigger phrases
- Use "pushy" language ("This skill should be used when...")
- Cover different phrasings of the same intent
- Include edge cases and variations

## Validation Checklist

Before finalizing any skill:

**Structure:**
- [ ] SKILL.md exists with valid YAML frontmatter
- [ ] Frontmatter has `name` and `description`
- [ ] Description uses third person
- [ ] Description includes specific trigger phrases

**Content:**
- [ ] SKILL.md uses imperative form throughout
- [ ] SKILL.md is lean (not bloated)
- [ ] Detailed content is in references/
- [ ] Examples are complete and working

**Resources:**
- [ ] Referenced files actually exist
- [ ] Scripts are executable (chmod +x)
- [ ] All paths in SKILL.md match actual file locations

## Common Pitfalls

1. **Weak triggers** → Be specific: "create X" not "work with X"
2. **Bloating SKILL.md** → Move details to references/
3. **Second person** → Use imperative: "Do X" not "You should do X"
4. **Missing resources** → Don't reference files that don't exist
5. **No examples** → Include working code examples

## Three-Level Loading System

Skills use progressive disclosure to manage context efficiently:

### Level 1: Metadata (~100 words, always in context)
```yaml
---
name: skill-name
description: This skill should be used when...
---
```
- Always loaded when skill is mentioned
- Compact, high-signal triggering information

### Level 2: SKILL.md Body (<2,500 words, loaded on trigger)
```markdown
# Skill Name

[Core concepts overview]

## Workflow

[Step-by-step instructions]

## Additional Resources

[Pointers to references/]
```
- Core concepts and essential procedures
- Quick reference tables and checklists
- Pointers to bundled resources
- Most common use cases

### Level 3: Bundled Resources (unlimited, as needed)
```
references/    → Documentation loaded when needed
examples/      → Working code, copy and adapt
scripts/       → Executable without loading into context
```
- Loaded on demand, not eagerly
- Scripts can execute without reading into context
- Large reference files (2,000-5,000+ words) go here

## What Goes Where

### In SKILL.md (Core - always loaded)
- Core concepts and overview
- Essential procedures and workflows
- Quick reference tables
- Pointers to references/examples/scripts
- Most common use cases
- **Target: 1,500-2,500 words, max 3,000**

### In references/ (Detailed - loaded as needed)
- Detailed patterns and advanced techniques
- Comprehensive API documentation
- Migration guides
- Edge cases and troubleshooting
- Extensive examples and walkthroughs
- **Each file: 2,000-5,000+ words as needed**

### In examples/ (Working code)
- Complete, runnable scripts
- Configuration files
- Template files
- Real-world usage examples
- **Users copy and adapt these directly**

### In scripts/ (Utilities)
- Validation tools
- Testing helpers
- Parsing utilities
- Automation scripts
- **Must be executable (chmod +x)**

## Domain Organization Pattern

When a skill supports multiple domains/frameworks, organize by variant:

```
cloud-deploy/
├── SKILL.md (workflow + selection logic)
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```

Claude reads only the relevant reference file based on context.

## Large Reference Files

For reference files over 300 lines, include a table of contents:

```markdown
# Detailed Patterns

## Table of Contents
1. [Basic Patterns](#basic-patterns)
2. [Advanced Patterns](#advanced-patterns)
3. [Troubleshooting](#troubleshooting)

## Basic Patterns
...

## Advanced Patterns
...

## Troubleshooting
...
```

## Skill Versioning

Start at `0.1.0` and follow semver:
- `patch` (0.1.0 → 0.1.1): Bug fixes, typo corrections
- `minor` (0.1.0 → 0.2.0): New features, backward compatible
- `major` (0.1.0 → 1.0.0): Breaking changes

Update version when:
- Adding new bundled resources
- Changing trigger phrases
- Restructuring SKILL.md significantly
- Fixing bugs that affect behavior

## Principle of Lack of Surprise

Skills must not contain:
- Malware or exploit code
- Content that could compromise system security
- Misleading or deceptive instructions

A skill's contents should not surprise the user in their intent. Don't create:
- Skills designed to facilitate unauthorized access
- Skills for data exfiltration
- Deceptive or misleading skills

**OK:**
- Roleplay skills for creative writing
- Skills that explain concepts
- Skills that generate content within scope