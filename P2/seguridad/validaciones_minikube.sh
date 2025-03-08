#!/bin/bash

# Namespace y ServiceAccounts
namespaces=("desarrollo" "produccion")
serviceaccounts=("admin" "devel" "prod")

# Validaciones para el namespace 'desarrollo'
echo "### Validaciones para el namespace 'desarrollo' ###"

# Comprobaciones para cada cuenta de servicio
for sa in "${serviceaccounts[@]}"; do
  echo "Verificando permisos de la cuenta de servicio $sa en 'desarrollo'..."
  
  echo "¿La cuenta de servicio $sa tiene permiso para crear pods en 'desarrollo'?"
  minikube kubectl -- auth can-i create pods --as=system:serviceaccount:default:$sa -n desarrollo
  echo "¿La cuenta de servicio $sa tiene permiso para listar pods en 'desarrollo'?"
  minikube kubectl -- auth can-i list pods --as=system:serviceaccount:default:$sa -n desarrollo
  echo "¿La cuenta de servicio $sa tiene permiso para actualizar pods en 'desarrollo'?"
  minikube kubectl -- auth can-i update pods --as=system:serviceaccount:default:$sa -n desarrollo
  echo "¿La cuenta de servicio $sa tiene permiso para eliminar pods en 'desarrollo'?"
  minikube kubectl -- auth can-i delete pods --as=system:serviceaccount:default:$sa -n desarrollo
  echo "¿La cuenta de servicio $sa tiene permiso para crear deployments en 'desarrollo'?"
  minikube kubectl -- auth can-i create deployments --as=system:serviceaccount:default:$sa -n desarrollo
  echo "¿La cuenta de servicio $sa tiene permiso para listar deployments en 'desarrollo'?"
  minikube kubectl -- auth can-i list deployments --as=system:serviceaccount:default:$sa -n desarrollo
  echo "¿La cuenta de servicio $sa tiene permiso para actualizar deployments en 'desarrollo'?"
  minikube kubectl -- auth can-i update deployments --as=system:serviceaccount:default:$sa -n desarrollo
  echo "¿La cuenta de servicio $sa tiene permiso para eliminar deployments en 'desarrollo'?"
  minikube kubectl -- auth can-i delete deployments --as=system:serviceaccount:default:$sa -n desarrollo
  echo "¿La cuenta de servicio $sa tiene permiso para crear services en 'desarrollo'?"
  minikube kubectl -- auth can-i create services --as=system:serviceaccount:default:$sa -n desarrollo
  echo "¿La cuenta de servicio $sa tiene permiso para listar services en 'desarrollo'?"
  minikube kubectl -- auth can-i list services --as=system:serviceaccount:default:$sa -n desarrollo
  echo "¿La cuenta de servicio $sa tiene permiso para actualizar services en 'desarrollo'?"
  minikube kubectl -- auth can-i update services --as=system:serviceaccount:default:$sa -n desarrollo
  echo "¿La cuenta de servicio $sa tiene permiso para eliminar services en 'desarrollo'?"
  minikube kubectl -- auth can-i delete services --as=system:serviceaccount:default:$sa -n desarrollo

  echo ""
done

# Validaciones para el namespace 'produccion'
echo "### Validaciones para el namespace 'produccion' ###"

# Comprobaciones para cada cuenta de servicio
for sa in "${serviceaccounts[@]}"; do
  echo "Verificando permisos de la cuenta de servicio $sa en 'produccion'..."
  
  echo "¿La cuenta de servicio $sa tiene permiso para crear pods en 'produccion'?"
  minikube kubectl -- auth can-i create pods --as=system:serviceaccount:default:$sa -n produccion
  echo "¿La cuenta de servicio $sa tiene permiso para listar pods en 'produccion'?"
  minikube kubectl -- auth can-i list pods --as=system:serviceaccount:default:$sa -n produccion
  echo "¿La cuenta de servicio $sa tiene permiso para actualizar pods en 'produccion'?"
  minikube kubectl -- auth can-i update pods --as=system:serviceaccount:default:$sa -n produccion
  echo "¿La cuenta de servicio $sa tiene permiso para eliminar pods en 'produccion'?"
  minikube kubectl -- auth can-i delete pods --as=system:serviceaccount:default:$sa -n produccion
  echo "¿La cuenta de servicio $sa tiene permiso para crear deployments en 'produccion'?"
  minikube kubectl -- auth can-i create deployments --as=system:serviceaccount:default:$sa -n produccion
  echo "¿La cuenta de servicio $sa tiene permiso para listar deployments en 'produccion'?"
  minikube kubectl -- auth can-i list deployments --as=system:serviceaccount:default:$sa -n produccion
  echo "¿La cuenta de servicio $sa tiene permiso para actualizar deployments en 'produccion'?"
  minikube kubectl -- auth can-i update deployments --as=system:serviceaccount:default:$sa -n produccion
  echo "¿La cuenta de servicio $sa tiene permiso para eliminar deployments en 'produccion'?"
  minikube kubectl -- auth can-i delete deployments --as=system:serviceaccount:default:$sa -n produccion
  echo "¿La cuenta de servicio $sa tiene permiso para crear services en 'produccion'?"
  minikube kubectl -- auth can-i create services --as=system:serviceaccount:default:$sa -n produccion
  echo "¿La cuenta de servicio $sa tiene permiso para listar services en 'produccion'?"
  minikube kubectl -- auth can-i list services --as=system:serviceaccount:default:$sa -n produccion
  echo "¿La cuenta de servicio $sa tiene permiso para actualizar services en 'produccion'?"
  minikube kubectl -- auth can-i update services --as=system:serviceaccount:default:$sa -n produccion
  echo "¿La cuenta de servicio $sa tiene permiso para eliminar services en 'produccion'?"
  minikube kubectl -- auth can-i delete services --as=system:serviceaccount:default:$sa -n produccion

  echo ""
done

# Validaciones para permisos globales (todos los namespaces)
echo "### Validaciones para todos los namespaces ###"

# Comprobaciones para la cuenta admin en todos los namespaces
for sa in "admin"; do
  echo "Verificando permisos globales de la cuenta de servicio $sa..."

  echo "¿La cuenta de servicio $sa tiene permiso para crear pods globalmente?"
  minikube kubectl -- auth can-i create pods --as=system:serviceaccount:default:$sa --all-namespaces
  echo "¿La cuenta de servicio $sa tiene permiso para listar pods globalmente?"
  minikube kubectl -- auth can-i list pods --as=system:serviceaccount:default:$sa --all-namespaces
  echo "¿La cuenta de servicio $sa tiene permiso para actualizar pods globalmente?"
  minikube kubectl -- auth can-i update pods --as=system:serviceaccount:default:$sa --all-namespaces
  echo "¿La cuenta de servicio $sa tiene permiso para eliminar pods globalmente?"
  minikube kubectl -- auth can-i delete pods --as=system:serviceaccount:default:$sa --all-namespaces
  echo "¿La cuenta de servicio $sa tiene permiso para crear deployments globalmente?"
  minikube kubectl -- auth can-i create deployments --as=system:serviceaccount:default:$sa --all-namespaces
  echo "¿La cuenta de servicio $sa tiene permiso para listar deployments globalmente?"
  minikube kubectl -- auth can-i list deployments --as=system:serviceaccount:default:$sa --all-namespaces
  echo "¿La cuenta de servicio $sa tiene permiso para actualizar deployments globalmente?"
  minikube kubectl -- auth can-i update deployments --as=system:serviceaccount:default:$sa --all-namespaces
  echo "¿La cuenta de servicio $sa tiene permiso para eliminar deployments globalmente?"
  minikube kubectl -- auth can-i delete deployments --as=system:serviceaccount:default:$sa --all-namespaces
  echo "¿La cuenta de servicio $sa tiene permiso para crear services globalmente?"
  minikube kubectl -- auth can-i create services --as=system:serviceaccount:default:$sa --all-namespaces
  echo "¿La cuenta de servicio $sa tiene permiso para listar services globalmente?"
  minikube kubectl -- auth can-i list services --as=system:serviceaccount:default:$sa --all-namespaces
  echo "¿La cuenta de servicio $sa tiene permiso para actualizar services globalmente?"
  minikube kubectl -- auth can-i update services --as=system:serviceaccount:default:$sa --all-namespaces
  echo "¿La cuenta de servicio $sa tiene permiso para eliminar services globalmente?"
  minikube kubectl -- auth can-i delete services --as=system:serviceaccount:default:$sa --all-namespaces

  echo ""
done

# Listar todos los permisos para la cuenta admin
echo "### Listando permisos globales de la cuenta admin ###"
for ns in "${namespaces[@]}"; do
  echo "¿La cuenta admin tiene permisos en el namespace $ns?"
  minikube kubectl -- auth can-i --list --as=system:serviceaccount:default:admin -n $ns
done
