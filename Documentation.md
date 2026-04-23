# 📚 ObscuraHomeStack — Documentation

Complete reference for all services and modules in the stack.

---

## Table of Contents

- [Initial Setup](#initial-setup)
- [Database — MariaDB](#database--mariadb)
- [Nextcloud](#nextcloud)
- [Firefly III](#firefly-iii)
- [Navidrome](#navidrome)
- [qBittorrent](#qbittorrent)
- [AdGuard Home](#adguard-home)
- [Home Assistant](#home-assistant)
- [Mosquitto](#mosquitto)
- [Zigbee2MQTT](#zigbee2mqtt)
- [Kavita](#kavita)
- [Minecraft Bedrock](#minecraft-bedrock)
- [Monitoring Stack](#monitoring-stack)
- [Remote Access — Tailscale](#remote-access--tailscale)
- [SSH Hardening](#ssh-hardening)
- [Security](#security)
- [Cron Jobs](#cron-jobs)
- [Module — Paperless Suite](#module--paperless-suite)
- [Module — Jellyfin](#module--jellyfin)

---

## Initial Setup

### 1. Clone and configure

```bash
git clone https://github.com/Yane8058/ObscuraHomeStack.git
cd ObscuraHomeStack
cp .env.example .env
nano .env
```

Key variables to set:

| Variable | Description |
|---|---|
| `BASE_PATH` | Absolute path to your containers folder |
| `PUID` / `PGID` | Your user ID — run `id` to check |
| `TZ` | Your timezone (e.g. `Europe/Rome`) |
| `MYSQL_ROOT_PASSWORD` | Strong root password for MariaDB |
| `LOCAL_IP` | Your server's LAN IP |

### 2. Run the setup script

```bash
chmod +x sys_scripts/setup.sh
./sys_scripts/setup.sh
```

Installs required packages, creates folder structure, configures UFW firewall and system services.

> ⚠️ Requires `py_scripts/firewall.py` and `py_scripts/requirements.txt` to be present locally (not versioned).

### 3. Start the stack

```bash
docker compose up -d
docker compose ps   # verify all containers are running
```

---

## Database — MariaDB

A single MariaDB instance shared across all services that need a relational database. Each service gets its own isolated database inside it.

**Services using MariaDB:** Nextcloud, Firefly III, Paperless Suite

### Create a database for a new service

```bash
docker exec -it mariadb mariadb -u root -p
```

```sql
CREATE DATABASE newservice CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'newuser'@'%' IDENTIFIED BY 'strong_password';
GRANT ALL PRIVILEGES ON newservice.* TO 'newuser'@'%';
FLUSH PRIVILEGES;
```

> ⚠️ Always create a dedicated user per service. Never use the `root` user for application access.

📖 [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)

---

## Nextcloud

Self-hosted cloud storage and file sharing.

### First boot

1. Access `https://<LOCAL_IP>:8443`
2. Create the admin account
3. Set the database connection to MariaDB (already configured via `.env`)

### Useful commands

```bash
# Run occ commands inside the container
docker exec -u www-data nextcloud php occ <command>

# Trigger a file rescan
docker exec -u www-data nextcloud php occ files:scan --all

# Check background jobs status
docker exec -u www-data nextcloud php occ background:cron
```

📖 [Nextcloud Documentation](https://docs.nextcloud.com)
📖 [linuxserver/nextcloud image](https://docs.linuxserver.io/images/docker-nextcloud/)

---

## Firefly III

Personal finance and expense tracker.

### First boot

1. Generate the `APP_KEY`:
   ```bash
   echo "base64:$(openssl rand -base64 32)"
   ```
2. Set it in `.env` as `APP_KEY`
3. Create the `firefly` database in MariaDB (see [Database section](#database--mariadb))
4. Access `http://<LOCAL_IP>:8085` and create the admin account

### Tips

- Add bank, cash, and credit card accounts first
- Use **budgets** for monthly spending limits
- Use **categories** and **tags** for detailed tracking
- The official mobile app (Android/iOS) connects via API for on-the-go transactions

📖 [Firefly III Documentation](https://docs.firefly-iii.org)
📖 [Firefly III API](https://api-docs.firefly-iii.org)

---

## Navidrome

Self-hosted music streaming server, Subsonic-compatible.

### Setup

1. Mount your music library at `/mnt/music` on the host (or update the volume in `docker-compose.yml`)
2. Access `http://<LOCAL_IP>:4533`
3. Create the admin account on first login
4. Library is automatically scanned every hour (`ND_SCANSCHEDULE=1h`)

### Recommended mobile clients

- **Symfonium** (Android) — best overall
- **Tempo** (iOS)
- **Feishin** (desktop, web)

> **Tip:** Use [MusicBrainz Picard](https://picard.musicbrainz.org/) to fix metadata tags before importing.

📖 [Navidrome Documentation](https://www.navidrome.org/docs/)
📖 [Subsonic API](http://www.subsonic.org/pages/api.jsp)

---

## qBittorrent

Web-based torrent client.

### First boot

1. Access `http://<LOCAL_IP>:8080`
2. Default credentials: `admin` / `adminadmin` — **change immediately**
3. Set the download path to `/downloads` inside the container

### Tips

- Enable the built-in search engine under **Tools → Search Plugins**
- Configure a VPN or bind to a specific interface for privacy
- Set speed limits under **Tools → Options → Speed**

📖 [qBittorrent Documentation](https://github.com/qbittorrent/qBittorrent/wiki)
📖 [linuxserver/qbittorrent image](https://docs.linuxserver.io/images/docker-qbittorrent/)

---

## AdGuard Home

DNS-level ad blocking and network-wide privacy.

### First boot

1. Access `http://<LOCAL_IP>:3000` for the initial setup wizard
2. After setup, the main UI is at `http://<LOCAL_IP>:8081`
3. Point your router's DNS to the server's LAN IP to enable network-wide blocking

### Recommended blocklists

- AdGuard DNS Filter
- OISD Blocklist (full)
- Steven Black Hosts

### DNS-over-TLS

AdGuard Home is configured to listen on port `853` for DoT. Configure clients to use `tls://<LOCAL_IP>` for encrypted DNS.

📖 [AdGuard Home Documentation](https://github.com/AdguardTeam/AdGuardHome/wiki)

---

## Kavita

eBook, manga, and comic reader.

### Setup

1. Access `http://<LOCAL_IP>:5000`
2. Create the admin account on first login
3. Add libraries pointing to your `/books` volume
4. Kavita supports EPUB, PDF, CBZ, CBR formats

### Mobile access

Use the **Kavita** official app or any OPDS-compatible reader.

📖 [Kavita Documentation](https://wiki.kavitareader.com/)

---

## Monitoring Stack

### Components

| Service | Role | URL |
|---|---|---|
| **Prometheus** | Collects and stores metrics | `:9090` |
| **Node Exporter** | System metrics (CPU, RAM, disk) | `:9100` |
| **cAdvisor** | Per-container metrics | `:8082` |
| **Grafana** | Visualization dashboards | `:3001` |
| **Alertmanager** | Routes alerts to Telegram | `:9093` |

### Grafana setup

1. Access `http://<LOCAL_IP>:3001`
2. Login with `GF_SECURITY_ADMIN_USER` / `GF_SECURITY_ADMIN_PASSWORD` from `.env`
3. Add Prometheus as a data source: `http://prometheus:9090`
4. Import dashboards:
   - Node Exporter Full: ID `1860`
   - Docker containers: ID `11600`

### Alertmanager (Telegram)

Configure `containers/alertmanager.yml` with your Telegram bot token and chat ID. Alert rules are defined in `containers/alert_rules.yml`.

📖 [Prometheus Documentation](https://prometheus.io/docs/)
📖 [Grafana Documentation](https://grafana.com/docs/)
📖 [Alertmanager Documentation](https://prometheus.io/docs/alerting/latest/alertmanager/)

---

## Remote Access — Tailscale

Secure mesh VPN — no port forwarding, no exposed ports.

### Initial setup

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --advertise-exit-node --advertise-routes=192.168.1.0/24
```

Go to [Tailscale Admin Console](https://login.tailscale.com/admin) → Machines → your server → approve subnet routes.

### Disable key expiry (recommended for servers)

Admin Console → Machines → your server → three dots → **Disable Key Expiry**

### Useful commands

```bash
tailscale status        # show connected devices
tailscale ip -4         # show your Tailscale IP
tailscale ping <host>   # test connectivity
```

📖 [Tailscale Documentation](https://tailscale.com/kb/)
📖 [Subnet Routers](https://tailscale.com/kb/1019/subnets/)

---

## SSH Hardening

### Generate a key pair (on your local machine)

```bash
ssh-keygen -t ed25519 -C "your_comment"
```

### Copy the public key to the server

```bash
# Linux / macOS
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@<SERVER_IP>

# Windows (PowerShell)
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh user@<SERVER_IP> "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### Disable password login

```bash
sudo nano /etc/ssh/sshd_config
```

```
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
```

```bash
sudo systemctl restart ssh
```

> ⚠️ Verify key access works **before** disabling password login.

### SSH config shortcut (local machine)

```
Host homeserver
    HostName 100.x.y.z
    User yourusername
    IdentityFile ~/.ssh/id_ed25519
```

Connect with just: `ssh homeserver`

---

## Security

| Layer | Tool | Notes |
|---|---|---|
| Network | **UFW** | Configured via `py_scripts/firewall.py` |
| Intrusion prevention | **Fail2Ban** | Bans IPs after repeated failures |
| Antivirus | **ClamAV** | Automatic database updates |
| VPN | **Tailscale** | No exposed ports on the router |
| SSH | **Key-only auth** | Password login disabled |

---

## Cron Jobs

See `cronjobs_template.txt` for the full configuration. Key scheduled jobs:

| Schedule | Job |
|---|---|
| Every Saturday at 05:00 | System and container update |
| Every hour | Network scan |

To apply:
```bash
crontab -e
# paste the content of cronjobs_template.txt
```

---

## Module — Domotic House

## Home Assistant

Smart home automation platform.

### Setup

Home Assistant runs in `network_mode: host` for full local network discovery (mDNS, Bluetooth, etc.).

1. Access `http://<LOCAL_IP>:8123`
2. Follow the onboarding wizard
3. Integrations are added via **Settings → Devices & Services**

### Tips

- Enable **Advanced Mode** in your user profile for more options
- Use **HACS** (Home Assistant Community Store) for additional integrations and themes
- Configure automations in **Settings → Automations**

📖 [Home Assistant Documentation](https://www.home-assistant.io/docs/)
📖 [HACS](https://hacs.xyz/)

---

## Mosquitto

MQTT message broker used by Home Assistant and Zigbee2MQTT.

### Configuration

Config files are in `${BASE_PATH}/mosquitto/config/`. A basic `mosquitto.conf`:

```
listener 1883
allow_anonymous true
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log
```

> For production, disable anonymous access and configure username/password authentication.

📖 [Mosquitto Documentation](https://mosquitto.org/documentation/)

---

## Zigbee2MQTT

Bridges Zigbee devices to MQTT, making them available in Home Assistant.

### Setup

1. Connect your Zigbee USB adapter (e.g. ConBee II, Sonoff Zigbee 3.0)
2. Uncomment the `devices` section in `docker-compose.yml` and set the correct USB path:
   ```yaml
   devices:
     - /dev/ttyUSB0:/dev/ttyUSB0
   ```
3. Access the UI at `http://<LOCAL_IP>:8083`
4. Enable **Permit join** to pair new devices

📖 [Zigbee2MQTT Documentation](https://www.zigbee2mqtt.io/guide/getting-started/)
📖 [Supported Devices](https://www.zigbee2mqtt.io/supported-devices/)

---

## Module — Paperless Suite

Self-hosted document management with fully local AI processing.

See [modules/paperless/README.md](modules/paperless/README.md) for the full setup guide.

### Quick start

```bash
# 1. Create the dedicated database
docker exec -it mariadb mariadb -uroot -p -e \
  "CREATE DATABASE paperless CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE USER 'paperless'@'%' IDENTIFIED BY 'your_password';
   GRANT ALL PRIVILEGES ON paperless.* TO 'paperless'@'%';
   FLUSH PRIVILEGES;"

# 2. Add the Paperless variables to your root .env
# (see modules/paperless/.env.example)

# 3. Start the module
docker compose -f docker-compose.yml -f modules/paperless/docker-compose.yml up -d
```

### Services

| Service | URL |
|---|---|
| Paperless-ngx | `http://<LOCAL_IP>:8010` |
| Paperless-AI | `http://<LOCAL_IP>:8011` |
| Paperless-GPT | `http://<LOCAL_IP>:8012` |

📖 [paperless-ngx Documentation](https://docs.paperless-ngx.com/)
📖 [paperless-ai GitHub](https://github.com/clusterzx/paperless-ai)
📖 [paperless-gpt GitHub](https://github.com/icereed/paperless-gpt)
📖 [Ollama Documentation](https://ollama.com/library)

---

## Module — Jellyfin

Self-hosted media server for movies and TV shows.

See [modules/jellyfin/README.md](modules/jellyfin/README.md) for the full setup guide.

### Quick start

```bash
# 1. Run the setup script
chmod +x modules/jellyfin/jellyfin-setup.sh
./modules/jellyfin/jellyfin-setup.sh

# 2. Add the Jellyfin variables to your root .env
PORT_JELLYFIN=8096
JELLYFIN_URL=https://jellyfin.yourdomain.com   # optional

# 3. Start the module
docker compose -f modules/jellyfin/docker-compose-jellyfin.yml up -d
```

### First boot

1. Access `http://<LOCAL_IP>:8096`
2. Follow the setup wizard — create the admin account
3. Add your media libraries:
   - Movies → `/media/movies`
   - TV Shows → `/media/tvshows`

### Media folder structure

Place your files on the host under `containers/jellyfin/` following this layout:

```
containers/jellyfin/
├── movies/
│   └── Inception (2010)/
│       └── Inception (2010).mkv
└── tvshows/
    └── Breaking Bad/
        └── Season 01/
            └── S01E01.mkv
```

> Follow the [Jellyfin naming conventions](https://jellyfin.org/docs/general/server/media/movies) for correct metadata matching.

### Ports

| Port | Protocol | Description |
|---|---|---|
| `8096` | TCP | Web UI — main access |
| `8920` | TCP | HTTPS — optional, only without reverse proxy |
| `7359` | UDP | LAN client auto-discovery — optional |
| `1900` | UDP | DLNA discovery — optional |

### Recommended clients

| Platform | Client |
|---|---|
| Android TV / Google TV | Jellyfin (Play Store) |
| Samsung Tizen | Jellyfin (Samsung App Store) |
| LG webOS | Jellyfin (LG Content Store) |
| Apple TV | Jellyfin (App Store) |
| Fire TV Stick | Jellyfin (Amazon Store) |
| Android / iOS | Jellyfin mobile app |

### Remote access

Jellyfin works on LAN out of the box. For remote access, install **Tailscale** on the client device (natively supported on Android TV) and connect using the server's Tailscale IP — no port forwarding needed.

📖 [Jellyfin Documentation](https://jellyfin.org/docs/)
📖 [linuxserver/jellyfin image](https://docs.linuxserver.io/images/docker-jellyfin/)


## Module Gaming

### Minecraft Bedrock

Minecraft server compatible with Xbox, mobile, and Windows 10/11 clients.

### Configuration

Server settings are managed via environment variables in `docker-compose.yml`:

| Variable | Default | Description |
|---|---|---|
| `SERVER_NAME` | BrothersSurvival | Server name shown in the list |
| `GAMEMODE` | survival | Game mode |
| `DIFFICULTY` | easy | Difficulty level |
| `MAX_PLAYERS` | 5 | Maximum concurrent players |
| `ONLINE_MODE` | true | Xbox Live authentication |

### Connecting

Use the server's LAN IP and port `19132` (UDP). For remote access, connect via Tailscale IP.

📖 [itzg/minecraft-bedrock-server](https://github.com/itzg/docker-minecraft-bedrock-server)

---