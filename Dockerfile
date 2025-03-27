FROM alpine
ADD script.sh encrypt.sh ./

## Note: `pipx` requires Bash
RUN apk add --no-cache --update \
        python3 \
        py3-pip \
        bash \
        pipx \
        gpg \
        libqrencode-tools \
    && rm -rf ~/.cache/* /usr/local/share/man /tmp/*     
       
RUN pipx install bipsea && pipx ensurepath && pipx completions
