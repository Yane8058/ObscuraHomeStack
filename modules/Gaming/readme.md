# 🎮 Module Gaming: 

## Minecraft Bedrock Server

This module deploys a **Minecraft: Bedrock Edition** dedicated server, allowing players on mobile (iOS/Android), Windows 10/11, and consoles to join a persistent world.

## 🏗️ Service Details

* **Image**: `itzg/minecraft-bedrock-server` (Multi-platform support).
* **Mode**: Survival.
* **Difficulty**: Easy.
* **Cheats**: Enabled (Allow cheats: true).
* **Permissions**: Default level set to **Operator**.

---

## 📂 Project Integration

This module is integrated into the **OBSCURAHOMESTACK** and uses the global environment configuration.

* **Variables**: Managed via the root `.env` file.
* **Storage**: Data is persisted in `${BASE_PATH}/minecraft-bedrock`.
* **Network**: Connected to the internal `obscura_net`.

---

## ⚙️ Preparation

Ensure your global **`.env`** file at the root contains the following variables:

```bash
# Example keys required in your root .env
BASE_PATH=/path/to/your/storage
PORT_MINECRAFT=<port>
```

### 📁 Directory Setup
Before launching, ensure the data directory exists and has the correct permissions:
```bash
mkdir -p "$BASE_PATH/minecraft-bedrock"
sudo chown -R 1000:1000 "$BASE_PATH/minecraft-bedrock"
```

---

## 🚀 Deployment

**Using the terminal from the project root:**
```bash
docker compose -f modules/Minecraft/docker-compose-minecraft.yml up -d
```

---

## 🕹️ How to Connect

1.  Open **Minecraft Bedrock Edition**.
2.  Go to **Play** > **Servers** > **Add Server**.
3.  Enter the details:
    * **Server Name**: `YOUR_SERVER_NAME`
    * **Server Address**: Your Server IP (e.g., `192.168.1.10`)
    * **Port**: `<port>` (or the value of `${PORT_MINECRAFT}`)

> **Note**: This server uses **UDP**. If you are accessing this from outside your local network, ensure port `19132` is forwarded in your router settings for the **UDP** protocol.

---

## 🛠️ Maintenance & Console

To view the server logs (to see who joined or check for errors):
```bash
docker logs -f minecraft
```

To run commands directly in the Minecraft console (e.g., giving items or changing weather):
```bash
docker exec -i minecraft send-command "weather clear"
```

---

### ⚠️ Important Note on EULA
By running this container, you are agreeing to the Minecraft **End User License Agreement (EULA)** as the environment variable `EULA=TRUE` is set in the compose file.