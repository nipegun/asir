#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar xxxxxxxxx en Debian
#
# Ejecución remota:
#   curl -sL x | bash
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de búsqueda de posibles proxmox corriendo en la IP pública de Zubiri Manteo...${vFinColor}"
  echo ""

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install curl
    echo ""
  fi

# Determinar la IP WAN
  #vIPWAN=$(curl --silent ipinfo.io/ip)
  vIPWAN=88.10.220.167

# Escanear puertos y salvar a un archivo
  echo "  Escaneando puertos posibles ..."
  # Comprobar si el paquete nmap está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s nmap 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    El paquete nmap no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install nmap
      echo ""
    fi
  nmap $vIPWAN -p 9000-12000 | grep ^1 | cut -d'/' -f1 > /tmp/puertos.txt

#
  for line in $(cat /tmp/puertos.txt)
    do
      echo ""

      vRespuestaHTTP=$(curl -H 'Cache-Control: no-cache, no-store' --silent --max-time 10 -s -o /dev/null -w "%{http_code}" "http://$vIPWAN:$line")
      if [ $vRespuestaHTTP != "000" ]; then
       #echo  "  Escaneando http://$vIPWAN:$line - Respuesta: $vRespuestaHTTP"
       echo  "  Escaneando  http://$vIPWAN:$line" $(curl --silent --max-time 10            "http://$vIPWAN:$line" | grep "itle>" )
      fi

      vRespuestaHTTPS=$(curl -H 'Cache-Control: no-cache, no-store' --silent --max-time 10 --insecure -s -o /dev/null -w "%{http_code}" "https://$vIPWAN:$line")
      if [ $vRespuestaHTTPS != "000" ]; then
        #echo  "  Escaneando https://$vIPWAN:$line - Respuesta: $vRespuestaHTTPS"
        echo  "  Escaneando https://$vIPWAN:$line" $(curl --silent --max-time 10 --insecure "https://$vIPWAN:$line" | grep "itle>")
      fi

      echo ""
  #sudo nmap -sV -O -sSU $IPWAN -p $line
    done

