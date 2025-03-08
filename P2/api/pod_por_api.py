import sys
import yaml
import subprocess
import time
from kubernetes import client, config
from kubernetes.client.rest import ApiException

def log(message):
    """Función para imprimir mensajes de depuración con formato claro."""
    print(f"[DEBUG] {message}\n")

def load_k8s_config():
    """Cargar la configuración de Kubernetes desde el archivo config.yaml"""
    log("Entrando en load_k8s_config")
    try:
        with open("config.yaml", "r") as file:
            config_data = yaml.safe_load(file)
        
        host = config_data.get("host")
        token = config_data.get("token")
        
        log(f"Host configurado: {host}")
        log(f"Token recibido: {'OK' if token else 'NO DISPONIBLE'}")
        
        configuration = client.Configuration()
        configuration.host = host
        configuration.verify_ssl = False
        configuration.debug = False
        configuration.api_key = {"authorization": "Bearer " + token}
        
        log("Configuración de Kubernetes cargada correctamente")
        return configuration
    except Exception as e:
        log(f"Error en load_k8s_config: {e}")
        sys.exit(1)

def create_pv_and_pvc(api):
    """Crear PersistentVolume (PV) y PersistentVolumeClaim (PVC) usando la API de Kubernetes."""
    log("Entrando en create_pv_and_pvc")
    
    pv_manifest = client.V1PersistentVolume(
        metadata=client.V1ObjectMeta(name="nfs-pv"),
        spec=client.V1PersistentVolumeSpec(
            capacity={"storage": "1Gi"},
            volume_mode="Filesystem",
            access_modes=["ReadWriteOnce"],
            persistent_volume_reclaim_policy="Retain",
            storage_class_name="manual",
            host_path=client.V1HostPathVolumeSource(path="/mnt/data")
        )
    )
    
    pvc_manifest = client.V1PersistentVolumeClaim(
        metadata=client.V1ObjectMeta(name="nfs-pvc"),
        spec=client.V1PersistentVolumeClaimSpec(
            access_modes=["ReadWriteOnce"],
            resources=client.V1ResourceRequirements(requests={"storage": "1Gi"}),
            storage_class_name="manual"
        )
    )
    
    try:
        api.create_persistent_volume(body=pv_manifest)
        log("PersistentVolume creado correctamente")
    except ApiException as e:
        log(f"Error al crear PersistentVolume: {e}")
    
    try:
        api.create_namespaced_persistent_volume_claim(namespace="default", body=pvc_manifest)
        log("PersistentVolumeClaim creado correctamente")
    except ApiException as e:
        log(f"Error al crear PersistentVolumeClaim: {e}")

def create_pod(api, file_path):
    """Crear un Pod que ejecute el comando wc en el archivo proporcionado."""
    log("Entrando en create_pod")
    
    cont_name = "alpine-wc-container"
    cont_image = "alpine:latest"
    command = ["/bin/sh", "-c", f"wc {file_path}"]
    
    container = client.V1Container(
        name=cont_name,
        image=cont_image,
        command=command
    )
    
    pod_manifest = client.V1Pod(
        metadata=client.V1ObjectMeta(name="alpine-wc-pod"),
        spec=client.V1PodSpec(
            containers=[container],
            restart_policy="Never",
            volumes=[client.V1Volume(
                name="nfs-volume",
                persistent_volume_claim=client.V1PersistentVolumeClaimVolumeSource(
                    claim_name="nfs-pvc"
                )
            )]
        ),
    )
    
    try:
        api.create_namespaced_pod(namespace="default", body=pod_manifest)
        log("Pod creado correctamente")
    except ApiException as e:
        log(f"Error al crear el Pod: {e}")

def get_pod_logs(api):
    """Esperar a que el Pod termine y obtener los logs."""
    log("Entrando en get_pod_logs")
    
    while True:
        pod = api.read_namespaced_pod(name="alpine-wc-pod", namespace="default")
        log(f"Estado actual del Pod: {pod.status.phase}")
        if pod.status.phase == "Succeeded":
            log("El Pod ha terminado exitosamente")
            break
        elif pod.status.phase == "Failed":
            log("El Pod ha fallado")
            break
        time.sleep(2)
    
    try:
        logs = api.read_namespaced_pod_log(name="alpine-wc-pod", namespace="default")
        log("Resultado del comando wc:")
        print(logs + "\n")
    except ApiException as e:
        log(f"Error al obtener los logs del Pod: {e}")

def main():
    log("Entrando en main")
    
    if len(sys.argv) != 2:
        log("Número incorrecto de argumentos. Uso: python pod_por_api.py <ruta_del_fichero>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    log(f"Archivo de entrada: {file_path}")
    
    configuration = load_k8s_config()
    api_client = client.ApiClient(configuration)
    api = client.CoreV1Api(api_client)
    
    create_pv_and_pvc(api)
    create_pod(api, file_path)
    get_pod_logs(api)
    
    log("Ejecución finalizada correctamente")

if __name__ == "__main__":
    main()
