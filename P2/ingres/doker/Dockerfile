# Usar la imagen base de Alpine con Python 3.7
FROM python:3.7-alpine

# Instalar dependencias necesarias para compilar y ejecutar Jupyter
RUN apk add --no-cache \
    gcc \
    musl-dev \
    linux-headers \
    libffi-dev \
    && pip install --no-cache-dir notebook \
    && apk del gcc musl-dev linux-headers libffi-dev

# Crear un usuario sin privilegios
RUN adduser -D usuario

# Establecer el directorio de trabajo y la variable HOME
WORKDIR /home/usuario
ENV HOME /home/usuario

# Exponer el puerto 8888 para que Jupyter sea accesible
EXPOSE 8888

# Cambiar al usuario sin privilegios
USER usuario

# Configuración de Jupyter para que no pida autenticación
RUN mkdir -p /home/usuario/.jupyter && \
    echo "c.NotebookApp.token = ''" >> /home/usuario/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.password = ''" >> /home/usuario/.jupyter/jupyter_notebook_config.py

# Iniciar Jupyter Notebook en el contenedor
CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--port", "8888", "--no-browser"]