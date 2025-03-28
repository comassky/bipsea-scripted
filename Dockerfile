# Use the official Python base image with Alpine
FROM python:alpine

# Set the working directory
WORKDIR /app

# Copy scripts
COPY bip85.sh decrypt.sh encrypt.sh /app/

# Install bash, gpg, gpg-agent, and other dependencies in a single RUN command
RUN apk update && \
    apk add --no-cache bash gpg gpg-agent libqrencode-tools file && \
    pip install bipsea
   # gpg-agent --daemon

# Set the default command to bash
CMD ["bash"]