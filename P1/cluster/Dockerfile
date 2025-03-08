FROM rastasheep/ubuntu-sshd:18.04
RUN apt-get update
RUN apt-get install -y openmpi-bin libopenmpi-dev vim
RUN useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' 'usupass22') usuario
RUN chsh -s /bin/bash usuario
RUN mkdir /home/usuario/.ssh
COPY id_rsa id_rsa.pub config /home/usuario/.ssh/
COPY id_rsa id_rsa.pub config /home/usuario/.ssh/
RUN cp /home/usuario/.ssh/id_rsa.pub /home/usuario/.ssh/authorized_keys
RUN chown usuario.usuario -R /home/usuario/.ssh
RUN mpicc -o /home/usuario/hola_mpi /home/usuario/hola_mpi.c
RUN chown usuario.usuario /home/usuario/hola_mpi*
RUN chown usuario.usuario /home/usuario/.ssh/authorized_keys
RUN chmod 600 /home/usuario/.ssh/authorized_keys
RUN chmod 644 /home/usuario/.ssh/id_rsa.pub /home/usuario/.ssh/authorized_keys
CMD /usr/sbin/sshd -D