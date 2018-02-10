FROM centos:7.3.1611

ENV gotty_version=v0.0.13
ENV k8comp_version=0.6.1-rc2

RUN yum clean all && \
    yum install ed git ruby -y && \
    gem install --no-ri --no-rdoc hiera-eyaml hiera && \
    yum clean all && \
    curl -L https://github.com/yudai/gotty/releases/download/${gotty_version}/gotty_linux_amd64.tar.gz > /gotty.tar.gz && \
    tar -xf /gotty.tar.gz -C / && \
    chmod +x /gotty && \

    curl -L https://github.com/cststack/k8comp/releases/download/${k8comp_version}/k8comp.tar.gz > /opt/k8comp.tar.gz && \
    tar -xvf /opt/k8comp.tar.gz -C /opt/ && \

    chmod +x -R /opt/k8comp/bin/ && \
    ln -sfn /opt/k8comp/bin/k8comp /bin/k8comp && \

    rm -rf /opt/k8comp.tar.gz /gotty.tar.gz

ADD configs/ssh/config /root/.ssh/config
ENV TERM xterm

CMD ["/gotty", "-w", "/bin/bash"]
