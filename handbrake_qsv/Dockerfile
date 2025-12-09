FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        handbrake-cli \
        intel-media-va-driver \
        vainfo \
        inotify-tools \
        jq \
        ca-certificates \
        tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /config /input /output

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

VOLUME ["/config", "/input", "/output"]

CMD ["/usr/local/bin/run.sh"]
