FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install git python3 python3-pip sudo locales gnupg curl libsnmp-dev \
    autoconf bison patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev \
    zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev \
    openjdk-11-jre-headless cmake lsb-release \
    && locale-gen en_US.UTF-8 \
    && curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" > /etc/apt/sources.list.d/redis.list \
    && apt-get update \
    && apt-get -y install redis

ENV RUBY_VERSION 3.1.2
RUN mkdir /ruby
WORKDIR /ruby
RUN curl --retry 3 -fL "https://github.com/rbenv/ruby-build/archive/refs/tags/v20230208.1.tar.gz" | tar zxf -
RUN PREFIX=/usr/local ./ruby-build-*/install.sh
RUN ruby-build ${RUBY_VERSION} /usr/local

ENV MONGODB_VERSION 6.0.4
RUN mkdir /mongodb
WORKDIR /mongodb
RUN curl --retry 3 -fL "https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-ubuntu2204-${MONGODB_VERSION}.tgz" | tar zxf -
RUN find . -path '*bin*' -name 'mongo*' -exec cp {} /usr/bin \;

ENV MONGOSH_VERSION 1.6.2
RUN mkdir -p ${HOME}/mongosh
WORKDIR ${HOME}/mongosh
RUN curl --retry 3 -fL https://github.com/mongodb-js/mongosh/releases/download/v${MONGOSH_VERSION}/mongosh-${MONGOSH_VERSION}-linux-x64.tgz | tar zxf -
RUN cp ./mongosh-${MONGOSH_VERSION}-linux-x64/bin/mongosh /usr/bin/ && sudo cp ./mongosh-${MONGOSH_VERSION}-linux-x64/bin/*.so /usr/lib/

RUN pip3 install 'mtools[mlaunch]'

RUN mkdir /mongo-ruby-driver
COPY mongo-ruby-driver/ /mongo-ruby-driver/
RUN mkdir /workspace
WORKDIR /workspace
COPY threadmill/Gemfile threadmill/Gemfile.lock ./
RUN bundle install
COPY threadmill/ .
EXPOSE 5100
CMD ["./entrypoint.sh"]
