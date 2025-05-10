# control-ventiladores-idrac

## 🇪🇸 Descripción en Español

Esta aplicación solo es válida para **iDRAC6 Enterprise (iDRAC6e)** sobre **Dell PowerEdge R510**, en el que la iDRAC solo tiene acceso al sensor de temperatura ambiental (`System Board Ambient Temp`).

### ¿Qué hace esta aplicación?

Controla manualmente la velocidad de los ventiladores del servidor Dell PowerEdge R510 a través de iDRAC6e utilizando `ipmitool`. El objetivo es mantener una temperatura ambiental adecuada sin ceder el control a iDRAC, salvo cuando se supere un umbral definido.

- Si la temperatura ambiental está **por debajo o igual al umbral** (por defecto: 36 °C), el script fuerza los ventiladores a una velocidad fija (por defecto: 10 %).
- Si la temperatura ambiental **supera el umbral**, se cede automáticamente el control de los ventiladores a iDRAC para proteger el hardware.

### Componentes

- `control-ventiladores-idrac.sh`: script principal que comprueba la temperatura y ajusta los ventiladores.
- `control-salud.sh`: script de comprobación de salud de Docker. Verifica si se puede obtener la temperatura ambiental.
- `Dockerfile`: crea una imagen Docker basada en Ubuntu, instala `ipmitool` e incluye los scripts.

### Variables de entorno (personalizables)

- `IDRAC_IP`: dirección IP de iDRAC.
- `IDRAC_USER`: usuario de iDRAC (por defecto: `root`).
- `IDRAC_PASSWORD`: contraseña de iDRAC (por defecto: `calvin`).
- `FAN_SPEED`: velocidad fija de los ventiladores (0–100, por defecto: `10`).
- `MAX_TEMP_AMBIENT`: temperatura máxima permitida antes de ceder el control (por defecto: `36` °C).
- `CHECK_INTERVAL`: intervalo entre verificaciones (por defecto: `300` segundos).

### Instalación

La aplicación está diseñada para ejecutarse dentro de un contenedor Docker. Se ha publicado en [Docker Hub](https://hub.docker.com/repository/docker/cesar182281/control-ventiladores-idrac/general) para facilitar su instalación a través del gestor de aplicaciones de TrueNAS SCALE, que utiliza contenedores Docker.

> **Aviso:** Este script interactúa directamente con el hardware del servidor. Úsalo bajo tu propia responsabilidad y asegúrate de que los valores configurados son seguros.

---

## 🇬🇧 English Description

This application is only valid for **iDRAC6 Enterprise (iDRAC6e)** on **Dell PowerEdge R510**, where iDRAC only has access to the ambient temperature sensor (`System Board Ambient Temp`).

### What does this application do?

It manually controls the fan speed of the Dell PowerEdge R510 server through iDRAC6e using `ipmitool`. The goal is to maintain a suitable ambient temperature without letting iDRAC take over, except when temperature exceeds a defined threshold.

- If the ambient temperature is **below or equal to the threshold** (default: 36 °C), the script forces the fans to run at a fixed speed (default: 10%).
- If the ambient temperature **exceeds the threshold**, control is automatically handed back to iDRAC to protect the hardware.

### Components

- `control-ventiladores-idrac.sh`: main script that checks the temperature and adjusts the fans.
- `control-salud.sh`: Docker health check script. It verifies that ambient temperature can be retrieved.
- `Dockerfile`: builds the Docker image based on Ubuntu, installs `ipmitool`, and adds the scripts.

### Environment Variables (customizable)

- `IDRAC_IP`: iDRAC IP address.
- `IDRAC_USER`: iDRAC username (default: `root`).
- `IDRAC_PASSWORD`: iDRAC password (default: `calvin`).
- `FAN_SPEED`: fixed fan speed (0–100, default: `10`).
- `MAX_TEMP_AMBIENT`: maximum allowed ambient temperature before handing back control (default: `36` °C).
- `CHECK_INTERVAL`: interval between checks (default: `300` seconds).

### Installation

This application is intended to run inside a Docker container. It has been published on [Docker Hub](https://hub.docker.com/repository/docker/cesar182281/control-ventiladores-idrac/general) so it can be installed easily via the TrueNAS SCALE application manager, which uses Docker containers.

> **Warning:** This script directly interacts with server hardware. Use it at your own risk and ensure the configured values are safe for your environment.
