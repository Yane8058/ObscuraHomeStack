# 🧰 ObscuraHomeStack Setup
<img width="400" height="400" alt="ObscuraHomeStack_Logo" src="https://github.com/user-attachments/assets/fa80b8d9-b370-4150-a73a-d0369bce4cf9" />

Welcome to my personal repository for setting up and managing a **Linux-based HomeServer**.

This project provides everything needed to build a fully automated, secure, and monitored system using **Docker Compose**.

---

## 🚀 Key Features

* 🐳 Automated deployment of containerized services with **Docker Compose**
* 🕒 Automated backups and system updates via **cron jobs**
* 🔒 Advanced security (UFW, Fail2Ban, SSH hardening)
* 📊 Complete monitoring with **Prometheus, Grafana, cAdvisor, Alertmanager**
* ☁️ Self-hosted cloud storage with **Nextcloud**
* 🎮 **Minecraft Bedrock** server (Xbox compatible)
* 📡 Ad blocking and DNS management with **AdGuard Home**
* 🤖 Smart home automation with **Home Assistant**
* 🧲 Torrent client with **qBittorrent**
* 📚 eBook reader with **Kavita**
* 🎵 Self-hosted music streaming with **Navidrome**
* 💰 Family expense tracker with **Actual Budget**
* 🌐 **Tailscale VPN** for secure remote access and Mesh networking

---

## 🗂️ Repository Structure

```
ObscuraHomeStack/
├── containers/
│   ├── alert_rules.yml                 # Alerting rules for Prometheus
│   ├── alertmanager.yml                # Alertmanager config (local only, not versioned)
│   └── prometheus.yml                  # Prometheus config (local only, not versioned)
│
├── logs/                               # System and backup logs (not versioned)
│
├── py_scripts/
│   ├── firewall.py                     # UFW firewall configuration (local only, not versioned)
│   └── requirements.txt                # Python dependencies
│
├── sys_scripts/
│   ├── setup.sh                        # Initial setup script
│   ├── update_system.sh                # System and container update script
│   └── network_scanner.sh              # Network scanner script
│
├── docker-compose.yml                  # All services configuration
├── .env                                # Environment variables (local only, not versioned)
├── .env.example                        # Environment variables template
├── .gitignore
├── cronjobs_template.txt               # Example cron configuration
├── LICENSE
└── README.md
```

> ⚠️ Files not versioned for security: `.env`, `containers/alertmanager.yml`, `py_scripts/firewall.py`

---

## 🧩 Included Services

| Service | Description | Port(s) | Status |
| --- | --- | --- | --- |
| **Tailscale** | Mesh VPN | N/A | ✅ Active |
| **MariaDB** | Database for Nextcloud | 3306 | ✅ Active |
| **Nextcloud** | Self-hosted cloud and file sharing | 80, 8443 | ✅ Active |
| **Minecraft Bedrock** | Minecraft server (Xbox compatible) | 19132/udp | ✅ Active |
| **qBittorrent** | Torrent client with Web UI | 8080 | ✅ Active |
| **AdGuard Home** | DNS and ad blocking | 5353, 3000, 8081, 853 | ✅ Active |
| **Node Exporter** | System metrics exporter | 9100 | ✅ Active |
| **cAdvisor** | Docker container metrics | 8082 | ✅ Active |
| **Prometheus** | Time-series metrics database | 9090 | ✅ Active |
| **Alertmanager** | Telegram alert notifications | 9093 | ✅ Active |
| **Grafana** | Metrics visualization dashboard | 3001 | ✅ Active |
| **Mosquitto** | MQTT broker for Home Assistant | 1883 | ✅ Active |
| **Zigbee2MQTT** | Zigbee device bridge | 8083 | ✅ Active |
| **Home Assistant** | Smart home automation | 8123 | ✅ Active |
| **Kavita** | eBook and manga reader | 5000 | ✅ Active |
| **Navidrome** | Self-hosted music streaming | 4533 | ✅ Active |
| **Actual Budget** | Family expense tracker | 5006 | ✅ Active |

---

## ⚙️ Initial Setup

### 1. Clone the repository

```bash
git clone https://github.com/Yane8058/ObscuraHomeStack.git
cd ObscuraHomeStack
```

### 2. Configure environment variables

Copy the example file and fill in your values:

```bash
cp .env.example .env
nano .env
```

Key variables to set:
- `BASE_PATH` — absolute path to your containers folder (e.g. `/home/youruser/ObscuraHomeStack/containers`)
- `MYSQL_ROOT_PASSWORD`, `MYSQL_PASSWORD` — choose secure passwords
- `PUID`, `PGID` — your user ID (run `id` to check)
- `TZ` — your timezone (e.g. `Europe/Rome`)
- All `PORT_*` variables — change only if you have conflicts

### 3. Run the setup script

The setup script installs all required packages, creates the folder structure, configures the firewall and activates system services:

```bash
chmod +x sys_scripts/setup.sh
./sys_scripts/setup.sh
```

> ⚠️ The script expects `py_scripts/firewall.py` and `py_scripts/requirements.txt` to be present locally (not versioned on GitHub).

### 4. Install Tailscale (VPN)

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --advertise-exit-node
```

To ensure the server doesn't disconnect from the VPN, go to the **Tailscale Admin Console** → Machines → [Your Server] → Three dots → **Disable Key Expiry**.

### 5. Start all containers

```bash
docker-compose up -d
```

### 6. Verify all containers are running

```bash
docker-compose ps
```

---

## 🗄️ Database

All services share a **single MariaDB container**. Each service has its own dedicated database inside it — no need for multiple database containers.

To create a new database for an additional service:

```bash
docker exec -it mariadb mariadb -u root -p
```

```sql
CREATE DATABASE newservice CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'newuser'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON newservice.* TO 'newuser'@'%';
FLUSH PRIVILEGES;
```

---

## 💰 Actual Budget Setup

Actual Budget is a self-hosted family expense tracker with a clean web UI. It uses **SQLite** internally — no database configuration needed.

1. Access the web UI at `http://homeserver:5006`
2. Create a budget file and set a password on first login
3. Add expenses manually or import via CSV
4. Organize by categories to track family spending

> **Mobile access:** Use any browser on your phone at `http://homeserver_ip:5006`. An unofficial companion app is also available for Android/iOS.

---

## 🎵 Navidrome Setup

1. Make sure your music library is available at `/mnt/music` on the host (or update `BASE_PATH` in `.env`)
2. Access the web UI at `http://homeserver:4533`
3. Create your admin account on first login
4. Navidrome will automatically scan the music library every hour
5. Connect from mobile using any Subsonic-compatible app (e.g. **Symfonium**, **Tempo**, **Feishin**)

> **Tip:** Make sure your music files have correct ID3/metadata tags. Use **MusicBrainz Picard** to clean them up automatically.

---

## 🌐 Remote Access & VPN

The HomeServer uses **Tailscale** to provide secure remote access without opening ports on the router:

* **Mesh VPN** — Encrypted point-to-point connections between all devices
* **MagicDNS** — Access services using hostnames (e.g. `http://homeserver:8123`) instead of IP addresses
* **Subnet Router** — Access the entire home network (`192.168.1.x`) from anywhere
* **Exit Node** — Route all internet traffic through the HomeServer when on public Wi-Fi

**Access:** Connect via the Tailscale IP (`100.x.y.z`) or assigned hostname.

---

## 📊 Monitoring Stack

* **Prometheus** — Collects and stores metrics from system and containers
* **Node Exporter** — System metrics (CPU, memory, disk, network)
* **cAdvisor** — Container metrics
* **Grafana** — Visualizes all metrics with customizable dashboards
* **Alertmanager** — Sends alerts via Telegram

---

## 🔒 Security

* **Tailscale Isolation** — No port forwarding needed, reduces attack surface
* **SSH Key-based Authentication** — Key-only, no password login
* **UFW Firewall** — Configured via `py_scripts/firewall.py`
* **Fail2Ban** — Intrusion prevention
* **ClamAV** — Antivirus with automatic database updates

---

## 📝 Common Commands

```bash
# View running containers
docker-compose ps

# View logs for a specific service
docker-compose logs -f nextcloud

# Restart a single service
docker-compose restart actual_server

# Stop all containers
docker-compose down

# Pull latest images and restart
docker-compose pull && docker-compose up -d

# Check Tailscale status
tailscale status
tailscale ip -4
```

---

## 🕒 Cron Jobs

See `cronjobs_template.txt` for example scheduling. Key jobs:

- System update every Saturday at 5:00
- Network scan every hour

---

## 📄 License

This project is open source and available under the MIT License.

---

## 💬 Feedback

For suggestions, improvements, or issues, feel free to open an issue or submit a pull request!

Happy homelabing! 🚀