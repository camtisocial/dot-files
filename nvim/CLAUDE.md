# [Title]
[description]


## TECH STACK


## RULES

### Development approach
- Build the minimal functioning product first — bare minimum architecture and functionality before adding any complexity
- Get something working end-to-end before layering on features
- If in doubt, do less and do it well

### Git workflow
[to be filled by /kickoff — e.g. "Claude handles commits and pushes" or "manual git only"]


## Documentation

At the start of this session, create a project folder and overview:

```
/home/wisp/repos/work/Documentation/[project-name]/
  overview.md        ← what the project does, stack choices, how to run it
  decisions.md       ← key architectural decisions and why
  api.md             ← endpoints or interfaces (if applicable)
```

**On session start:** Create the folder and populate `overview.md` with the project description, stack, and run instructions.

**During the session:** Append to `decisions.md` when a meaningful technical choice is made (e.g. "chose SQLite over Postgres because zero config", "used polling instead of websockets to keep scope tight").

**On session end:** Do a final pass — make sure `overview.md` is accurate and `decisions.md` captures anything notable. Add a `## What's missing` section to `overview.md` if there are known gaps or next steps.

