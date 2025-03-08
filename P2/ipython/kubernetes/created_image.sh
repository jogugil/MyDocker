#!/bin/bash

# Crear el Dockerfile
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

echo "Imagen creada."
