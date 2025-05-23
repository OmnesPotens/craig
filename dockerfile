# Use an official Ubuntu base image
FROM node:18.20.5

# Install all required dependencies in advance, for performance
RUN apt-get update && \
    apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    # cook
    make inkscape ffmpeg flac vorbis-tools opus-tools zip \
    wget \
    # redis
    lsb-release curl gpg \
    ca-certificates redis redis-server redis-tools \
    # web
    postgresql \
    # install
    dbus-x11 sed coreutils build-essential python-setuptools \
    # Other dependencies
    sudo git vim locales && \
    # Cleanup
    apt-get -y autoremove
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

WORKDIR /app

# Copy all changes, particularly environment variables with discord API keys
COPY . .
# Run first-time setup for faster restarts

RUN scripts/buildCook.sh
RUN scripts/downloadCookBuilds.sh
RUN npm install -g pm2

RUN yarn install
RUN yarn prisma:generate
RUN yarn run build
RUN yarn run sync

# Expose app port
EXPOSE 3000
# Expose API port
EXPOSE 5029
# Start Craig
CMD ["sh", "-c", "/app/start_docker.sh"]


# Usage:

# Build:
# docker build -t craig .

# Run:
# docker run -i -p 3000:3000 -p 5029:5029 craig
