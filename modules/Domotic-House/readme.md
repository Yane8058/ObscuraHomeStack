
# 🏠 Domotic-House Stack: HA + Zigbee2MQTT + Mosquitto

This repository contains the Docker Compose configuration for a centralized, scalable, and locally controlled home automation ecosystem.

## 🏗️ System Architecture

The setup is built on three core pillars that communicate to manage your smart devices:

1.  **Home Assistant**: The "brain" of the house. It provides the user interface, automation engine, and dashboard.
2.  **Zigbee2MQTT**: The "bridge" that allows Zigbee devices (from brands like Xiaomi, IKEA, Sonoff, Philips, etc.) to communicate via the MQTT protocol.
3.  **Eclipse Mosquitto**: The "broker" (postman) that handles messages between Zigbee2MQTT and Home Assistant.

---

## 📋 Prerequisites

* **Docker** and **Docker Compose** installed.
* A **Zigbee USB adapter** (e.g., Sonoff ZBDongle-E/P, ConBee II) connected to your server.
* A `.env` file in the same directory as your `docker-compose.yml` to manage variables.

---

## 🛠️ Service Details

### 1. Eclipse Mosquitto
A lightweight MQTT broker.
* **Note:** On the first run, ensure you create a `mosquitto.conf` file in `${BASE_PATH}/mosquitto/config/`. For Mosquitto v2.0+, you must explicitly configure authentication or allow anonymous access to allow Zigbee2MQTT to connect.

### 2. Zigbee2MQTT
Allows you to use Zigbee devices without proprietary hubs.
* **⚠️ CRITICAL:** In the `docker-compose.yml`, you **must** uncomment the `devices` section and map your USB stick path correctly (usually `/dev/ttyUSB0` or `/dev/ttyACM0`).
* Config: Point the MQTT server address in Zigbee2MQTT's configuration to the IP of the `mosquitto` container or the server IP.

### 3. Home Assistant
Using the **LinuxServer.io** image, optimized for Docker environments.
* **Network Mode: Host**: This is required for Home Assistant to automatically discover devices on your local network (e.g., Google Cast, DLNA, WLED, Yeelight).

---

## 🚀 Installation & Setup

1.  Navigate to the folder containing your `docker-compose.yml`.
2.  Start the stack in detached mode:
    ```bash
    docker-compose up -d
    ```
3.  Access the web interfaces:
    * **Home Assistant:** `http://<YOUR-SERVER-IP>:<port>`
    * **Zigbee2MQTT Frontend:** `http://<YOUR-SERVER-IP>:<port>`

---

## 🛡️ Maintenance & Logs

To monitor the status of your services or troubleshoot pairing issues:

```bash
# View real-time logs for Zigbee2MQTT
docker logs -f zigbee2mqtt

# View logs for Home Assistant
docker logs -f homeassistant

# Restart a specific service after a config change
docker-compose restart zigbee2mqtt
```

---

## 💡 Pro Tips
* **Permissions:** Ensure your user has access to the serial port by running `sudo usermod -aG dialout $USER` and rebooting.
* **Backups:** Since all data is stored in `${BASE_PATH}`, simply backing up that folder will secure your entire configuration.

---

### FAQ
**Q: Why isn't Home Assistant connecting to Mosquitto?**
**A:** Check if you have enabled the MQTT integration inside Home Assistant and pointed it to your server's IP address and the port defined in `PORT_MOSQUITTO`.