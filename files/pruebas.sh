#!/bin/bash

# Limpiar cualquier instancia previa
pkill -9 memcached 2>/dev/null

# Redirigir toda la salida
exec > pruebas.log 2>&1

# Iniciar memcached
echo "Iniciando memcached..."
memcached --daemon

# Esperar inicio completo
sleep 0.5

# Verificar proceso
echo -e "\nProceso de memcached:"
pgrep memcached

# Ver detalles
echo -e "\nEstado del proceso:"
ps ax | grep '[m]emcached'

# Verificar puerto
echo -e "\nVerificando puerto 11211:"
netstat -ntulp | egrep '11211|memcached'

# Test de conexión
echo -e "\nTest de conexión con nc:"
timeout 1 nc -vz localhost 11211

#---------------------- función auxiliar para comandos printf
runStop() {
	PID=$!
	sleep 5
	kill -SIGINT "$PID"
}

# Comandos con timeout
echo -e "\nObteniendo versión:"

printf "version\r\n" | nc localhost 11211 & runStop

echo -e "\nEstableciendo valor:"
printf "set foo 0 300 3\r\nbar\r\n" | nc localhost 11211 & runStop

echo -e "\nObteniendo valor:"
printf "get foo\r\n" | nc localhost 11211 & runStop

echo -e "\nEliminando valor:"
printf "delete foo\r\n" | nc localhost 11211 & runStop

echo -e "\nLimpiando todos los valores:"
printf "flush_all\r\n" | nc localhost 11211 & runStop

echo -e "\nIntentando obtener valor eliminado:"
printf "get foo\r\n" | nc localhost 11211 & runStop

# Detener memcached
echo -e "\nDeteniendo memcached:"
pkill -9 memcached
sleep 0.5  # Esperar liberación de recursos
echo "Código de salida: $?"

# Verificación final
echo -e "\nVerificación final de puerto:"
netstat -ntulp | egrep '11211|memcached'

echo -e "\nVerificación final del proceso:"
pgrep memcached || echo "No hay procesos activos"
