FROM --platform=linux/amd64 ruby:2.4.3

WORKDIR /app

RUN printf '%s\n' \
      'deb http://archive.debian.org/debian jessie main' \
      'deb http://archive.debian.org/debian-security jessie/updates main' \
      > /etc/apt/sources.list \
    && printf 'Acquire::Check-Valid-Until "false";\n' > /etc/apt/apt.conf.d/99no-check-valid \
    && apt-get update && apt-get install -y --force-yes --no-install-recommends \
      build-essential \
      libxml2-dev \
      libxslt1-dev \
      git \
    && rm -rf /var/lib/apt/lists/*

ENV BUNDLER_VERSION=2.2.33

RUN gem uninstall -aIx bundler 2>/dev/null || true \
    && gem install bundler -v '2.2.33'

CMD ["bash"]
