FROM ubuntu:latest

RUN apt-get update && apt-get install -y openssh-server pkg-config zlib1g-dev libbz2-dev coinor-clp coinor-libclp-dev coinor-libosi-dev python3 python3-pip python3-venv

WORKDIR /home/app

COPY . .

RUN pip3 install -r build-requirements.txt

RUN pip3 install .

RUN pip3 install .[scripts,analysis]

RUN  useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 ubuntu && \
    echo 'ubuntu:mCdmmsUlKhPX' | chpasswd

RUN mkdir /var/run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

# docker build -t lp-gen . 
# docker run -it --rm lp-gen