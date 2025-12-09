FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LIBVA_DRIVER_NAME=iHD
ENV LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri

RUN apt-get update && \
    apt-get install -y \
        handbrake-cli \
        intel-media-va-driver \
        intel-media-va-driver-non-free \
        intel-opencl-icd \
        i965-va-driver \
        libmfx1 \
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
