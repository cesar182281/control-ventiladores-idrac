FROM ubuntu:latest

RUN apt-get update
RUN apt-get install ipmitool -y

ADD control-salud.sh /app/control-salud.sh
ADD control-ventiladores-idrac.sh /app/control-ventiladores-idrac.sh

RUN chmod +x /app/control-salud.sh /app/control-ventiladores-idrac.sh

WORKDIR /app

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "/app/control-salud.sh" ]

ENV IDRAC_IP 192.168.0.120
ENV IDRAC_USER root
ENV IDRAC_PASSWORD calvin
ENV FAN_SPEED 5
ENV MAX_TEMP_AMBIENT 40
ENV CHECK_INTERVAL 10

ENTRYPOINT ["./control-ventiladores-idrac.sh"]