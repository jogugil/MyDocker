#!/bin/bash

# Namespace y ServiceAccounts
namespaces=("desarrollo" "produccion")
serviceaccounts=("admin" "devel" "prod")

# Validaciones para el namespace 'desarrollo'
echo "### Validaciones para el namespace 'desarrollo' ###"

# Comprobaciones para cada cuenta de servicio
for sa in "${serviceaccounts[@]}"; do
  echo "Verificando permisos de la cuenta de servicio $sa en 'desarrollo'..."

  kubectl auth can-i create pods --as=system:serviceaccount:default:$sa -n desarrollo
  kubectl auth can-i list pods --as=system:serviceaccount:default:$sa -n desarrollo
  kubectl auth can-i update pods --as=system:serviceaccount:default:$sa -n desarrollo
  kubectl auth can-i delete pods --as=system:serviceaccount:default:$sa -n desarrollo
  kubectl auth can-i create deployments --as=system:serviceaccount:default:$sa -n desarrollo
  kubectl auth can-i list deployments --as=system:serviceaccount:default:$sa -n desarrollo
  kubectl auth can-i update deployments --as=system:serviceaccount:default:$sa -n desarrollo
  kubectl auth can-i delete deployments --as=system:serviceaccount:default:$sa -n desarrollo
  kubectl auth can-i create services --as=system:serviceaccount:default:$sa -n desarrollo
  kubectl auth can-i list services --as=system:serviceaccount:default:$sa -n desarrollo
  kubectl auth can-i update services --as=system:serviceaccount:default:$sa -n desarrollo
  kubectl auth can-i delete services --as=system:serviceaccount:default:$sa -n desarrollo

  echo ""
done

# Validaciones para el namespace 'produccion'
echo "### Validaciones para el namespace 'produccion' ###"

# Comprobaciones para cada cuenta de servicio
for sa in "${serviceaccounts[@]}"; do
  echo "Verificando permisos de la cuenta de servicio $sa en 'produccion'..."

  kubectl auth can-i create pods --as=system:serviceaccount:default:$sa -n produccion
  kubectl auth can-i list pods --as=system:serviceaccount:default:$sa -n produccion
  kubectl auth can-i update pods --as=system:serviceaccount:default:$sa -n produccion
  kubectl auth can-i delete pods --as=system:serviceaccount:default:$sa -n produccion
  kubectl auth can-i create deployments --as=system:serviceaccount:default:$sa -n produccion
  kubectl auth can-i list deployments --as=system:serviceaccount:default:$sa -n produccion
  kubectl auth can-i update deployments --as=system:serviceaccount:default:$sa -n produccion
  kubectl auth can-i delete deployments --as=system:serviceaccount:default:$sa -n produccion
  kubectl auth can-i create services --as=system:serviceaccount:default:$sa -n produccion
  kubectl auth can-i list services --as=system:serviceaccount:default:$sa -n produccion
  kubectl auth can-i update services --as=system:serviceaccount:default:$sa -n produccion
  kubectl auth can-i delete services --as=system:serviceaccount:default:$sa -n produccion

  echo ""
done

# Validaciones para permisos globales (todos los namespaces)
echo "### Validaciones para todos los namespaces ###"

# Comprobaciones para la cuenta admin en todos los namespaces
for sa in "admin"; do
  echo "Verificando permisos globales de la cuenta de servicio $sa..."

  kubectl auth can-i create pods --as=system:serviceaccount:default:$sa --all-namespaces
  kubectl auth can-i list pods --as=system:serviceaccount:default:$sa --all-namespaces
  kubectl auth can-i update pods --as=system:serviceaccount:default:$sa --all-namespaces
  kubectl auth can-i delete pods --as=system:serviceaccount:default:$sa --all-namespaces
  kubectl auth can-i create deployments --as=system:serviceaccount:default:$sa --all-namespaces
  kubectl auth can-i list deployments --as=system:serviceaccount:default:$sa --all-namespaces
  kubectl auth can-i update deployments --as=system:serviceaccount:default:$sa --all-namespaces
  kubectl auth can-i delete deployments --as=system:serviceaccount:default:$sa --all-namespaces
  kubectl auth can-i create services --as=system:serviceaccount:default:$sa --all-namespaces
  kubectl auth can-i list services --as=system:serviceaccount:default:$sa --all-namespaces
  kubectl auth can-i update services --as=system:serviceaccount:default:$sa --all-namespaces
  kubectl auth can-i delete services --as=system:serviceaccount:default:$sa --all-namespaces

  echo ""
done

# Listar todos los permisos para la cuenta admin
echo "### Listando permisos globales de la cuenta admin ###"
kubectl auth can-i --list --as=system:serviceaccount:default:admin --all-namespaces
