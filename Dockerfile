FROM debian:buster

WORKDIR /root

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY setup.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/setup.sh"]