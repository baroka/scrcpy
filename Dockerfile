# build:
#  docker build -t baroka/scrcpy .

FROM ubuntu:latest

WORKDIR /scrcpy

# Install packages
RUN apt-get update && apt-get install -y scrcpy && \
    apt-get clean

# Timezone (no prompt)
ARG TZ "Europe/Madrid"
ENV tz=$TZ
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
RUN echo "$tz" > /etc/timezone
RUN rm -f /etc/localtime
#RUN dpkg-reconfigure -f noninteractive tzdata

# Copy script
COPY otp_get.sh .
RUN chmod a+x otp_get.sh

# Run the command on container startup
ENTRYPOINT ["/scrcpy/otp_get.sh"]