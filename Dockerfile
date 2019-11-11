FROM jenkinsxio/builder-go

RUN curl -sL https://go.kubebuilder.io/dl/2.1.0/linux/amd64 | tar -xz -C /tmp/ \
    && mv /tmp/kubebuilder_2.1.0_linux_amd64 /usr/local/kubebuilder \
    && export PATH=$PATH:/usr/local/kubebuilder/bin
ENV PATH $PATH:/usr/local/kubebuilder/bin

