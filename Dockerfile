FROM alpine:latest
RUN apk add --no-cache ffmpeg
RUN apk --no-cache add curl
ADD crontab.txt /crontab.txt
ADD savejpg.sh /savejpg.sh
ADD makevideo.sh /makevideo.sh
COPY entry.sh /entry.sh
RUN chmod 755 /savejpg.sh /makevideo.sh /entry.sh
RUN /usr/bin/crontab /crontab.txt
RUN mkdir -p /config/video
CMD ["/entry.sh"]