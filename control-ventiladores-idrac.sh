#!/bin/bash

# Esta aplicación solo es válida para iDRAC6e sobre Dell PowerEdge R510, en el que la iDRAC sólo tiene acceso a la temperatura del sensor de ambiente (system board ambient)

# Se convierte la variable de velocidad decimal del usuario a hexadecimal de dos dígitos, que es como trabaja la iDRAC6e
HEX_FAN_SPEED=$(printf '0x%02x' $FAN_SPEED)

# Se simplifican los valores de acceso en una sola variable
LOGIN_STRING="lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD"

# Función para ceder el control a la iDRAC
ceder_control() {
  echo "Se cede el control al sistema."
  ipmitool -I $LOGIN_STRING raw 0x30 0x30 0x01 0x01
}

# Función para gestionar ventiladores
gestionar_ventiladores() {
  TEMP=$(ipmitool -I $LOGIN_STRING sdr type temperature | grep "Ambient Temp" | grep "degrees" | awk '{print $(NF-2)}')

  # Se comprueba si la temperatura es válida
  if ! [[ "$TEMP" =~ ^[0-9]+$ ]]; then
    echo "Error: Temperatura no válida o no disponible. Temperatura: $TEMP"
    return
  fi

  echo "Temperatura actual: $TEMP°C"

  if [ $TEMP -gt $MAX_TEMP_AMBIENT ]; then
    # Ceder control a la iDRAC si la temperatura excede el límite
    echo "Temperatura excedida ($TEMP°C > $MAX_TEMP_AMBIENT°C). Se cede el control al sistema."
    ceder_control

  else
    # Si la temperatura es normal, cambiar la velocidad de los ventiladores
    # Modo manual
    echo "Temperatura normal. Se ajustan los ventiladores a la velocidad personalizada."
    ipmitool -I $LOGIN_STRING raw 0x30 0x30 0x01 0x00

    # ventiladores system board MOD 1A y system board MOD 1B
    ipmitool -I $LOGIN_STRING raw 0x30 0x30 0x02 0x00 $HEX_FAN_SPEED

    # ventiladores system board MOD 2A y system board MOD 2B
    ipmitool -I $LOGIN_STRING raw 0x30 0x30 0x02 0x01 $HEX_FAN_SPEED

    # ventiladores system board MOD 3A y system board MOD 3B
    ipmitool -I $LOGIN_STRING raw 0x30 0x30 0x02 0x02 $HEX_FAN_SPEED

    # ventiladores system board MOD 4A y system board MOD 4B
    ipmitool -I $LOGIN_STRING raw 0x30 0x30 0x02 0x03 $HEX_FAN_SPEED

    # ventiladores system board MOD 5A y system board MOD 5B
    ipmitool -I $LOGIN_STRING raw 0x30 0x30 0x02 0x07 $HEX_FAN_SPEED
  fi
}

# Capturar señales para manejar la detención del contenedor
trap ceder_control SIGINT SIGQUIT SIGTERM

# Ejecutar la gestión de ventiladores indefinidamente
while true; do
  gestionar_ventiladores
  sleep $CHECK_INTERVAL # Espera entre verificaciones
done
