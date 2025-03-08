#!/bin/bash

# Paso 1: Crear el Dockerfile con las instrucciones
cat <<EOF > Dockerfile
# Usar la imagen base de Ubuntu 22.04
FROM ubuntu:22.04

# Establecer el directorio de trabajo
WORKDIR /app

# Actualizar e instalar dependencias básicas
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl \
    bash \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    iputils-ping \
    iproute2 \
    net-tools \
    iputils-tracepath \
    && rm -rf /var/lib/apt/lists/*

#Instalar ipython e ipyparallel mediante pip
RUN pip3 install ipython ipyparallel

# Comprobar si python3, pip3, ipython y ipyparallel se instalaron correctamente
RUN python3 --version && pip3 --version && ipython --version && pip show ipyparallel

# Exponer el puerto para el controlador de iPython
EXPOSE 8888

# Comando por defecto para ejecutar bash
CMD ["tail", "-f", "/dev/null"]
EOF

# Paso 2: Construir la imagen usando el Dockerfile
echo "Construyendo la imagen..."
docker build -t faasioflex/ipython:jogugil .

# Paso 3: Verificar que la imagen se haya creado correctamente
if [ $? -eq 0 ]; then
    echo "La imagen se construyó correctamente."
else
    echo "Hubo un error al construir la imagen. Deteniendo el script."
    exit 1
fi

# Paso 4: Crear y ejecutar el contenedor
echo "Creando el contenedor..."
docker run -d --name ipfe faasioflex/ipython:jogugil tail -f /dev/null

# Paso 5: Verificar que el contenedor esté corriendo
if [ $? -eq 0 ]; then
    echo "El contenedor se creó y está corriendo correctamente."
else
    echo "Hubo un error al crear el contenedor. Deteniendo el script."
    exit 1
fi

# Verificar que el contenedor esté en ejecución
echo "Verificando que el contenedor esté corriendo..."
docker ps -a | grep ipfe > /dev/null
if [ $? -eq 0 ]; then
    echo "El contenedor está corriendo."
else
    echo "El contenedor no está corriendo. Deteniendo el script."
    exit 1
fi

# Paso 6: Verificar las instalaciones dentro del contenedor
echo "Verificando las instalaciones de iputils-ping e iproute2..."
docker exec ipfe dpkg -l | grep -E 'iputils-ping|iproute2'
if [ $? -ne 0 ]; then
    echo "Error: iputils-ping o iproute2 no están instalados correctamente. Deteniendo el script."
    exit 1
else
    echo "iputils-ping e iproute2 están instalados correctamente."
fi

echo "Verificando las instalaciones de ipython e ipyparallel..."
docker exec ipfe pip2 show ipython ipyparallel
if [ $? -ne 0 ]; then
    echo "Error: ipython o ipyparallel no están instalados correctamente. Deteniendo el script."
    exit 1
else
    echo "ipython e ipyparallel están instalados correctamente."
fi

# Paso 7: Si todo está bien, el script termina
echo "Todo está instalado correctamente en el contenedor."
