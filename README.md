# Deployment 🚀

This directory contains configuration for deploying the Pet Platform using Docker.

## Docker Compose Files

-   **`docker-compose.dev.yml`**: Development configuration.
    -   Mounts source code as volumes for hot-reloading (backend & frontend).
    -   Exposes ports for all services (Postgres: 5432, Redis: 6379, Minio: 9000/9001).
    -   Runs frontend in dev mode (`vite`).

-   **`docker-compose.prod.yml`**: Production configuration (planned).
    -   Uses built images.
    -   Optimized for performance and security.
    -   Does not expose database ports publicly.

## Services

| Service | Image | Description | Port |
| :--- | :--- | :--- | :--- |
| `backend` | `python:3.11-slim` | FastAPI application server. | 8000 |
| `frontend` | `node:18-alpine` | React application (dev server). | 5173 |
| `postgres` | `postgres:16-alpine` | Main relational database. | 5432 |
| `redis` | `redis:7-alpine` | Caching and task queue. | 6379 |
| `minio` | `minio/minio` | Object storage for images. | 9000 (API), 9001 (Console) |
| `filebrowser` | `filebrowser/filebrowser` | Web-based file manager (Dev only). | 8080 |

## Database Scripts

The `scripts/` directory is intended for SQL scripts, seed data, or migration helpers.
Currently, it contains a placeholder README. Use this location to store any manual database initialization scripts.

## Troubleshooting

### Port Conflicts
If you encounter port conflicts (e.g., port 5432 is already in use), stop your local Postgres service or modify the port mapping in `docker-compose.dev.yml`.

### Minio Access
-   **Console**: [http://localhost:9001](http://localhost:9001)
-   **Credentials**: Default user/password are typically `minioadmin` / `minioadmin` (check `docker-compose.dev.yml` to confirm).

### Resetting Data
To reset the database and storage:
```bash
docker compose -f docker-compose.dev.yml down -v
```
This will remove the named volumes (`pg_data`, `minio_data`, `redis_data`).
