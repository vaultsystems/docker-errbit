FROM debian:jessie
MAINTAINER Christoph Dwertmann <christoph.dwertmann@vaultsystems.com.au>

RUN apt-get update && apt-get install -y bundler zlib1g-dev libxml2-dev libxslt-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV RACK_ENV production
ENV RAILS_ENV production
ENV USE_ENV true
ENV ERRBIT_EMAIL_FROM errbit@example.com
ENV PORT 3000
ENV ERRBIT_PER_APP_EMAIL_AT_NOTICES true

# Install errbit
ADD https://github.com/errbit/errbit/archive/v0.6.0.tar.gz /opt

RUN cd /opt && tar xfz /opt/*.tar.gz && rm *.tar.gz && \
    cd errbit* && bundle install --deployment && \
    bundle exec rake assets:precompile    

ADD launch.bash /opt/launch.bash
EXPOSE 3000
ENTRYPOINT   ["/opt/launch.bash"]
CMD ["web"]
