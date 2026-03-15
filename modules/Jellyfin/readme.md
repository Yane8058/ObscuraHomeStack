# 🎬 Jellyfin Module

> Part of [ObscuraHomeStack](https://github.com/Yane8058/ObscuraHomeStack) — Personal Linux HomeServer stack built on Docker Compose.

---

## 📖 Overview

**Jellyfin** is a free and open-source media server that lets you manage and stream your personal collection of movies, TV shows, and music from anywhere — no subscriptions, no tracking, fully self-hosted.

This module integrates Jellyfin into the ObscuraHomeStack ecosystem, sharing the same network (`obscura_net`), environment variables, and folder structure conventions used across the entire stack.

---

## 🗂️ Module Structure

```
modules/
└── jellyfin/
    ├── docker-compose-jellyfin.yml   # Jellyfin service definition
    ├── jellyfin-setup.sh             # Environment setup script
    └── README.md                     # This file

containers/
└── jellyfin/
    ├── library/                      # Jellyfin config, database & metadata
    ├── tvshows/                      # TV show media files
    └── movies/                       # Movie media files
```

---

## ⚙️ Prerequisites

- ObscuraHomeStack base stack up and running
- `obscura_net` Docker network already created
- `.env` file configured with the required variables (see below)

---

## 🔧 Environment Variables

Add the following variables to your root `.env` file:

```env
# Jellyfin
BASE_PATH=/home/$USER/ObscuraHomeStack/containers
PORT_JELLYFIN=<port>
JELLYFIN_URL=https://jellyfin.yourdomain.com   # optional, only if behind reverse proxy
```

> `PUID`, `PGID`, and `TZ` are already defined in the main `.env` and are shared across all modules.

---

## 🚀 Quick Start

### 1. Run the setup script

```bash
chmod +x modules/jellyfin/jellyfin-setup.sh
./modules/jellyfin/jellyfin-setup.sh
```

This will create the required directory structure under `containers/jellyfin/`.

### 2. Start the container

```bash
docker compose -f modules/jellyfin/docker-compose-jellyfin.yml up -d
```

### 3. Access the Web UI

```
http://<your-server-ip>:<port>
```

On first launch, Jellyfin will guide you through the initial setup wizard — create an admin account and add your media libraries pointing to `/media/movies` and `/media/tvshows`.


---

## 📡 Ports

| Port | Protocol | Description |
|------|----------|-------------|
| `<.env-port>` | TCP | Web UI (main access) |
| `8920` | TCP | HTTPS — optional, only if not using a reverse proxy |
| `7359` | UDP | Client auto-discovery on LAN — optional |
| `1900` | UDP | DLNA discovery — optional |

> If you access Jellyfin via Tailscale or a reverse proxy, ports `8920`, `7359`, and `1900` can be safely removed.

---

## 📁 Adding Media

Place your media files directly on the host:

```
containers/jellyfin/
├── movies/
│   ├── Inception (2010)/
│   │   └── Inception (2010).mkv
│   └── ...
└── tvshows/
    ├── Breaking Bad/
    │   ├── Season 01/
    │   └── ...
    └── ...
```

> Jellyfin works best when media is organized following the [Jellyfin naming conventions](https://jellyfin.org/docs/general/server/media/movies).

---

## 🔒 Security Notes

- Jellyfin is accessible only within the `obscura_net` Docker network and on the configured port.
- For remote access, it is recommended to use **Tailscale** (already part of ObscuraHomeStack) rather than exposing the port publicly.
- If a reverse proxy (e.g. Nginx Proxy Manager) is in use, set `JELLYFIN_URL` accordingly and disable the optional ports.

---

## 🔗 Related

- [ObscuraHomeStack Main README](https://github.com/Yane8058/ObscuraHomeStack)
- [ObscuraHomeStack Documentation](https://github.com/Yane8058/ObscuraHomeStack/blob/main/Documentation.md)
- [Jellyfin Official Docs](https://jellyfin.org/docs/)
- [LinuxServer.io Jellyfin Image](https://docs.linuxserver.io/images/docker-jellyfin/)

---

*Part of ObscuraHomeStack — MIT License*