#!/bin/bash

# Se simplifican los valores de acceso en una sola variable
LOGIN_STRING="lanplus -H $IDRAC_IP -U $IDRAC_USER -P $IDRAC_PASSWORD"

# Ejecutar el comando y capturar el resultado
TEMP=$(ipmitool -I $LOGIN_STRING sdr type temperature | grep "Ambient Temp" | grep "degrees")

if [[ -n "$TEMP" ]]; then
  exit 0  # Contenedor sano
else
  echo "Comprobación de salud fallida: no se ha podido obtener la temperatura"
  exit 1  # Contenedor no sano
fi