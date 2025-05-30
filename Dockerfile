FROM ubuntu:latest

RUN apt-get update
RUN apt-get install ipmitool -y

RUN mkdir -p /app
ADD control-salud.sh /app/control-salud.sh
ADD control-ventiladores-idrac.sh /app/control-ventiladores-idrac.sh

RUN chmod 0777 /app/control-salud.sh /app/control-ventiladores-idrac.sh

WORKDIR /app

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "/app/control-salud.sh" ]

ENV IDRAC_IP=[tu IP iDRAC]
ENV IDRAC_USER=root
ENV IDRAC_PASSWORD=calvin
ENV FAN_SPEED=10
ENV MAX_TEMP_AMBIENT=36
ENV CHECK_INTERVAL=300

ENTRYPOINT ["./control-ventiladores-idrac.sh"]
