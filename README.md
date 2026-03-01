# 🧰 ObscuraHomeStack Setup
<img width="250" height="350" alt="ObscuraHomeStack_Logo" src="https://github.com/user-attachments/assets/fa80b8d9-b370-4150-a73a-d0369bce4cf9" />

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
* 💰 Personal expense tracker with **Firefly III**
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

| Service | Description | Status |
| --- | --- | --- |
| **Tailscale** | Mesh VPN | ✅ Active |
| **MariaDB** | Shared database for all services that require one | ✅ Active |
| **Nextcloud** | Self-hosted cloud and file sharing | ✅ Active |
| **Minecraft Bedrock** | Minecraft server (Xbox compatible) | ✅ Active |
| **qBittorrent** | Torrent client with Web UI | ✅ Active |
| **AdGuard Home** | DNS and ad blocking | ✅ Active |
| **Node Exporter** | System metrics exporter | ✅ Active |
| **cAdvisor** | Docker container metrics | ✅ Active |
| **Prometheus** | Time-series metrics database | ✅ Active |
| **Alertmanager** | Telegram alert notifications | ✅ Active |
| **Grafana** | Metrics visualization dashboard | ✅ Active |
| **Mosquitto** | MQTT broker for Home Assistant | ✅ Active |
| **Zigbee2MQTT** | Zigbee device bridge | ✅ Active |
| **Home Assistant** | Smart home automation | ✅ Active |
| **Kavita** | eBook and manga reader | ✅ Active |
| **Navidrome** | Self-hosted music streaming | ✅ Active |
| **Firefly III** | Personal expense tracker | ✅ Active |

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

## 🗄️ Database — MariaDB (Shared)

All services that require a relational database share a **single MariaDB container**. This means only one database engine runs on the system, and each service gets its own isolated database inside it — keeping resource usage low and management simple.

**Services using MariaDB:**
- **Nextcloud** — file sharing and cloud storage
- **Firefly III** — personal expense tracker

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

> ⚠️ Never use the `root` user for application access. Always create a dedicated user per service as shown above.

---

## 💰 Firefly III Setup

Firefly III is a self-hosted personal finance manager that connects to the shared **MariaDB** instance. Before starting the container, make sure the `firefly` database and its dedicated user exist in MariaDB (see the section above).

1. Make sure your `.env` has `APP_KEY` set — this is a 32-character random string used to encrypt sensitive data. Generate one with:

```bash
echo "base64:$(openssl rand -base64 32)"
```

2. Access the web UI at `http://homeserver:PORT_FIREFLY` (default port defined in `.env`)
3. Create your admin account on first login
4. Add accounts (bank, cash, credit card) and start logging transactions
5. Use budgets, categories and tags to organize your expenses

> **Mobile access:** Firefly III has an official companion app available for Android and iOS that connects to your self-hosted instance via the API.

---

## 🎵 Navidrome Setup

1. Make sure your music library is available at `/mnt/music` on the host (or update the volume path in `docker-compose.yml`)
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

## 🔑 SSH Key Setup

SSH key-based authentication is required to access the server — password login is disabled for security.

### 1. Generate the key pair (on your local machine)

**Linux / macOS:**
```bash
ssh-keygen -t ed25519 -C "your_comment"
```

**Windows (PowerShell):**
```powershell
ssh-keygen -t ed25519 -C "your_comment"
```

When prompted:
- **Path** — press Enter to use the default (`~/.ssh/id_ed25519`) or specify a custom path
- **Passphrase** — recommended, adds an extra layer of protection if the private key is ever stolen

This generates two files:
- `~/.ssh/id_ed25519` — **private key** (never share this)
- `~/.ssh/id_ed25519.pub` — **public key** (this goes on the server)

### 2. Copy the public key to the server

**Linux / macOS:**
```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@homeserver_ip
```

**Windows (manual method):**
```powershell
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh user@homeserver_ip "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### 3. Verify the connection

```bash
ssh -i ~/.ssh/id_ed25519 user@homeserver_ip
```

If it connects without asking for a password (or only asks for the key passphrase), the setup is correct.

### 4. Disable password login on the server

Once you've verified key access works, disable password authentication to harden the server:

```bash
sudo nano /etc/ssh/sshd_config
```

Set or confirm these values:
```
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
```

Then restart SSH:
```bash
sudo systemctl restart ssh
```

> ⚠️ Make sure your key works **before** disabling password login, or you risk locking yourself out.

### 5. Optional — Simplify connections with SSH config

Add this to `~/.ssh/config` on your local machine to connect with just `ssh homeserver`:

```
Host homeserver
    HostName 100.x.y.z        # Tailscale IP or local IP
    User yourusername
    IdentityFile ~/.ssh/id_ed25519
```

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
docker-compose restart firefly_iii

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

## 🚀 Future Implementation

- Jellyfin software media system self-hosted
- Paperless-ngx for documents digitalization and storage

---

## 📄 License

This project is open source and available under the MIT License.

---

## 💬 Feedback

For suggestions, improvements, or issues, feel free to open an issue or submit a pull request!

Happy homelabing! 💻
