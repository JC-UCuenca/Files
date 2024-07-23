#!/bin/bash

./script.sh zonas.dat entregas.dat &

opc=-1
while (( opc != 5 )); do
  echo "---MENU---"
  echo "1. Lista de motorizados que no han hecho entregas."
  echo "2. Tiempo total empleado por un motorizado."
  echo "3. Número de veces que un motorizado ha realizado entregas."
  echo "4. Reporte del número de entregas por zona que se han realizado."
  echo "5. Salir."
  read -p "Seleccione una opcion: " opc

  echo ""
  case $opc in
    1)
      echo "SIN ENTREGAS"
      cat faltantes.dat | awk '{print $2}' | uniq
      ;;

    2)
      echo "TIEMPO POR MOTORIZADO"
      motos=`awk '{print $2}' completado.dat | uniq`
      for moto in $motos; do
	awk -v moto="$moto" '$2 == moto {suma+=$3} END {print moto ": " suma}' completado.dat
      done
      ;;

    3)
      echo "ENTREGAS POR MOTORIZADO"
      motos=`awk '{print $2}' completado.dat | uniq`
      for moto in $motos; do
        awk -v moto=$moto 'BEGIN {cont=0} $0 ~ moto {cont+=1} END {print moto ": " cont}' completado.dat
      done
      ;;

    4)
      echo "ENTREGAS POR ZONA"
      zonas=`tail -n +2 zonas.dat | awk '{print $1}'`
      for zona in $zonas; do
        awk -v zona=$zona 'BEGIN {cont=0} $0 ~ zona {cont+=1} END {print zona ": " cont}' completado.dat
      done
      ;;

    5)
      exit 0
      ;;

    *)
       echo "ERROR: Opcion no valida"
       ;;
  esac
  echo ""
done
