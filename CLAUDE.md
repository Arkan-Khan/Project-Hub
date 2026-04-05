# Claude Code Instructions

**IMPORTANT: Before exploring the codebase, read the `.ai/` folder first!**

This project has comprehensive documentation in the `.ai/` directory that will save you significant time and tokens.

## Quick Start

```
.ai/
├── README.md           # Start here - project overview
├── PROJECT_OVERVIEW.md # System architecture
├── BACKEND.md          # NestJS modules, services, patterns
├── FRONTEND.md         # Next.js pages, components, hooks
├── API_REFERENCE.md    # All API endpoints
├── FILE_MAP.md         # Directory structure
└── RECENT_CHANGES.md   # Latest updates
```

## Priority Reading Order

1. `.ai/README.md` - Quick context (2 min read)
2. `.ai/RECENT_CHANGES.md` - What changed recently
3. `.ai/FILE_MAP.md` - Find files fast
4. Specific docs as needed (BACKEND.md, FRONTEND.md, etc.)

## Do NOT Burn Tokens On

- Crawling the entire codebase to understand structure
- Reading every file to find patterns
- Guessing at conventions

## Instead

- Use the `.ai/` documentation - it's comprehensive and maintained
- Check `FILE_MAP.md` to locate specific files
- Reference `API_REFERENCE.md` for endpoint details

## Tech Stack Quick Reference

| Layer | Technology |
|-------|------------|
| Backend | NestJS + Prisma + PostgreSQL |
| Frontend | Next.js 14 (App Router) + shadcn/ui |
| Auth | Clerk |
| Styling | TailwindCSS |

## Key Files

- `server/prisma/schema.prisma` - Database models
- `client/lib/api.ts` - All API functions
- `client/types/index.ts` - TypeScript types
- `server/src/app.module.ts` - Backend modules
