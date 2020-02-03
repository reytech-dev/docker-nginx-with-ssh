FROM nginx:latest

# args
ARG PUB_SSH_KEY
ARG USER

# env
ENV USER="${USER}"
ENV UID=1001
ENV GID=1001
ENV NOTVISIBLE "in users profile"

# small startup wrapper to start nginx & ssh
COPY startup.sh /usr/share/startup.sh

# install ssh, create new user, configure ssh, configue startup wrapper
RUN apt-get update && \
    apt-get install --no-install-recommends -y openssh-server && \
    mkdir /var/run/sshd && \
    addgroup --gid "${GID}" "${USER}" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --ingroup "${USER}" \
    --uid "${UID}" \
    "${USER}" && \
    sed -i 's;#AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2;AuthorizedKeysFile     .ssh/authorized_keys;' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \
    mkdir -p "/home/${USER}/.ssh" && \
    echo "${PUB_SSH_KEY}" > "/home/$USER/.ssh/authorized_keys" && \
    # SSH login fix. Otherwise user is kicked off after login
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
    chmod +x /usr/share/startup.sh && \
    rm -rf /var/lib/apt/lists/*

# expose ports
EXPOSE 22
EXPOSE 80
EXPOSE 443

# start services
ENTRYPOINT [ "/usr/share/startup.sh" ]