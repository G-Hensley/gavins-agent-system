---
paths:
  - "**/Dockerfile*"
  - "**/docker-compose*"
  - "**/.dockerignore"
---

# Docker Standards

## Dockerfile
- Use multi-stage builds to minimize final image size
- Run as non-root user: add `USER` directive before `CMD`/`ENTRYPOINT`
- Set `HEALTHCHECK` for production containers
- Order layers for cache efficiency: deps first, source code last
- Pin base image versions: `node:20-alpine`, not `node:latest`
- Use `COPY` over `ADD` unless extracting archives

## .dockerignore
- Always include a `.dockerignore` alongside the Dockerfile
- Exclude: `node_modules`, `.git`, `.env`, `*.md`, test files, build artifacts
- Keep build context small for faster builds

## docker-compose
- Use named volumes for persistent data
- Set `restart: unless-stopped` for production services
- Define health checks for service dependencies
- Use environment variable files (`.env`) for config, never hardcoded values
- Pin image versions -- no `latest` tags in compose files

## Security
- Never store secrets in the image -- use runtime env vars or mounted secrets
- Scan images for vulnerabilities before deploying
- Minimize installed packages -- no editors, curl, or debug tools in production images
