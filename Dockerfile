FROM ruby:2.4

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV RACK_ENV=production

RUN apt-get update -qq
RUN apt-get install -fqq
RUN apt-get install -yqq build-essential net-tools apt-utils libpq-dev ntp wget git

RUN service ntp stop
RUN apt-get install -yqq fake-hwclock
RUN ntpd -gq &
RUN service ntp start

RUN mkdir -p /maxminddb
WORKDIR /maxminddb

RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz
RUN tar -xvzf /maxminddb/GeoLite2-City.tar.gz && mv /maxminddb/GeoLite2-City_* /maxminddb/GeoLite2-City && mv /maxminddb/GeoLite2-City/GeoLite2-City.mmdb /maxminddb/GeoLite2-City.mmdb

RUN gem install maxminddb sinatra rack

EXPOSE 8080

COPY ./server.rb /maxminddb/server.rb

CMD ["ruby", "/maxminddb/server.rb", "-p", "8080"]
