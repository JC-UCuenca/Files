#!/bin/bash

ps -ef > archivo.txt
echo "Archivo generado correctamente"

opc=-1
while((opc != 4)); do
	echo "---MENU---"
	echo "1.PPID, usuario, comando"
	echo "2.Procesos ordenados"
	echo "3.Procesos de un usuario"
	echo "4.Salir"
	read -p "Seleccione una opcion: " opc

	echo ""
	case $opc in
		1)
		  read -p "ID del proceso: " pid
		  res=`awk -v pid=$pid '{if ($2 == pid) print $2 " " $3 " " $1 " " $8}' archivo.txt`
		  command=`echo "$res" | cut -d " " -f4 | awk -F"/" '{print $NF}'`
		  awk -v pid=$pid '{if ($2 == pid){
			print "PID: " $2;
			print "PPID: " $3;
			print "USER: " $1;}}' archivo.txt
		  echo "Command: $command"

		  ;;
		2)
		  cat archivo.txt | head -n 1
		  cat archivo.txt | tail +2 | sort -k2 -r
		  ;;
		3)
		  read -p "Usuario: " usuario
		  id $usuario &> /dev/null
		  if [ $? -ne 0 ]; then
			echo "ERROR: El usuario $usuario no existe"
			echo ""; continue
		  fi

		  cat archivo.txt | head -n 1
		  awk -v usu=$usuario 'BEGIN {count=0} {if ($1 == usu) {
			print $0;
			count++;
			}} END {print "Total: " count}' archivo.txt
	 	  ;;
		4)
		  exit 0;
		  ;;
		*)
		  echo "ERROR: Opcion no valida"
	esac
	echo ""
done
