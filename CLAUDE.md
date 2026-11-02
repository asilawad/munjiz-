# Working Rules

## Language
- Reply in English only, with no Arabic characters, even when the user writes in Arabic. Understand Arabic, answer in English.

## Token saving
- Keep replies short: no long explanations, no repeating the request, no summaries of completed work unless asked.
- Never paste whole files; show only changed lines or a short diff.
- Search first (grep/glob), then read only the files and line ranges needed. Never read the whole project or generated folders (build/, .dart_tool/, node_modules/, android/build, etc.).
- Do not re-read files already read this session unless they changed.
- Do simple tasks (rename, small fix, formatting) directly, without long planning.
- Ask one short question only when truly blocked; otherwise make a reasonable assumption and state it in one line.
- Do not run builds, tests, or flutter analyze unless asked or the task needs it.

## Context management
- Keep PROJECT_NOTES.md (max ~50 lines) with project structure, key decisions, current status, next steps. Update it briefly after each finished task.
- At the start of a new session, read only CLAUDE.md and PROJECT_NOTES.md, not the whole codebase.
- When the conversation gets long, tell the user to run /compact, or /clear after updating PROJECT_NOTES.md.
- When the user switches to an unrelated task, remind them to run /clear first.
