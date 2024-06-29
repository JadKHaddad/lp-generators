FROM ubuntu:latest

RUN apt-get update && apt-get install -y openssh-server pkg-config zlib1g-dev libbz2-dev coinor-clp coinor-libclp-dev coinor-libosi-dev python3 python3-pip python3-venv

WORKDIR /home/app

COPY . .

RUN pip3 install -r build-requirements.txt

RUN pip3 install .

RUN pip3 install .[scripts,analysis]

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN useradd -p $(openssl passwd -1 mCdmmsUlKhPX) -m ssh_user
 
ENTRYPOINT service ssh restart && bash

# docker build -t lp-gen . 
# docker run -it --rm lp-gen