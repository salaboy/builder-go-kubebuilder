#FROM jenkinsxio/builder-go

FROM gcr.io/jenkinsxio/builder-base:0.0.69

RUN curl -f -o /etc/yum.repos.d/vbatts-bazel-epel-7.repo  https://copr.fedorainfracloud.org/coprs/vbatts/bazel/repo/epel-7/vbatts-bazel-epel-7.repo \
  && yum install -y bazel \
  && yum clean all

ENV GOLANG_VERSION 1.13.4
RUN wget https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf go$GOLANG_VERSION.linux-amd64.tar.gz && \
  rm go${GOLANG_VERSION}.linux-amd64.tar.gz

ENV GLIDE_VERSION v0.13.1
ENV GO15VENDOREXPERIMENT 1
RUN wget https://github.com/Masterminds/glide/releases/download/$GLIDE_VERSION/glide-$GLIDE_VERSION-linux-amd64.tar.gz && \
  tar -xzf glide-$GLIDE_VERSION-linux-amd64.tar.gz && \
  mv linux-amd64 /usr/local/glide && \
  rm glide-$GLIDE_VERSION-linux-amd64.tar.gz

ENV DEP_VERSION v0.5.0
RUN wget https://github.com/golang/dep/releases/download/$DEP_VERSION/dep-linux-amd64 && chmod +x dep-linux-amd64 && \
  mv dep-linux-amd64 /usr/local/dep

ENV GH_RELEASE_VERSION 2.2.1
RUN wget https://github.com/progrium/gh-release/releases/download/v$GH_RELEASE_VERSION/gh-release_${GH_RELEASE_VERSION}_linux_x86_64.tgz && \
  tar -xzf gh-release_${GH_RELEASE_VERSION}_linux_x86_64.tgz && \
  mv gh-release /usr/local/gh-release && \
  rm gh-release_${GH_RELEASE_VERSION}_linux_x86_64.tgz

ENV PROTOBUF 3.5.1
RUN wget https://github.com/google/protobuf/releases/download/v${PROTOBUF}/protoc-${PROTOBUF}-linux-x86_64.zip && \
  unzip protoc-${PROTOBUF}-linux-x86_64.zip -d protoc && \
  chmod +x protoc && cp protoc/bin/protoc /usr/bin/protoc && rm -rf protoc

ENV PATH $PATH:/usr/local/go/bin
ENV PATH $PATH:/usr/local/glide
ENV PATH $PATH:/usr/local/dep
ENV PATH $PATH:/usr/local/
ENV GOROOT /usr/local/go
ENV GOPATH=/home/jenkins/go
ENV PATH $PATH:$GOPATH/bin
ENV HUGO_VERSION 0.58.0

RUN go get github.com/DATA-DOG/godog/cmd/godog && \
  mv $GOPATH/bin/godog /usr/local/ && \
# Hugo needs version of GLIBCXX that's not in Centros 7
# will have to download and compile
  curl -Lf -o hugo.zip https://github.com/gohugoio/hugo/archive/v${HUGO_VERSION}.zip && \
  unzip hugo.zip && \
  cd hugo-${HUGO_VERSION} && \
  GOBIN=/usr/local go install -tags extended && \
  cd .. && rm -fr hugo* && \
  hugo version && \
  go get github.com/derekparker/delve/cmd/dlv && \
  mv $GOPATH/bin/* /usr/local/ && \
#RUN go get github.com/golang/protobuf/proto && \
#  go get github.com/micro/protoc-gen-micro && \
#  go get github.com/golang/protobuf/protoc-gen-go && \ 
#  go get -u github.com/micro/micro && \
#  mv $GOPATH/bin/* /usr/local/ && \ 
#  cp -r $GOPATH/src/* /usr/local/go/src
# Gotestsum; nicer output for tests and converts go test output to junit xml
  go get gotest.tools/gotestsum && \
  mv $GOPATH/bin/gotestsum /usr/local/ && \
  go clean -cache -modcache && rm -rf $GOPATH/src/*

ENV JX_VERSION 2.0.974
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

RUN curl -sL https://go.kubebuilder.io/dl/2.1.0/linux/amd64 | tar -xz -C /tmp/ \
    && mv /tmp/kubebuilder_2.1.0_linux_amd64 /usr/local/kubebuilder \
    && export PATH=$PATH:/usr/local/kubebuilder/bin
ENV PATH $PATH:/usr/local/kubebuilder/bin

