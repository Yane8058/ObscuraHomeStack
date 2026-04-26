# 🧰 ObscuraHomeStack
---

<img width="250" height="350" alt="ObscuraHomeStack_Logo" src="https://github.com/user-attachments/assets/fa80b8d9-b370-4150-a73a-d0369bce4cf9" />

Personal Linux HomeServer stack built on **Docker Compose** — self-hosted, monitored, and secure.

---

## 🚀 Key Features

- 🐳 Containerized services via **Docker Compose**
- 🔒 Security hardening — UFW, Fail2Ban, SSH keys, ClamAV
- 📊 Full monitoring — Prometheus, Grafana, Alertmanager (Telegram)
- 🌐 Remote access via **Tailscale** VPN — no port forwarding needed
- 🧩 Modular Design — Specific stacks (Gaming, Domotics, Media) in modules/
- 🕒 Automated backups and updates via cron jobs

---

## 🧩 Services

| Service | Description | Status |
|---|---|---|
| **Caddy** | Reverse Proxy | ✅ Active |
| **MariaDB** | Shared database engine | ✅ Active |
| **Nextcloud** | Self-hosted cloud storage | ✅ Active |
| **qBittorrent** | Torrent client | ✅ Active |
| **AdGuard Home** | DNS + ad blocking | ✅ Active |
| **Kavita** | eBook & manga reader | ✅ Active |
| **Navidrome** | Music streaming | ✅ Active |
| **Firefly III** | Personal finance tracker | ✅ Active |
| **Prometheus** | Metrics database | ✅ Active |
| **Grafana** | Metrics dashboard | ✅ Active |
| **Node Exporter** | System metrics | ✅ Active |
| **cAdvisor** | Container metrics | ✅ Active |
| **Alertmanager** | Telegram alert notifications | ✅ Active |

### 🧩 Modules

| Module | Description | Status |
|---|---|---|
| **Paperless Suite** | Document management + local AI (Ollama) | ✅ Available |
| **Jellyfin** | Media server | ✅ Available |
| **Domotic House** | HA + Mosquitto + Zigbee2mqtt | ✅ Available |
| **Minecraft Bedrock** | Game server (Xbox compatible) | ✅ Available |

---

## ⚙️ Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/Yane8058/ObscuraHomeStack.git
cd ObscuraHomeStack

# 2. Configure environment
cp .env.example .env
nano .env

# 3. Setup Caddy
cp Caddyfile.example Caddyfile

# 4. Run system preparation script
chmod +x sys_scripts/setup.sh
./sys_scripts/setup.sh

# 5. Start the core stack
docker compose up -d
```

For detailed setup instructions, service configuration, and troubleshooting see [DOCUMENTATION.md](DOCUMENTATION.md).

---

## 🗂️ Repository Structure

```
ObscuraHomeStack/
├── containers/                             # Service data and config files
│   ├── alert_rules.yml                     # Prometheus alerting rules
│   ├── alertmanager.yml                    # Alertmanager config (not versioned)
│   └── prometheus.yml                      # Prometheus config (not versioned)
│
├── modules/
│   ├── paperless_suite/                    # Paperless Suite module
│   │   ├── docker-compose-paperless.yml
│   │   ├── paperless-setup.sh              # Module setup script
│   │   └── README.md
│   │
│   ├── jellyfin/                           # Jellyfin module
│   │   ├── docker-compose-jellyfin.yml
│   │   ├── jellyfin-setup.sh               # Module setup script
│   │   └── README.md
│   │
│   ├── Domotic-House/                      # Home Assistant module
│   │   ├── docker-compose-domoHouse.yml
│   │   ├── domoHouse-setup.sh              # Module setup script
│   │   └── README.md
│   │
│   └── Gaming/                             # Gaming stack module
│       ├── docker-compose-gaming.yml
│       ├── gaming-setup.sh                 # Module setup script
│       └── README.md
│
├── logs/                                   # System and backup logs (not versioned)
│
├── py_scripts/
│   ├── firewall.py                         # Firewall config (not versioned)
│   └── requirements.txt
│
├── sys_scripts/
│   ├── setup.sh                            # Initial setup script
│   ├── update_system.sh                    # System and container update script
│   └── network_scanner.sh                  # Network scanner script
│
├── docker-compose.yml                      # Main stack
├── .env                                    # Local config (not versioned)
├── .env.example                            # Config template
├── .gitignore
├── Caddyfile.example                       # Proxy template for Tailscale/Local
├── cronjobs_template.txt
├── Documentation.md                        # Full service documentation
├── LICENSE
└── README.md
```

> ⚠️ Not versioned for security: `.env, Caddyfile, containers/alertmanager.yml, py_scripts/firewall.py`

---

## 📄 License

MIT License — open source, use freely.

💬 Issues and pull requests are welcome! 💻
