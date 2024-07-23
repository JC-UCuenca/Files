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
  cabeceras=`head -n 2 $1`
  case $opc in
    1)
      filas=`cat $1 | grep "001"`
      echo "$cabeceras"
      echo "$filas"
      ;;
    2)
      filas=`tail +3 $1`
      numLineas=`echo "$filas" | wc -l | cut -d " " -f1`
      filas=`echo "$filas" | head -n $(( numLineas - 1 ))`
      filas=`echo "$filas" | sort -k3,3`
      echo "$cabeceras"
      echo "$filas"
      ;;
    3)
      filas=`cat $1 | grep "001" | grep "PRINTER"`
      echo "$cabeceras"
      echo "$filas"
      ;;
    4)
      numLineas=`wc -l $1 | cut -d " " -f1`
      filas=`tail -$(( numLineas -2 )) $1`

      numLineas=`echo "$filas" | wc -l | cut -d " " -f1`
      filas=`echo "$filas" | head -n $(( numLineas - 1 ))`
      filas=`echo "$filas" | sort -k1,1 -k4,4`
      echo "$cabeceras"
      echo "$filas"
      ;;
    5)
      exit 0
      ;;
    *)
      echo "Opcion no valida"
  esac
done
