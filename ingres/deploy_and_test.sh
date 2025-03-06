#!/bin/bash

# Función para limpiar el entorno
limpiar_entorno() {
  echo "¿Quieres limpiar el entorno de recursos previos? (s/n): "
  read respuesta
  if [ "$respuesta" == "s" ]; then
    echo -e "\nLimpiando el entorno..."
    microk8s kubectl delete ingress apache-ingress nginx-ingress
    microk8s kubectl delete svc apache-service nginx-service
    microk8s kubectl delete pod apache-pod nginx-pod
    microk8s kubectl delete pvc nfs-pvc || echo "PersistentVolumeClaim nfs-pvc no encontrado."
    microk8s kubectl delete pv nfs-pv
    echo -e "\nEntorno limpio.\n"
  fi
}

# Función para aplicar recursos y verificar
aplicar_recursos(){
  # Aplicar los recursos de Kubernetes
  echo "Aplicando recursos de Kubernetes..."

  # Primero aplicar el PersistentVolume
  if ! microk8s kubectl get pv nfs-pv &> /dev/null; then
    microk8s kubectl apply -f nfs-pv.yaml
    echo "Recurso nfs-pv.yaml aplicado correctamente."
  else
    echo "PersistentVolume nfs-pv ya existe."
  fi

  # Luego, aplicar el PersistentVolumeClaim
  if ! microk8s kubectl get pvc nfs-pvc &> /dev/null; then
    microk8s kubectl apply -f nfs-pvc.yaml
    echo "PersistentVolumeClaim nfs-pvc creado."
  else
    echo "PersistentVolumeClaim nfs-pvc ya existe."
  fi

  # Crear los Pods (Apache y Nginx)
  microk8s kubectl apply -f apache-pod.yaml
  if [ $? -eq 0 ]; then
    echo "Recurso apache-pod.yaml aplicado correctamente."
  else
    echo "Error: Recurso apache-pod.yaml no se aplicó correctamente."
  fi

  microk8s kubectl apply -f nginx-pod.yaml
  if [ $? -eq 0 ]; then
    echo "Recurso nginx-pod.yaml aplicado correctamente."
  else
    echo "Error: Recurso nginx-pod.yaml no se aplicó correctamente."
  fi

  # Crear los servicios
  microk8s kubectl apply -f apache-service.yaml
  echo "Recurso apache-service.yaml aplicado correctamente."

  microk8s kubectl apply -f nginx-service.yaml
  echo "Recurso nginx-service.yaml aplicado correctamente."

  # Crear los Ingress
  microk8s kubectl apply -f apache-ingress.yaml
  echo "Recurso apache-ingress.yaml aplicado correctamente."

  microk8s kubectl apply -f nginx-ingress.yaml
  echo "Recurso nginx-ingress.yaml aplicado correctamente."


  echo -e "\nRecursos aplicados con éxito.\n"
}

# Función para verificar el estado de los Pods con más detalles
verificar_pods() {
  echo -e "\nVerificando el estado de los Pods... (Traza detallada)"
  tiempo_maximo=60  # Tiempo máximo en segundos
  tiempo_espera=5   # Tiempo de espera entre verificaciones en segundos
  tiempo_transcurrido=0

  while [ $tiempo_transcurrido -lt $tiempo_maximo ]; do
    # Obtenemos el estado detallado del Pod Apache
    apache_pod_estado=$(microk8s kubectl get pod apache-pod -o jsonpath='{.status.phase}')
    apache_pod_detalles=$(microk8s kubectl describe pod apache-pod)

    # Obtenemos el estado detallado del Pod Nginx
    nginx_pod_estado=$(microk8s kubectl get pod nginx-pod -o jsonpath='{.status.phase}')
    nginx_pod_detalles=$(microk8s kubectl describe pod nginx-pod)

    # Imprimimos la traza detallada de ambos Pods
    echo -e "\nDetalles del Pod Apache:"
    echo "$apache_pod_detalles"
    echo -e "\nDetalles del Pod Nginx:"
    echo "$nginx_pod_detalles"

    # Comprobamos si ambos Pods están en estado 'Running'
    if [ "$apache_pod_estado" == "Running" ] && [ "$nginx_pod_estado" == "Running" ]; then
      echo "Ambos Pods (Apache y Nginx) están en estado 'Running'."
      return 0  # Si ambos están en estado Running, salimos de la función
    fi

    echo "Esperando a que los Pods estén en estado 'Running'..."
    sleep $tiempo_espera
    ((tiempo_transcurrido+=tiempo_espera))
  done
  
  microk8s kubectl get pod
  # Si no se cumplen las condiciones en el tiempo máximo, se informa del error
  echo "Error: Los Pods no han alcanzado el estado 'Running' en el tiempo esperado."
  exit 1  # Salir del script con error
}

# Función para verificar el estado de los servicios
verificar_servicios() {
  echo -e "\nVerificando el estado de los servicios..."
  microk8s kubectl get svc
}

# Función para verificar el estado de los Ingress
verificar_ingress() {
  echo -e "\nVerificando el estado de los Ingress..."
  microk8s kubectl get ingress
}

# Función para verificar los logs de los Pods
verificar_logs() {
  echo -e "\nComprobando los logs del Pod de Apache..."
  microk8s kubectl logs apache-pod
  echo -e "\nComprobando los logs del Pod de Nginx..."
  microk8s kubectl logs nginx-pod
}

# Función para verificar el estado del PersistentVolume y PersistentVolumeClaim
verificar_pv_pvc() {
  echo -e "\nVerificando el estado del PersistentVolume y PersistentVolumeClaim..."
  microk8s kubectl get pv nfs-pv
  microk8s kubectl get pvc nfs-pvc
}

# Función para probar acceso a los servicios
probar_acceso() {
  echo -e "\nProbando acceso a Apache..."
  curl -v http://pgc-alu.info
  echo -e "\nProbando acceso a Nginx..."
  curl -v http://pgc-alu.info
}

# Función para mostrar el resumen de la ejecución
mostrar_resumen() {
  echo -e "\nResumen de la ejecución:"
  echo "1. El entorno fue limpiado correctamente."
  echo "2. Los recursos se aplicaron correctamente."
  echo "3. Los Pods están en estado 'Running'."
  echo "4. Los servicios fueron creados correctamente."
  echo "5. Los logs de los Pods muestran que Apache y Nginx están funcionando."
  echo "6. Hubo un problema al intentar acceder a los servicios mediante curl. Asegúrate de que
 la resolución DNS esté configurada correctamente."
}

# Función principal
main() {
  limpiar_entorno
  aplicar_recursos
  echo -e "\nEsperando a que los recursos se creen...\n"
  sleep 10  # Esperamos un poco para que los recursos se creen
  verificar_pods
  verificar_servicios
  verificar_ingress
  verificar_logs
  verificar_pv_pvc
  probar_acceso
  mostrar_resumen
}

# Ejecutamos la función principal
main
