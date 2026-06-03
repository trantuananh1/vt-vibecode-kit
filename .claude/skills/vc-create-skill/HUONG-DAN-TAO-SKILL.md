# Hướng Dẫn Tạo Skill

## Dùng Agent Để Tạo Skill Mới

### Cách 1: Nói Chuyện Với Agent

Đặt câu hỏi với agent:

```
"create a skill for design-system, role: role-sa, rules: consistent visual output, no inaccessible colors"

"build a skill for API, rules: always validate input"

"add a skill for database, rules: no N+1 queries"

"create a skill design-system for role-sa, rules: consistent visual output"
```

Agent sẽ đi qua từng step và hỏi xác nhận.

### Luồng Chi Tiết (Agent Hỏi Qua Từng Step)

```
BẠN: "create a skill for X, role: [R], rules: [Z]"
           ↓
┌─────────────────────────────────────────┐
│ STEP 1: CAPTURE INTENT                  │
│                                          │
│ AGENT hỏi:                               │
│ "Skill này làm gì?"                      │
│ "Role/scope là gì?"                      │
│ "Trigger phrases là gì?"                 │
│ "Rules: [Z]. Confirm?"                   │
│                                          │
│ BẠN trả lời → AGENT confirm              │
└────────────────────┬────────────────────┘
                     ↓
┌─────────────────────────────────────────┐
│ STEP 2: ANALYZE RESOURCES                │
│                                          │
│ AGENT hỏi:                               │
│ "Cần scripts gì?"                        │
│ "Cần references gì?"                     │
│ "Cần examples gì?"                       │
│                                          │
│ BẠN trả lời → AGENT confirm              │
└────────────────────┬────────────────────┘
                     ↓
┌─────────────────────────────────────────┐
│ STEP 3: CREATE STRUCTURE                │
│                                          │
│ AGENT hỏi:                               │
│ "Directory: .claude/skills/[role]/vc-xxx/"│
│ "Nếu không có role: .claude/skills/vc-xxx/"│
│ "Confirm?"                               │
│                                          │
│ BẠN confirm → AGENT tạo structure        │
└────────────────────┬────────────────────┘
                     ↓
┌─────────────────────────────────────────┐
│ STEP 4: WRITE SKILL.md                   │
│                                          │
│ 4a. AGENT hỏi trigger phrases            │
│     "3-5 phrases cụ thể?"                │
│                                          │
│ 4b. AGENT hỏi rules confirmation         │
│     "Rules: [Z]. Include?"               │
│                                          │
│ 4c. AGENT viết body                      │
│     "Body đã viết. Confirm?"              │
│                                          │
│ 4d. AGENT hỏi progressive disclosure    │
│     "Chi tiết nào sang references?"       │
└────────────────────┬────────────────────┘
                     ↓
┌─────────────────────────────────────────┐
│ STEP 5: ADD RESOURCES                   │
│                                          │
│ AGENT hỏi:                               │
│ "Thêm scripts/references/examples?"     │
│                                          │
│ BẠN confirm                              │
└────────────────────┬────────────────────┘
                     ↓
┌─────────────────────────────────────────┐
│ STEP 6: VALIDATE                         │
│                                          │
│ AGENT chạy checklist:                    │
│ □ Structure: SKILL.md, frontmatter       │
│ □ Content: lean, rules included         │
│ □ Progressive disclosure                 │
│                                          │
│ "All passed. Done?"                      │
└─────────────────────────────────────────┘
```

### Những Câu Hỏi Agent Sẽ Hỏi

#### Step 1: Capture Intent
| Câu hỏi | Mục đích |
|---------|----------|
| "Skill này làm gì?" | Core functionality |
| "Role/scope là gì?" | Quyết định skill tạo ở root hay nested path, ví dụ `role-sa` |
| "Trigger phrases là gì?" | Khi nào activate |
| "Rules cần tuân theo?" | **QUAN TRỌNG** - capture rules từ user |
| "Có skill tương tự trong role/scope này chưa?" | Tránh duplicate |

#### Step 2: Analyze Resources
| Câu hỏi | Mục đích |
|---------|----------|
| "Cần scripts gì?" | Automation |
| "Cần references gì?" | Detailed docs |
| "Cần examples gì?" | Templates |

#### Step 3: Create Structure
| Câu hỏi | Mục đích |
|---------|----------|
| "Directory structure: [X]. Confirm?" | Tránh sai path, đặc biệt khi có role/scope |

#### Step 4a: Trigger Phrases
| Câu hỏi | Mục đích |
|---------|----------|
| "Trigger phrases: [X]. Good?" | Validation |

#### Step 4b: Rules
| Câu hỏi | Mục đích |
|---------|----------|
| "Rules đã capture: [X]. Good?" | Đảm bảo rules được include |

#### Step 4d: Progressive Disclosure
| Câu hỏi | Mục đích |
|---------|----------|
| "Chi tiết nào nên sang references/?" | SKILL.md lean |

#### Step 5: Bundled Resources
| Câu hỏi | Mục đích |
|---------|----------|
| "Thêm [X] vào references/?" | Hoàn thiện resources |

#### Step 6: Validate
| Câu hỏi | Mục đích |
|---------|----------|
| "All checklist passed. Done?" | Final confirmation |

### Ví Dụ Thực Tế

**Bạn nói:**
```
create a skill for design-system, role: role-sa, rules: consistent visual output, no inaccessible colors
```

**Agent đi qua từng step:**

```
STEP 1:
"Skill design-system làm gì? (visual explanations, diagrams, HTML recaps?)"
"Role/scope: role-sa. Confirm?"
"Trigger phrases? ('generate diagram', 'create visual explanation', 'design-system recap')"
"Rules: consistent visual output, no inaccessible colors. Confirm?"

BẠN: "Confirm"

STEP 2:
"Cần scripts gì? (build, test, lint?)"
"Cần references gì? (design tokens, component docs?)"

BẠN: "Thêm design tokens docs"

STEP 3:
"Directory: .claude/skills/role-sa/vc-design-system/"
"Không cần per-skill symlink vì .agents/skills đã trỏ tới .claude/skills"

STEP 4a:
"Trigger phrases: 'generate diagram', 'create visual explanation', 'design-system recap'. Good?"

STEP 4b:
"Rules section sẽ include:
- Consistent Visual Output: Reuse design tokens and layout rules
- No Inaccessible Colors: Maintain contrast and readable text"
"Confirm?"

STEP 4c:
"SKILL.md body đã viết"

STEP 4d:
"Chi tiết nào nên sang references/? (design tokens, visual patterns, HTML/CSS patterns)"

STEP 5:
"Tạo references/design-tokens.md, references/html-css-patterns.md, examples/diagram.html"

STEP 6:
"Checklist passed. Done?"
```

**Output:**
```
.claude/skills/role-sa/vc-design-system/
├── SKILL.md
│   ├── name: vc:design-system
│   ├── Trigger: "generate diagram", "create visual explanation"...
│   ├── Role/scope: role-sa
│   ├── Rules: consistent visual output, no inaccessible colors
│   └── Workflow
├── references/
│   ├── design-tokens.md
│   └── html-css-patterns.md
└── examples/
    └── diagram.html
```

### Cách 2: Dùng Skill Trực Tiếp

```
Use vc-create-skill to create a skill for [your use case] with role [optional role/scope] and rules [your rules]
```

### Quan Trọng: Rules Cần Được Embed Vào Skill

Role/scope từ user sẽ quyết định **đường dẫn tạo skill**, còn rules từ user sẽ được **embed vào SKILL.md**:

```text
role: none    → .claude/skills/vc-frontend/
role: role-sa → .claude/skills/role-sa/vc-design-system/
```

Rules section example:

```markdown
## Rules

- **No XSS**: Always sanitize user input before rendering
- **Type Safety**: Never use `as any` or `@ts-ignore`
- **No N+1**: Always use eager loading for related data
```

Agent khi dùng skill này sẽ đọc rules và tuân thủ.

## Skill là gì?

Skill là module mở rộng giúp agent có khả năng chuyên biệt cho một domain/task cụ thể. Nghĩ như "course bồi dưỡng chuyên môn" - biến agent từ general-purpose thành specialist.

## Cấu Trúc Skill

```
skill-name/
├── SKILL.md (bắt buộc)
│   ├── YAML frontmatter (name, description)
│   └── Markdown instructions
└── Bundled Resources (tùy chọn)
    ├── scripts/    - Code thực thi
    ├── references/ - Tài liệu load khi cần
    └── assets/     - Files dùng trong output
```

## Quy Tắc Đặt Tên

- Prefix `vc-` cho project skills (ví dụ: `vc-debug`, `vc-security`)
- Kebab-case (ví dụ: `create-skill`, không phải `createSkill`)
- Mô tả nhưng ngắn gọn (2-3 từ)

## Trigger Phrases

Description trong frontmatter quyết định khi nào skill được activate. Phải:
- Third person: "This skill should be used when..."
- Include specific phrases người dùng sẽ nói
- "Pushy" - tránh undertriggering

```yaml
# BAD
description: Helps with tasks.

# GOOD  
description: This skill should be used when the user asks to "debug an issue", "find the bug", "investigate why", or needs root cause analysis.
```

## Progressive Disclosure

Skills dùng 3-level loading để quản lý context:

### Level 1: Metadata (~100 words)
```yaml
---
name: skill-name
description: This skill should be used when...
---
```
Luôn load khi skill được mention.

### Level 2: SKILL.md Body (<2,500 words)
```markdown
# Skill Name

[Core concepts overview]

## Workflow
[Step-by-step]

## Additional Resources
[Pointers to references/]
```
Load khi skill trigger.

### Level 3: Bundled Resources
```
references/  → Docs load khi cần
examples/    → Code để copy/adapter  
scripts/     → Executable không cần load vào context
```

**Nguyên tắc:** SKILL.md phải lean. Chi tiết move sang references/.

## Hướng Dẫn Viết SKILL.md

### Frontmatter

```yaml
---
name: vc-my-skill
description: This skill should be used when the user asks to "do X", "help with Y", or needs Z.
version: 0.1.0
---
```

### Writing Style

**Đúng:**
```markdown
To validate the input, check that all required fields are present.
Use the grep tool to search for patterns.
Run the validation script before proceeding.
```

**Sai:**
```markdown
You should validate the input first.
You need to check that all fields are present.
```

→ Imperative form (verb-first), không second person.

## Các Lỗi Thường Gặp

### 1. Trigger Description Yếu
```yaml
# BAD
description: Provides guidance for working with hooks.

# GOOD
description: This skill should be used when the user asks to "create a hook", "add a PreToolUse hook", "validate tool use", or mentions hook events.
```

### 2. Quá Nhiều Trong SKILL.md
```yaml
# BAD - Một file 8,000 words
skill-name/
└── SKILL.md (bloat)

# GOOD - Progressive disclosure
skill-name/
├── SKILL.md (1,800 words)
└── references/
    ├── patterns.md
    └── advanced.md
```

### 3. Second Person
```markdown
# BAD
You should start by reading the config file.

# GOOD  
Start by reading the config file.
```

### 4. Thiếu Resource References
```markdown
# BAD
## SKILL.md
[No mention of references/]

# GOOD
## Additional Resources
- **`references/patterns.md`** - Detailed patterns
```

## Mở Rộng Reference Files

Với files >300 lines, thêm table of contents:

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
```

## Domain Organization

Khi skill hỗ trợ nhiều domains/frameworks:

```
cloud-deploy/
├── SKILL.md (workflow + selection)
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```

Claude đọc chỉ reference file phù hợp dựa trên context.

## Scripts

Scripts phải executable:

```bash
chmod +x scripts/validate.sh
```

Scripts có thể execute mà không cần load vào context - tiết kiệm tokens.

## Testing

### 1. Verify Structure
```bash
ls -la .claude/skills/vc-your-skill/
head -10 .claude/skills/vc-your-skill/SKILL.md
```

### 2. Test Triggering
Prompt với trigger phrases - skill phải activate.

### 3. Verify Content Loads
- SKILL.md body load khi trigger
- references/ files load khi được refer
- examples/ accessible
- scripts/ executable

### 4. Iterate
- Strengthen triggers nếu undertriggering
- Move content sang references/ nếu SKILL.md quá lớn
- Add examples cho common use cases

## Versioning

Start at `0.1.0` và follow semver:
- `patch` (0.1.0 → 0.1.1): Bug fixes
- `minor` (0.1.0 → 0.2.0): New features
- `major` (0.1.0 → 1.0.0): Breaking changes

## Security - Principle of Lack of Surprise

Skills không được chứa:
- Malware hoặc exploit code
- Content gây nguy hiểm system security
- Instructions gây mislead user

**Được phép:**
- Roleplay skills cho creative writing
- Skills giải thích concepts
- Skills generate content trong scope

## Ví Dụ Hoàn Chỉnh

### Tạo skill `vc-lint`

1. **Xác định intent:**
   - Lint và format code
   - Trigger: "lint code", "format file", "eslint"
   - Output: List errors, formatted code

2. **Analyze resources:**
   - Scripts: `run-lint.sh`, `format.sh`
   - References: `lint-configs.md` (ESLint, Prettier configs)
   - Examples: `.eslintrc.json`, `.prettierrc`

3. **Create structure:**
   ```bash
   mkdir -p .claude/skills/vc-lint/{references,examples,scripts}
   touch .claude/skills/vc-lint/SKILL.md
   ```

4. **Write SKILL.md:**
   ```markdown
   ---
   name: vc-lint
   description: This skill should be used when the user asks to "lint code", "format file", "check eslint", "prettier", or needs code quality checks.
   version: 0.1.0
   ---

   # Code Linting and Formatting

   Lint và format code với ESLint, Prettier, và các tools khác.

   ## Core Concepts

   - Linting: Static code analysis
   - Formatting: Style consistency
   - Config: Per-project configurations

   ## Workflow

   To lint code, run the appropriate linter for the file type.
   To format code, use the project's prettier/eslint config.

   ## Additional Resources

   - **`references/lint-configs.md`** - Detailed configs
   - **`examples/.eslintrc.json`** - ESLint config example
   ```

5. **Add resources:**
   - Tạo `references/lint-configs.md`
   - Tạo `examples/.eslintrc.json`
   - Tạo `scripts/run-lint.sh`

6. **Validate:**
   - Checklist verification
   - Test trigger phrases
   - Verify structure

## Quick Reference

### Minimal Skill
```
skill-name/
└── SKILL.md
```

### Standard Skill (Recommended)
```
skill-name/
├── SKILL.md
├── references/
│   └── detailed-topic.md
└── examples/
    └── working-example.sh
```

### Complex Skill
```
skill-name/
├── SKILL.md
├── references/
│   ├── patterns.md
│   └── advanced.md
├── examples/
│   └── example.sh
└── scripts/
    └── validate.sh
```

## Liên Kết

- Skill gốc: `anthropics/claude-code/plugins/plugin-dev/skills/skill-development`
- Skill creator: `anthropics/skills/skills/skill-creator`
- Skill trong repo này: `.claude/skills/vc-create-skill/`