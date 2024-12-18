# Use an official Ubuntu base image
FROM node:18.20.5

# Remove interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install all required dependencies in advance
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
    # cook
    make inkscape ffmpeg flac vorbis-tools opus-tools zip \
    wget \
    # redis
    lsb-release curl gpg \
    ca-certificates redis redis-server redis-tools \
    # web
    postgresql \
    # install
    sed coreutils build-essential \
    # Other dependencies
    sudo git vim && \
    # Cleanup
    apt-get -y autoremove

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
