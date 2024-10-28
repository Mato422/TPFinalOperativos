#!/bin/bash

VERDE='\033[0;32m'
ROJO='\033[0;31m'
SC='\033[0m'

respaldo_directorio(){
	local directorio="/Users/Downloads/operativos"
	local backup="/Users/Downloads/backup"
	local archivo_respaldo="$backup/backup_$(date +%F).tar.gz"
	
	echo -e "${VERDE}Generando respaldo de $directorio...${SC}"
	mkdir -p "$backup"
	tar -czf "$archivo_respaldo" "$directorio" 2>/dev/null

	if [[ $? -eq 0 ]]; then
		echo "Respaldo creado en: $archivo_respaldo"
		echo "Eliminando los respaldos de mas de 7 dias de antiguedad ..."
		find "$backup" -type f -name "backup_*.tar.gz" -mtime +7 -exec rm {} \;
	else 
		echo -e "${ROJO}Error al crear el respaldo.${SC}"
	fi
}

informe_sistema(){
	local archivo_informe="sistema.log"

	echo -e "${VERDE}Generando informe del sistema...${SC}"
	{
		echo "Informe del sistema - $(date)"
		echo "uso de CPU:"
		top -bn1 | grep "Cpu(s)"
		echo "uso de memoria:"
		free -h
		echo "uso de disco:"
		df -h
	} > "$archivo_informe"

	if [[ $? -eq 0 ]]; then 
		echo "informe guardado en $archivo_informe"
	else
		echo -e "${ROJO}Error al generar el informe.${SC}"
	fi
}

limpiar_sistema() {

	echo -e "${VERDE}Eliminando archivos temporales y cache...${SC}"
	sudo rm -rf /tmp/*
	sudo rm -rf ~/.cache/*

	if [[ $? -eq 0 ]]; then 
	
		echo "Archivos temporales y cache eliminados correctamente."
	else
		echo -e "${ROJO}Error al limpiar el sistema.${SC}"
	fi
}

menu() {

	while true; do
		
		echo -e "${VERDE}Seleccione una opcion:${SC}"
		echo "1. Respaldo de un directorio"
        	echo "2. Generar informe del sistema"
        	echo "3. Limpiar archivos temporales y caché"
		echo -e "${ROJO}4. Salir${SC}"
		read -p "opcion: " opcion

	if [[ ! $opcion =~ ^[1-4]$ ]]; then
		
		echo -e "${ROJO}Opcion invalida. Ingresar un numero valido (1-4).${SC}"
		continue
	fi

	case $opcion in
		1) respaldo_directorio ;;
           	2) informe_sistema ;;
            	3) limpiar_sistema ;;
            	4) echo "Saliendo..." ; exit 0 ;;
	esac
	done
}

menu
	
