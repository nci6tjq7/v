FROM ubuntu

RUN apt-get update && apt-get install -y openssh-server unzip
RUN mkdir /var/run/sshd

RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip
RUN unzip ngrok-v3-stable-linux-amd64.zip
RUN ./ngrok config add-authtoken 2GaBOXAOVNvEYSCebdH3bUDueMZ_73DtFN8bC6uJEkKusfDCi

RUN echo 'root:passw0rd' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN echo '/usr/sbin/sshd && ./ngrok tcp 22 --log=stdout' > start.sh
run chmod +x start.sh
RUN set -x


CMD ["sh", "./start.sh"]
