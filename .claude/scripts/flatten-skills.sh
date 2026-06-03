#!/usr/bin/env bash
# Flattens two-level skill structure for Claude Code discovery.
# Role group dirs (ba/, dev/) are source of truth.
# Flat copies under .claude/skills/<name>/ are auto-generated and gitignored.

SKILLS_DIR=".claude/skills"
ROLE_DIRS=(role-sa role-be role-fe role-mobile)
GITIGNORE=".gitignore"

# Remove flat copies whose role-source was deleted
for flat_dir in "$SKILLS_DIR"/*/; do
  [ -d "$flat_dir" ] || continue
  skill_name=$(basename "$flat_dir")
  [ -f "$flat_dir/.auto" ] || continue

  source_found=false
  for role in "${ROLE_DIRS[@]}"; do
    [ -d "$SKILLS_DIR/$role/$skill_name" ] && source_found=true && break
  done
  $source_found || rm -rf "$flat_dir"
done

# Create/refresh flat copies from each role folder
for role in "${ROLE_DIRS[@]}"; do
  role_dir="$SKILLS_DIR/$role"
  [ -d "$role_dir" ] || continue

  for skill_dir in "$role_dir"/*/; do
    [ -f "$skill_dir/SKILL.md" ] || continue
    skill_name=$(basename "$skill_dir")
    flat_dir="$SKILLS_DIR/$skill_name"

    mkdir -p "$flat_dir"
    cp "$skill_dir/SKILL.md" "$flat_dir/SKILL.md"
    touch "$flat_dir/.auto"

    # Register in .gitignore if not already present
    entry=".claude/skills/$skill_name/"
    if ! grep -qF "$entry" "$GITIGNORE" 2>/dev/null; then
      echo "$entry" >> "$GITIGNORE"
    fi
  done
done
