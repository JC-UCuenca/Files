#!/bin/bash

validar_minuto(){
  if (( $1 == 1 )) || (( $1 == 5 )) || (( $1 == 10 )); then
    echo 1
  else
    echo 0
  fi
}

validar_dia(){
  if (( $1 >= 1 )) && (( $1 <= 7 )); then
    echo 1
  else
    echo 0
  fi
}

validar_hora(){
  if (( $1 == 9 )) || (( $1 == 15 )) || (( $1 == 21 )); then
    echo 1
  else
    echo 0
  fi
}

if [ -z $1 ] || ! [ -f $1 ]; then
  echo "ERROR: Se debe pasar un archivo"
  exit 1
fi


opc=-1
while(( opc != 4 )); do
  echo "---MENU---"
  echo "1. Valor promedio de la carga del sistema"
  echo "2. El menor valor de la columna"
  echo "3. El valor máximo de carga"
  echo "4. Salir"
  read -p "Seleccione una opcion: " opc

  echo ""
  datos=`tail +4 archivo.txt | head -7 | awk '{print substr($0, index($0, "0"))}' | sed 's/ //g'`
  case $opc in
    1)
      read -p "Valor a considerar (1, 5, 10): " minuto
      read -p "Dia de la semana (Lunes:1, Domingo:7): " dia
      read -p "Hora (9, 15, 21): " hora

      if (( $(validar_minuto minuto) == 0 )); then
	echo "ERROR: Minuto no valido"; echo ""; continue
      fi
      if (( $(validar_dia dia) == 0 )); then
        echo "ERROR: Dia no valido"; echo ""; continue
      fi
      if (( $(validar_hora hora) == 0 )); then
        echo "ERROR: Hora no valida"; echo ""; continue
      fi

      case $hora in
	9) hora=1;; 15) hora=2;; 21) hora=3;; esac

      case $minuto in
        5) minuto=2;; 10) minuto=3;; esac

      dato=`echo "$datos" | sed -n "${dia}p" | awk -F"/" -v h=$hora '{print $h}'`
      dato=`echo "$dato" | awk -F"," -v m=$minuto '{print $m}'`
      echo "$dato"
      ;;

    2)
      read -p "Hora (9, 15, 21): " hora
      if (( $(validar_hora hora) == 0 )); then
        echo "ERROR: Minuto no valido"
      fi
      case $hora in
        9) hora=1;; 15) hora=2;; 21) hora=3;; esac

      dato=`echo "$datos" | awk -F"/" -v h=$hora '{print $h}'`
      echo "$dato"
      dato=`echo "$dato" | awk -F"," 'BEGIN {min=1}
	{if ($1 < min) min=$1; if ($2 < min) min=$2; if ($3 < min) min=$3} END {print min}'`
      echo "Minimo: $dato"
      ;;

    3)
      dato=`echo "$datos" | sed 's/\//,/g' | awk -F"," 'BEGIN {max=0}
        {for(i=1; i<=9; i++) if ($i > max) max=$i} END {print max}'`
      echo "Maximo: $dato"
      ;;

    4)
      exit 0
      ;;
    *)
      echo "ERROR: Opcion no valida"
      ;;
  esac
  echo ""
done
