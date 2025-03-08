import subprocess
import base64
import os
import sys

def obtener_token():
    # Ejecutar kubectl para obtener el token decodificado directamente
    token_secret = subprocess.getoutput("kubectl -n kube-system get secret bootstrap-token-mzua0t -o=jsonpath='{.data.token}'")

    if not token_secret:
        print("No se encontró un token válido.")
        sys.exit(1)

    # Decodificar el token
    decoded_token = base64.b64decode(token_secret).decode('utf-8')
    print(f"Token decodificado: {decoded_token}")  # Depuración
    return decoded_token

def guardar_kubeconfig(token):
    # Crear archivo kubeconfig
    kubeconfig_content = f"""
apiVersion: v1
clusters:
- cluster:
    server: https://127.0.0.1:32776  # URL del servidor API de Minikube
    certificate-authority-data: <CERTIFICATE_AUTHORITY_DATA>  # Reemplazar con el certificado adecuado si es necesario
  name: minikube
contexts:
- context:
    cluster: minikube
    user: minikube-user
  name: minikube-context
current-context: minikube-context
kind: Config
preferences: {{}}
users:
- name: minikube-user
  user:
    token: {token}
"""

    # Escribir el archivo kubeconfig
    kubeconfig_path = os.path.expanduser("~/.kube/config")
    with open(kubeconfig_path, "w") as f:
        f.write(kubeconfig_content)
    print(f"Kubeconfig guardado en {kubeconfig_path}")

def ejecutar_script_python(fichero):
    # Ejecutar el script Python pasando el archivo como argumento
    comando = f"python3 pod_por_api.py {fichero}"
    subprocess.run(comando, shell=True, check=True)
    print("Script ejecutado exitosamente")

def main():
    # Verificar que se pasa un argumento para el fichero
    if len(sys.argv) != 2:
        print("Uso: python setup_k8s.py <ruta_del_fichero>")
        sys.exit(1)

    ruta_fichero = sys.argv[1]

    # Obtener el token de Kubernetes
    token = obtener_token()

    # Guardar el kubeconfig con el token
    guardar_kubeconfig(token)

    # Ejecutar el script Python
    ejecutar_script_python(ruta_fichero)

if __name__ == "__main__":
    main()
