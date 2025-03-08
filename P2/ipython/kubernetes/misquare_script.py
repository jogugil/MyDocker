# -*- coding: utf-8 -*-

import ipyparallel as ipp

# Conectar al cliente
c = ipp.Client('/root/.ipython/profile_default/security/ipcontroller-client.json')

# Verificar los IDs de los engines disponibles
print('IDs de los engines disponibles:', c.ids)

# Definir la función misquare
def misquare(x):
    return x * x

# Ejecutar la función misquare en paralelo
print("Ejecutando la función 'misquare' con los números del 0 al 3:")
l = c[:].map(misquare, range(4))

# Intentar obtener los resultados de todos los elementos
try:
    results = l.get(timeout=60)
    print("Resultados de la función 'misquare' para cada número en el rango 0-3:", results)
    print("Resultado para el primer elemento (l[1]):", results[1])
    print("Resultado para el tercer elemento (l[3]):", results[3])
except Exception as e:
    print("Error al obtener los resultados:", e)
