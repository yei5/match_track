# Devcontainer Dockerfile with Flutter (stable) preinstalled.
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    git \
    curl \
    unzip \
    xz-utils \
    zip \
    ca-certificates \
    wget \
    libglu1-mesa \
    libgtk-3-0 \
    libnotify4 \
    libnss3 \
    libxss1 \
    libasound2 \
    sudo \
  && rm -rf /var/lib/apt/lists/*

ENV FLUTTER_ROOT=/usr/local/flutter
ENV PATH="$FLUTTER_ROOT/bin:$FLUTTER_ROOT/bin/cache/dart-sdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Create a non-root vscode user matching Codespaces default
RUN groupadd --gid $USER_GID $USERNAME || true \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME || true \
  && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME

# Clone Flutter (stable) and pre-cache artifacts
RUN git clone https://github.com/flutter/flutter.git -b stable ${FLUTTER_ROOT} \
  && chown -R $USER_UID:$USER_GID ${FLUTTER_ROOT} || true

# Configure git safe.directory for non-root user
RUN su - $USERNAME -c "git config --global --add safe.directory ${FLUTTER_ROOT} || true"

USER $USERNAME

# Pre-cache web artifacts and enable web (run as non-root user)
RUN flutter --version || true
RUN flutter config --enable-web || true
RUN flutter precache --web || true

WORKDIR /workspaces/match_track

CMD ["/bin/bash"]
