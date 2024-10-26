FROM ruby:3.2-slim

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
    fonts-noto-color-emoji \ 
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
    libx11-dev \
    libxtst-dev \
    x11-utils \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.5.21

WORKDIR /app

COPY . .

RUN bundle install

ENV DISPLAY=:99

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD [ "bash" ]