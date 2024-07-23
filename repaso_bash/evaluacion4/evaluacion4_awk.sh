#!/bin/bash

if [ -z $1 ] && [ -f $1 ]; then
  echo "Se necesita un archivo como parametro"
  exit 1
fi

echo "Equipo: "`hostname`

opc=-1
while (( opc != 5 )); do
  echo "---MENU---"
  echo "1. ENCUENTRE TODOS LOS EQUIPOS QUE ESTÁN INSTALADOS EN LA PLANTA P001"
  echo "2. LISTAR LOS EQUIPOS ORDENADOS POR FECHA DE COMPRA"
  echo "3. MOSTRAR LAS IMPRESORAS QUE SE ENCUENTREN EN LA PLANTA P001"
  echo "4. LISTAR EN FORMA ORDENADA SEGÚN EL CÓDIGO DEL EQUIPO Y LA PLANTA EN LA CUAL SE ENCUENTRA INSTALADO"
  echo "5. SALIR"
  read -p "Seleccione una opcion: " opc

  echo ""
  cabeceras=`awk '{if (NR <= 2) print $0}' "$1"`
  case $opc in
    1)
      filas=`awk '($4 == "001") {print}' $1`
      echo "$cabeceras"
      echo "$filas"
      ;;
    2)
      filas=`awk '/^0/ {print}' $1 | sort -k3`
      echo "$cabeceras"
      echo "$filas"
      ;;
    3)
      filas=`awk '($4 == "001") && ($2 == "PRINTER") {print}' $1`
      echo "$cabeceras"
      echo "$filas"
      ;;
    4)
      filas=`awk '$0 ~ /^0/ {print}' $1 | sort -k1 -k4`
      echo "$cabeceras"
      echo "$filas"
      ;;
    5)
      exit 0
      ;;
    *)
      echo "Opcion no valida"
  esac
  echo ""
done
