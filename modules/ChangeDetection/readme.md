# 🔍 ChangeDetection Module
---

Self-hosted website change monitoring stack based on **changedetection.io**, paired with a headless **Sockpuppet/Playwright** browser for JS-rendered pages. Tracks URL changes over time and can feed history data into Grafana.

---

## 🚀 Key Features

- 🌐 Monitors any URL for content changes, with visual diff and notifications
- 🎭 Headless browser rendering via **Sockpuppet Browser** (Playwright-based) for JS-heavy sites
- 📊 Change history can be mounted/visualized on Grafana
- 📦 Persistent datastore volume — no data loss on container restarts
- ♻️ Resource-limited containers (CPU/RAM caps) to protect the host
- ❤️ Built-in healthchecks for both containers

---

## 🧩 Services

| Service | Description | Status |
|---|---|---|
| **changedetection** | Web UI + change detection engine | ✅ Active |
| **playwright-chrome** | Headless browser (Sockpuppet) for JS rendering | ✅ Active |

---

## ⚙️ Environment Variables

| Variable | Description |
|---|---|
| `CH_DET_EXT` | External (host) port mapped to the changedetection Web UI |
| `CH_DET_INT` | Internal container port used by changedetection |
| `healthcheck_playwright` | Port used by Playwright/Sockpuppet for the WebSocket driver and healthcheck |
| `TZ` | Timezone applied to both containers |

> ⚠️ Not versioned for security: module `.env` file (define the variables above before starting the stack)

---

## ⚙️ Quick Start

```bash
# 1. Move into the module folder
cd modules/ChangeDetection

# 2. Configure environment
cp .env.example .env
nano .env

# 3. Run module setup script (if present)
chmod +x changedetection-setup.sh
./changedetection-setup.sh

# 4. Start the module stack
docker compose -f docker-compose-changedetection.yml up -d
```

---

## 📌 Notes

- Both containers join the shared external network `obscura_net` — make sure it exists before starting the module (`docker network create obscura_net` if needed)
- `playwright-chrome` must be healthy before `changedetection` can use JS-rendering checks (handled via `depends_on`)
- Data (watch list, history, screenshots) is persisted in the `changedetection-data` named volume
- Resource limits are tuned for a home-lab environment; adjust `deploy.resources` if the host has more headroom