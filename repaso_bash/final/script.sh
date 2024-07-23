#!/bin/bash

if [ $1 != "zonas.dat" ] || [ $2 != "entregas.dat" ]; then
  echo "Archivos en el orden incorrecto"
  exit 1
fi

zonas=`sed 's/, /,/g' $1`
entregas=`tail -n +2 $2`

> en_proceso.dat
> completado.dat
echo "$entregas" > faltantes.dat

while [ -s faltantes.dat ]; do
while read -r fila; do
  #Comprobar zona-motorizado
  zona=`echo "$fila" | awk '{print $1}'`
  motorizado=`echo "$fila" | awk '{print $2}'`
  cliente=`echo "$fila" | awk '{print $3}'`

  echo $1 | awk -v zona=$zona -v moto=$motorizado '($1==zona) && /moto/ {print}' &> /dev/null
#  if [ $? -eq 0 ]; then
#    echo "zona-motorizado CORRECTO"
#  fi

  #Verificar si no esta en proceso
  grep "$motorizado" en_proceso.dat &> /dev/null
  if [ $? -eq 0 ]; then
#    echo "EN PROCESO: $motorizado"
#    sleep 7
    continue
  fi

  #Programar tarea
  tiempo=`echo "$fila" | awk '{print $4}'`
  carpeta_actual=`pwd`

  num_linea=`nl -ba faltantes.dat | sed -n "/$zona $motorizado $cliente $tiempo/{p;q}" | awk '{print $1}'`
#  echo "LINEA: $num_linea"
  sed -i "${num_linea}d" faltantes.dat
#cat faltantes.dat
#sleep 10
#  sed -i "/$zona $motorizado $cliente $tiempo/d" $carpeta_actual/faltantes.dat
  echo "$zona $motorizado $tiempo" >> en_proceso.dat

  sleep $tiempo && sed -i "/$zona $motorizado $tiempo/d" $carpeta_actual/en_proceso.dat &
  sleep $tiempo && echo "$zona $motorizado $tiempo" >> $carpeta_actual/completado.dat &

#  echo "========================================================================================"
#  echo "FALTANTES:"; cat faltantes.dat; echo ""
#  echo "EN_PROCESO:"; cat en_proceso.dat; echo ""
#  echo "COMPLETADO:"; cat completado.dat; echo ""
#  sleep 15
done < faltantes.dat
done
