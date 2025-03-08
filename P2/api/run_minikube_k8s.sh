#!/bin/bash

# Función para comprobar si Minikube está instalado
comprobar_minikube() {
  echo "🔍 Comprobando si Minikube está instalado..."
  if ! command -v minikube &> /dev/null; then
    echo "❌ Minikube no está instalado. ¿Quieres instalarlo? (s/n)"
    read respuesta
    if [[ "$respuesta" == "s" || "$respuesta" == "S" ]]; then
      echo "🚀 Instalando Minikube..."
      sudo apt-get update
      sudo apt-get install -y conntrack
      curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
      sudo install minikube /usr/local/bin/
      kv=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
      curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$kv/bin/linux/amd64/kubectl && sudo install kubectl /usr/local/bin/
      echo "✅ Minikube instalado exitosamente. Por favor, reinicia el terminal o ejecuta 'source ~/.bashrc'."
    else
      echo "❌ Por favor, instala Minikube manualmente e inténtalo de nuevo."
      exit 1
    fi
  else
    echo "✅ Minikube ya está instalado."
  fi
}

# Función para comprobar si Python y pipx están instalados
comprobar_python_y_pipx() {
  echo "🔍 Comprobando si Python está instalado..."
  if ! command -v python3 &> /dev/null; then
    echo "❌ Python no está instalado. ¿Quieres instalarlo? (s/n)"
    read respuesta
    if [[ "$respuesta" =~ ^[Ss]$ ]]; then
      echo "🚀 Instalando Python..."
      if ! sudo apt-get update; then
        echo "⚠️ Error al actualizar los repositorios. Por favor, revisa tu conexión de red o los repositorios."
        exit 1
      fi
      if ! sudo apt-get install -y python3 python3-pip; then
        echo "❌ Error al instalar Python."
        exit 1
      fi
      echo "✅ Python instalado exitosamente."
    else
      echo "❌ Por favor, instala Python manualmente e inténtalo de nuevo."
      exit 1
    fi
  else
    echo "✅ Python ya está instalado."
  fi

  echo "🔍 Comprobando si pipx está instalado..."
  if ! command -v pipx &> /dev/null; then
    echo "❌ pipx no está instalado. ¿Quieres instalar pipx? (s/n)"
    read respuesta
    if [[ "$respuesta" =~ ^[Ss]$ ]]; then
      echo "🚀 Instalando pipx..."
      if ! python3 -m pip install --user pipx; then
        echo "❌ Error al instalar pipx."
        exit 1
      fi
      export PATH=$PATH:$(python3 -m site --user-base)/bin
      echo "✅ pipx instalado exitosamente."
    else
      echo "❌ Por favor, instala pipx manualmente e inténtalo de nuevo."
      exit 1
    fi
  else
    echo "✅ pipx ya está instalado."
  fi
}

# Comprobar que Minikube está instalado
comprobar_minikube

# Comprobar que Python y pipx están instalados
comprobar_python_y_pipx

# Verificar si ambos parámetros son proporcionados
if [ $# -lt 2 ]; then
  echo "❌ Debe proporcionar dos parámetros: el nombre del script Python y el archivo de entrada."
  exit 1
fi

# Obtener el token desde Kubernetes
echo "🔑 Obteniendo el token de Kubernetes..."
TOKEN=$(kubectl get secret $(kubectl -n kube-system get secret | grep default-token | awk '{print $1}') -n kube-system -o jsonpath="{.data.token-secret}" | base64 --decode)

# Verificar si el token se obtuvo correctamente
if [ -z "$TOKEN" ]; then
  echo "❌ No se pudo obtener el token."
  exit 1
else
  echo "✅ Token obtenido exitosamente."
fi

# Obtener el endpoint del servidor API de Kubernetes
echo "🌐 Obteniendo el endpoint del servidor API de Kubernetes..."
HOST=$(kubectl cluster-info | grep -o 'https://[0-9.]*:[0-9]*')

# Verificar si el host se obtuvo correctamente
if [ -z "$HOST" ]; then
  echo "❌ No se pudo obtener el host."
  exit 1
else
  echo "✅ Host obtenido exitosamente: $HOST"
fi

# Exportar las variables de entorno para que el script Python las lea
echo "📤 Exportando las variables de entorno..."
export K8S_HOST="$HOST"
export K8S_TOKEN="$TOKEN"

# Crear el archivo de configuración para Kubernetes con el host y el token
CONFIG_FILE="./k8s_config.json"
echo "📝 Creando el archivo de configuración: $CONFIG_FILE"
cat <<EOF > "$CONFIG_FILE"
{
  "host": "$K8S_HOST",
  "token": "$K8S_TOKEN"
}
EOF
echo "✅ Archivo de configuración creado exitosamente."

# Obtener los parámetros: el nombre del script Python y el archivo de entrada
PYTHON_SCRIPT=$1
INPUT_FILE=$2

# Comprobamos que el archivo de entrada existe
echo "🔍 Comprobando si el archivo de entrada existe..."
if [ ! -f "$INPUT_FILE" ]; then
    echo "❌ El archivo de entrada $INPUT_FILE no existe."
    exit 1
else
    echo "✅ Archivo de entrada encontrado: $INPUT_FILE"
fi

# Ejecutar el script Python dentro de Minikube, pasando el archivo de entrada como argumento
echo "🚀 Ejecutando el script Python en Minikube..."
minikube ssh "python3 $PYTHON_SCRIPT $INPUT_FILE"

# Verificar si el comando se ejecutó correctamente
if [ $? -eq 0 ]; then
    echo "✅ El script Python se ejecutó correctamente dentro de Minikube."
else
    echo "❌ Hubo un error al ejecutar el script Python dentro de Minikube."
    exit 1
fi
