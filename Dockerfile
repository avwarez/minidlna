FROM alpine:3.11
WORKDIR /app
RUN mkdir -p /usr/src && \
    apk add --no-cache git autoconf g++ ffmpeg-dev jpeg-dev sqlite-dev libexif-dev libid3tag-dev libogg-dev libvorbis-dev flac-dev make bsd-compat-headers
COPY . /usr/src/minidlna-git
#COPY minidlna-git /usr/src/minidlna-git
RUN cd /usr/src/minidlna-git && \
    ./configure --prefix=/app && \
    make && \
    make install

FROM alpine:3.11
ENV HOME=/app
ENV CONFIG_FILE=/config/minidlna.conf
WORKDIR /app
COPY --from=0 /app/sbin /usr/local/sbin/
RUN apk add --no-cache ffmpeg-libs libjpeg sqlite-libs libexif libid3tag libogg libvorbis flac && \
    mkdir /config && \
    mkdir -p /var/cache/minidlna
CMD /usr/local/sbin/minidlnad -d -f $CONFIG_FILE
