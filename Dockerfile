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
ENV MONGODB_URL mongodb://mongodb/errbit

# Install errbit
ADD https://github.com/errbit/errbit/archive/v0.6.1.tar.gz /opt

RUN cd /opt && tar xfz /opt/*.tar.gz && rm *.tar.gz && \
    mv errbit* errbit && cd errbit && bundle install && rake assets:precompile

RUN perl -0pi.bak -e 's/protected/  before_action :authenticate_with_apache\n  protected\n  def authenticate_with_apache\n     if request.headers["X-Forwarded-User"]\n       user = User.find_by(name: request.headers["X-Forwarded-User"])\n       if user and not signed_in?\n         flash[:alert] = nil\n         sign_in_and_redirect :user, user\n       end\n     end\n  end/' /opt/errbit*/app/controllers/application_controller.rb

WORKDIR /opt/errbit
ADD launch.bash /opt/launch.bash
EXPOSE 3000
ENTRYPOINT   ["/opt/launch.bash"]
CMD ["web"]
