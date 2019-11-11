FROM jenkinsxio/builder-go

RUN wget https://go.kubebuilder.io/dl/2.1.0/linux/amd64 | tar -xz -C /tmp/
RUN sudo mv /tmp/kubebuilder_2.1.0_linux_amd64 /usr/local/kubebuilder

RUN export PATH=$PATH:/usr/local/kubebuilder/bin

