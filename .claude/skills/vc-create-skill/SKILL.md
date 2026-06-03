---
name: vc-create-skill
description: This skill should be used when the user asks to "create a skill", "write a new skill", "build a skill", "add a skill", "make a skill", "design a skill", "develop a skill", or needs guidance on skill structure, progressive disclosure, skill development best practices, or how to create reusable skill modules. This skill creates other skills.
version: 0.1.0
---

# Create Skill

A meta-skill that creates other skills. Use this when building capability modules for the agent harness.

## When to Use This Skill

This skill triggers when the user wants to create a new skill for the harness. It guides through the complete skill creation workflow: from understanding intent, to writing the SKILL.md, to organizing bundled resources, to validation.

## The Skill Creation Workflow

Follow these steps in order. After each step, ask confirmation questions before proceeding.

### Step 1: Capture Intent

Understand what the new skill should do. Ask:

1. **What should this skill enable the agent to do?**
2. **When should it trigger?** (specific user phrases/contexts)
3. **What is the expected output or behavior?**
4. **Are there existing skills in the codebase that do something similar?**
5. **What rules should this skill follow?** (e.g., "no XSS", "type safety", "no as any", "always validate input")

Check existing skills for reference patterns:
```bash
ls .claude/skills/
ls .agents/skills/
```

**Confirmation before proceeding:**
- "Skill này enable agent làm [X], trigger khi [Y], tuân theo rules [Z]. Confirm?"
- "Có rules nào khác cần thêm không?"

### Step 2: Analyze Reusable Resources

For the skill's intended functionality, determine what bundled resources are needed:

**Scripts (`scripts/`)** — Executable code for deterministic/repetitive tasks
- When the same code would be rewritten repeatedly
- When deterministic reliability is needed
- Example: `scripts/validate.sh` for validation utilities

**References (`references/`)** — Documentation loaded into context as needed
- Detailed patterns, schemas, API docs
- Company-specific knowledge
- Keep under 3,000 words per file; larger content goes here

**Assets (`assets/`)** — Files used in output (templates, icons, fonts)
- Templates that get copied or modified
- Brand assets, boilerplate code

**Confirmation before proceeding:**
- "Skill này cần: scripts [S], references [R], examples [E]. Confirm?"
- "Cần thêm resources nào khác không?"

### Step 3: Create Skill Structure

Create the skill directory in `.claude/skills/`:

```bash
SKILL_NAME="skill-name"  # kebab-case, must start with vc-
mkdir -p .claude/skills/$SKILL_NAME/{references,examples,scripts}
touch .claude/skills/$SKILL_NAME/SKILL.md
```

Also create a symlink for Codex discovery:
```bash
ln -sf ../../.claude/skills/$SKILL_NAME .agents/skills/$SKILL_NAME
```

**Confirmation before proceeding:**
- "Directory structure tại `.claude/skills/$SKILL_NAME/`. Confirm?"
- "Symlink đã tạo. Proceed?"

### Step 4: Write SKILL.md

Ask confirmation at each sub-step before writing:

#### 4a: Confirm Trigger Phrases
**Ask:** "Trigger phrases cho skill này là gì? (3-5 cụm cụ thể)"

Validate:
- [ ] At least 3 trigger phrases
- [ ] Specific, not generic
- [ ] Uses third-person format: "This skill should be used when..."

**Confirm:** "Trigger phrases: [X], [Y], [Z]. Good?"

#### 4b: Confirm Rules Section
**Ask:** (if user provided rules) "Rules đã capture đúng chưa?"

Include in SKILL.md:
```markdown
## Rules

- **No XSS**: Always sanitize user input before rendering
- **Type Safety**: Never use `as any` or `@ts-ignore`
- [Add user's rules here]
```

**Confirm:** "Rules section sẽ include [X], [Y]. Good?"

#### 4c: Write Body
Write SKILL.md body with:
- Core concepts (1-2 paragraphs)
- Workflow (imperative form, verb-first)
- Rules section (from Step 4b)
- Additional Resources (pointers to bundled files)

**Writing style check:**
- [ ] Imperative form (not "You should...")
- [ ] Objective language
- [ ] No second person

**Confirm:** "SKILL.md body đã viết xong. Confirm để tiếp tục?"

#### 4d: Confirm Progressive Disclosure
**Ask:** "Chi tiết nào nên move sang references/?"

Determine:
- What goes in SKILL.md (core, ~1,500-2,500 words)
- What goes in references/ (detailed, >3,000 words or >300 lines)

**Confirm:** "SKILL.md: [summary], references/: [list]. Good?"

### Step 5: Add Bundled Resources

Create the actual resource files:

**references/xxx.md** — For detailed documentation
**examples/xxx** — Working code examples (chmod +x if scripts)
**scripts/xxx** — Utility scripts (must be executable)

**Ask:** "Có templates, docs, hoặc scripts cụ thể cần thêm vào không?"

**Confirm:** "Resources đã tạo: [list]. Good?"

### Step 6: Validate

Run the validation checklist before finishing:

**Structure checklist:**
- [ ] SKILL.md exists with valid YAML frontmatter
- [ ] Frontmatter has `name` and `description`
- [ ] Description uses third person and includes trigger phrases
- [ ] Body uses imperative form (not second person)

**Content checklist:**
- [ ] SKILL.md is lean (ideally 1,500-2,500 words)
- [ ] Rules section included (if user provided rules)
- [ ] Detailed content moved to references/
- [ ] Examples are complete and working
- [ ] Scripts are executable (chmod +x)

**Progressive disclosure checklist:**
- [ ] Core concepts in SKILL.md
- [ ] Detailed docs in references/
- [ ] Working code in examples/
- [ ] Utilities in scripts/
- [ ] SKILL.md references all bundled resources

**Final confirmation:** "Skill `vc-xxx` đã hoàn thành. Tất cả checklist passed. Done?"

#### Frontmatter (Required)

```yaml
---
name: skill-name
description: This skill should be used when the user asks to "specific phrase 1", "specific phrase 2", "specific phrase 3". Be concrete and specific about trigger phrases.
version: 0.1.0
---
```

**Description rules:**
- Third person: "This skill should be used when..."
- Include specific phrases users would say
- Make descriptions "pushy" — avoid undertriggering
- Example: Instead of "Helps with file conversions", write "This skill should be used when the user asks to 'convert PDF to text', 'extract text from PDF', 'parse document content', or needs to work with PDF files in any format."

#### Body Structure

```markdown
# Skill Name

One paragraph describing what this skill does and when to use it.

## Core Concepts

Explain the essential ideas behind what this skill does.

## Workflow

Step-by-step instructions using imperative form (verb-first).

## Additional Resources

### Vietnamese Guide
- **`HUONG-DAN-TAO-SKILL.md`** - Hướng dẫn tiếng Việt cho việc tạo skill mới

### Reference Files
- **`references/skill-development-reference.md`** - Detailed patterns, frontmatter templates, writing style guide, and validation checklist

### Examples
- **`examples/example.sh`** - Working example

### Scripts
- **`scripts/validate.sh`** - Validation utility
```

#### Writing Style

- **Imperative/infinitive form**: "To do X, do Y" not "You should do X"
- **Objective, instructional language**: Focus on what to do, not who should do it
- **Keep SKILL.md lean**: 1,500-2,500 words ideal. Move details to references/

### Step 5: Add Bundled Resources

Create the actual resource files:

**references/xxx.md** — For detailed documentation:
```markdown
# Detailed Topic

Content here. Be comprehensive but organized with clear headings.
```

**examples/xxx** — Working code examples:
```bash
#!/bin/bash
# Complete, runnable example
```

**scripts/xxx** — Utility scripts:
```bash
#!/bin/bash
# Validation or automation script
chmod +x scripts/xxx
```

### Step 6: Validate the Skill

Check the skill meets quality standards:

**Structure checklist:**
- [ ] SKILL.md exists with valid YAML frontmatter
- [ ] Frontmatter has `name` and `description` fields
- [ ] Description uses third person and includes trigger phrases
- [ ] Body uses imperative form (not second person)

**Content checklist:**
- [ ] SKILL.md is lean (ideally 1,500-2,500 words)
- [ ] Detailed content moved to references/
- [ ] Examples are complete and working
- [ ] Scripts are executable (chmod +x)

**Progressive disclosure checklist:**
- [ ] Core concepts in SKILL.md
- [ ] Detailed docs in references/
- [ ] Working code in examples/
- [ ] Utilities in scripts/
- [ ] SKILL.md references all bundled resources

## Skill Anatomy Quick Reference

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter (name, description required)
│   └── Markdown instructions
└── Bundled Resources (optional)
    ├── scripts/    - Executable code
    ├── references/ - Documentation loaded as needed
    └── assets/     - Files used in output
```

## Reference: Existing Skills in This Harness

Study these skills as templates:

| Skill | What to study |
|-------|---------------|
| `vc-generate-plan` | Plan creation workflow, structured output |
| `vc-debug` | Clear trigger phrases, focused scope |
| `vc-security` | Comprehensive references structure |
| `vc-scenario` | Edge case generation patterns |

## Common Mistakes to Avoid

### Mistake 1: Weak Trigger Description
```yaml
# BAD - Vague, no specific trigger phrases, not third person
description: Provides guidance for working with hooks.

# GOOD - Third person, specific phrases, concrete scenarios
description: This skill should be used when the user asks to "create a hook", "add a PreToolUse hook", "validate tool use", or mentions hook events. Provides comprehensive hooks API guidance.
```

### Mistake 2: Too Much in SKILL.md
```yaml
# BAD - Everything in one file (8,000+ words)
skill-name/
└── SKILL.md  (8,000 words - bloated)

# GOOD - Progressive disclosure
skill-name/
├── SKILL.md  (1,800 words - core essentials)
└── references/
    ├── patterns.md (2,500 words)
    └── advanced.md (3,700 words)
```

### Mistake 3: Second Person Writing
```markdown
# BAD
You should start by reading the configuration file.
You need to validate the input.
You can use the grep tool to search.

# GOOD
Start by reading the configuration file.
Validate the input before processing.
Use the grep tool to search for patterns.
```

### Mistake 4: Missing Resource References
```markdown
# BAD - Claude doesn't know references exist
## SKILL.md
[Core content]
[No mention of references/ or examples/]

# GOOD - Clear pointers to bundled resources
## Additional Resources

### Reference Files
- **`references/patterns.md`** - Detailed patterns and techniques
- **`references/advanced.md`** - Advanced techniques

### Examples
- **`examples/script.sh`** - Working example
```

## Testing a New Skill

After creating a skill, test it:

### 1. Verify Structure
```bash
# Check skill exists
ls -la .claude/skills/vc-your-skill/

# Verify SKILL.md has valid frontmatter
head -10 .claude/skills/vc-your-skill/SKILL.md
```

### 2. Test Triggering
Prompt with trigger phrases:
- "create a skill for X" - should trigger vc-create-skill
- Your new skill's trigger phrases - should trigger your new skill

### 3. Verify Content Loads
- SKILL.md body loads when skill triggers
- references/ files load when referenced
- examples/ are accessible and complete
- scripts/ are executable

### 4. Iterate Based on Usage
- Strengthen trigger phrases if undertriggering
- Move content to references/ if SKILL.md is too large
- Add examples for common use cases
- Clarify ambiguous instructions

## Examples from Plugin-Dev to Study

These skills in `anthropics/claude-code` demonstrate best practices:

| Skill | What to Study |
|-------|---------------|
| `hook-development` | Progressive disclosure, utilities, 3 references/, 3 examples/, 3 scripts/ |
| `agent-development` | AI-assisted creation, references include AI generation prompts |
| `plugin-settings` | Specific triggers, real implementations referenced |
| `command-development` | Clear critical concepts, focused SKILL.md |
| `plugin-structure` | Good organization, clean structure |

**Key metrics from plugin-dev skills:**
- `hook-development`: SKILL.md ~1,651 words, lean but comprehensive
- `agent-development`: SKILL.md ~1,438 words, strong triggers
- Progressive disclosure: 3-level loading works well

## Progressive Disclosure in Skills

Skills use a three-level loading system:

1. **Metadata** (name + description) — Always in context (~100 words)
2. **SKILL.md body** — In context when skill triggers (<2,500 words)
3. **Bundled resources** — Loaded as needed (scripts can execute without loading)

## Next Steps After Creation

After creating a skill:
1. Test it by prompting with trigger phrases
2. Refine trigger descriptions based on activation
3. Improve SKILL.md based on usage patterns
4. Consider description optimization for better triggering

## Updating Existing Skills

When improving an existing skill:
1. Read the current SKILL.md first
2. Identify what works and what doesn't
3. Apply the same validation checklist
4. Keep the original name and directory structure
5. Version bump if needed (patch: 0.1.0 → 0.1.1)