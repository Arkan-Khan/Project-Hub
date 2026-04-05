# Project Hub - AI Agent Documentation

This folder contains documentation for AI coding assistants (GitHub Copilot, Cursor, Claude, etc.) to quickly understand the codebase without extensive exploration.

## Quick Links

- [Project Overview](./PROJECT_OVERVIEW.md) - Architecture, tech stack, and high-level structure
- [Frontend Guide](./FRONTEND.md) - React/Next.js components, pages, and state management
- [Backend Guide](./BACKEND.md) - NestJS modules, controllers, services, and Prisma schema
- [API Reference](./API_REFERENCE.md) - All API endpoints with request/response formats
- [File Map](./FILE_MAP.md) - Key file locations for common tasks

## Project Summary

**Project Hub** is a multi-role academic project management system for managing student projects, mentor allocations, and review processes.

### Roles
- **Student**: Form groups, submit topics, participate in reviews, upload attachments
- **Faculty/Mentor**: Accept/reject allocations, approve topics, provide review feedback
- **Superadmin**: Manage mentor allocation, rollout reviews, view analytics

### Tech Stack
- **Frontend**: Next.js 14, TypeScript, Tailwind CSS, shadcn/ui
- **Backend**: NestJS, Prisma ORM, PostgreSQL (Supabase)
- **Auth**: Supabase Auth with JWT
- **File Storage**: Supabase Storage (5MB limit)

### Key Directories
```
Project-Hub/
├── client/           # Next.js frontend
│   ├── app/          # App router pages
│   ├── components/   # React components
│   ├── lib/          # Utilities, API client
│   └── types/        # TypeScript definitions
├── server/           # NestJS backend
│   ├── src/          # Source modules
│   └── prisma/       # Database schema
└── .ai/              # This documentation
```
