# 📄 Paperless Suite

> Module for [ObscuraHomeStack](../../README.md) — Location: `modules/paperless_suite/`

Self-hosted document management system with fully local AI processing.
Automatically tags, titles, and classifies documents using a local LLM via Ollama — no cloud services involved.

---

## Overview

The Paperless Suite combines three tools on top of [paperless-ngx](https://github.com/paperless-ngx/paperless-ngx):

| Tool | Purpose |
|---|---|
| **paperless-ngx** | Core DMS — stores, indexes and searches documents |
| **paperless-ai** | Automatically assigns tags, title and correspondent via LLM |
| **paperless-gpt** | Advanced OCR re-processing and manual review UI |
| **Ollama** | Local LLM engine — runs the AI models on your hardware |

All AI processing happens **locally**. No data leaves your machine.

---

## Services

| Container | Role |
|---|---|---|
| `paperless` | Core DMS (paperless-ngx) |
| `paperless_redis` | Internal message broker |
| `paperless_gotenberg` | Office / HTML → PDF conversion |
| `paperless_tika` | Office / Email document parsing |
| `paperless_ollama` | Local LLM engine (Ollama) |
| `paperless_ollama_init` | One-shot model pull on first boot |
| `paperless_ai` | Automatic metadata tagging |
| `paperless_gpt` | Advanced OCR + manual review UI |

---

## Prerequisites

Before starting this module the **main stack must already be running**:

- `obscura_net` Docker network active
- `mariadb` container running and healthy

### Create the dedicated database

Paperless uses its own database and credentials — do **not** reuse the Nextcloud ones.
Run this once before the first boot:

```bash
docker exec -it mariadb mariadb -uroot -p -e \
  "CREATE DATABASE paperless CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE USER 'paperless'@'%' IDENTIFIED BY 'your_db_password';
   GRANT ALL PRIVILEGES ON paperless.* TO 'paperless'@'%';
   FLUSH PRIVILEGES;"
```

> The password must match `PAPERLESS_DB_PASSWORD` in your root `.env`.

---

## Setup

### 1. Configure environment variables

Add the `MODULE: Paperless Suite` section from `modules/paperless/.env.example`
to your root `ObscuraHomeStack/.env` and fill in all required values.

| Variable | Description |
|---|---|
| `PAPERLESS_SECRET_KEY` | Random string, **minimum 50 characters** |
| `PAPERLESS_URL` | Reachable URL — use `LOCAL_IP`, not `localhost` |
| `PAPERLESS_DB_PASSWORD` | Must match the password created above |
| `PAPERLESS_ADMIN_PASSWORD` | Password for the paperless-ngx web UI |

> ⚠️ Never use inline comments on the same line as a variable value in `.env` files.
> They are treated as part of the value and will corrupt it silently.

### 2. Start the module

All commands run from the **repo root**:

```bash
docker compose -f docker-compose.yml -f modules/paperless/docker-compose.yml up -d
```

On first boot, `paperless_ollama_init` automatically pulls the configured model (~2 GB for `llama3.2:3b`). Monitor the download:

```bash
docker logs -f paperless_ollama_init
```

### 3. Configure the API token

The AI containers need a Paperless API token to communicate with paperless-ngx.
After the first boot:

1. Open `http://<LOCAL_IP>:8010`
2. Log in and go to **Admin → Profile → API Token**
3. Copy the token and add it to your root `.env`:
   ```
   PAPERLESS_API_TOKEN=your_token_here
   ```
4. Restart the AI containers:
   ```bash
   docker compose -f docker-compose.yml \
     -f modules/paperless/docker-compose.yml \
     restart paperless_ai paperless_gpt
   ```

### 4. Harden the admin account

After completing the initial setup, comment out the admin bootstrap variables
in your root `.env` to prevent them from being reapplied on restart:

```bash
# PAPERLESS_ADMIN_USER
# PAPERLESS_ADMIN_PASSWORD
# PAPERLESS_ADMIN_EMAIL
```

Then restart paperless:

```bash
docker compose -f docker-compose.yml \
  -f modules/paperless/docker-compose.yml \
  restart paperless
```

---

## Document flow

```
${BASE_PATH}/paperless/consume/      ← drop documents here
              │
              ▼
        paperless-ngx
        (Tesseract OCR)
              │
              ├──▶ paperless-ai
              │    Automatically assigns tags, title, and
              │    correspondent using llama3.2:3b
              │
              └──▶ paperless-gpt  (tag-driven, optional)
                     │
                     ├─ tag: paperless-gpt          → manual review queue at :8012
                     ├─ tag: paperless-gpt-auto      → fully automatic processing
                     └─ tag: paperless-gpt-ocr-auto  → re-OCR the document with LLM
```

---

## AI model capabilities

| Feature | Model | Status |
|---|---|---|
| Auto-tagging and metadata | `llama3.2:3b` | ✅ |
| Title and correspondent suggestion | `llama3.2:3b` | ✅ |
| Vision OCR (scanned images) | `minicpm-v` | ✅ if `OLLAMA_VISION_MODEL` is set |

> `llama3.2:3b` is a **text-only** model. Vision OCR requires a multimodal model.
> Set `OLLAMA_VISION_MODEL=minicpm-v` in your `.env` to enable it — the model (~3 GB)
> must be pulled separately:
> ```bash
> docker exec paperless_ollama ollama pull minicpm-v
> ```

---

## Common commands

All commands run from the **repo root**.

```bash
# Start main stack + paperless module
docker compose -f docker-compose.yml -f modules/paperless/docker-compose.yml up -d

# Stop paperless module only
docker compose -f modules/paperless/docker-compose.yml down

# Live logs (all paperless containers)
docker compose -f modules/paperless/docker-compose.yml logs -f

# Live logs (single container)
docker logs -f paperless
docker logs -f paperless_ai
docker logs -f paperless_gpt

# Update all images
docker compose -f docker-compose.yml -f modules/paperless/docker-compose.yml pull
docker compose -f docker-compose.yml -f modules/paperless/docker-compose.yml up -d

# Export / backup all documents
docker exec paperless document_exporter ../export

# List installed Ollama models
docker exec paperless_ollama ollama list

# Pull an additional Ollama model manually
docker exec paperless_ollama ollama pull <model_name>
```

---

## Data layout

All persistent data is stored under `${BASE_PATH}/paperless/`:

```
${BASE_PATH}/paperless/
├── data/               ← paperless-ngx index and internal configuration
├── media/              ← archived documents (originals + thumbnails)
├── consume/            ← document inbox — drop files here to import
├── export/             ← output directory for document exports and backups
├── redis/              ← Redis broker data
├── ollama/             ← downloaded model weights (can grow significantly)
├── paperless-ai/       ← paperless-ai configuration and processing state
└── paperless-gpt/
    └── prompts/        ← optional custom LLM prompts
```

---

## Troubleshooting

**paperless-ai / paperless-gpt can't connect to paperless**
Make sure `PAPERLESS_URL` is set to your LAN IP, not `localhost`. Inside a container, `localhost` resolves to the container itself, not the host.

**Ollama model not found**
Check that `paperless_ollama_init` completed successfully:
```bash
docker logs paperless_ollama_init
docker exec paperless_ollama ollama list
```

**Documents not being consumed**
Verify the consume folder path and permissions:
```bash
ls -la ${BASE_PATH}/paperless/consume/
```
The folder must be writable by `PUID:PGID`.

**MariaDB connection refused**
Confirm the `mariadb` container is running and healthy, and that the `paperless` database and user were created correctly before starting the module.