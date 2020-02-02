FROM nginx:latest

RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd

RUN echo 'root:THEPASSWORDYOUCREATED' | chpasswd
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

COPY startup.sh /usr/share/startup.sh
RUN chmod +x /usr/share/startup.sh

EXPOSE 22
EXPOSE 80
EXPOSE 443
ENTRYPOINT [ "/usr/share/startup.sh" ]