FROM ruby:3.2-slim

# Installer les dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    nano \
    xvfb \
    curl \
    git \
    bash \
    build-essential \
    libx11-xcb1 \
    libxcomposite1 \
    libxrandr2 \
    libxdamage1 \
    libjpeg62-turbo \
    libwebp-dev \
    udev \
    fonts-freefont-ttf \
    nodejs \
    npm \
    libxcursor1 \
    libgtk-3-0 \
    libpangocairo-1.0-0 \
    libcairo-gobject2 \
    libgdk-pixbuf2.0-0 \
    libgstreamer1.0-0 \
    libgstreamer-plugins-base1.0-0 \
    gstreamer1.0-gl \
    gstreamer1.0-libav \
    gstreamer1.0-plugins-bad \
    libxslt1.1 \
    libwoff1 \
    libvpx7 \
    libevent-2.1-7 \
    libopus0 \
    libsecret-1-0 \
    libenchant-2-2 \
    libharfbuzz-icu0 \
    libhyphen0 \
    libmanette-0.2-0 \
    libflite1 \
    libavcodec-extra \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Installer les gems nécessaires
RUN gem install ffi
RUN gem install bundler -v 2.5.21

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers Gemfile et Gemfile.lock séparément pour permettre la mise en cache
COPY . .

# Installer les dépendances Ruby via le bundle
RUN bundle install


# Créer le script de démarrage pour Xvfb
ENV DISPLAY=:99
RUN echo '#!/bin/sh' > /usr/local/bin/docker-entrypoint.sh && \
    echo 'if [ -f /tmp/.X99-lock ]; then rm -f /tmp/.X99-lock; fi' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'if ! pgrep -x "Xvfb" > /dev/null; then Xvfb :99 -screen 0 1920x1080x24 & fi' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'exec "$@"' >> /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

# Configurer le point d'entrée
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Commande par défaut pour démarrer une session shell
CMD [ "bash" ]


