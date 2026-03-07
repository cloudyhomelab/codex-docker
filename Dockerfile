ARG CODEX_VERSION="unknown"
ARG JAVA_VERSION="unknown"

FROM node:trixie-slim AS base-installer
ARG CODEX_VERSION

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    maven \
    ncurses-term \
    ripgrep \
    terminfo \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g @openai/codex@"${CODEX_VERSION}"

RUN useradd -m -s /bin/bash codex
USER codex
WORKDIR /home/codex

RUN curl -fsSL "https://get.sdkman.io?ci=true&rcupdate=false" | bash


FROM base-installer AS final
ARG JAVA_VERSION

USER codex

ENV SDKMAN_DIR="/home/codex/.sdkman"
RUN bash -c 'source "${SDKMAN_DIR}/bin/sdkman-init.sh" && sdk install java "${JAVA_VERSION}"'

ENV JAVA_HOME="${SDKMAN_DIR}/candidates/java/current"
ENV PATH="${JAVA_HOME}/bin:${PATH}"

ENTRYPOINT ["codex"]
