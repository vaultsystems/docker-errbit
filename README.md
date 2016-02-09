# docker-errbit

Errbit 0.6.1 in a docker container. Prepared for OpenAM SSO via 'X-Forwarded-User' HTTP header.

Example *docker-compose.yml* file:

    errbit_mongodb:
      image: mongo
      volumes: 
        - "/mnt/services/errbit/mongodb:/data/db"

    errbit:
      image: vault/errbit
      links: 
        - "errbit_mongodb:mongodb"
      ports:
        - "5005:3000"
      environment:
        - "ERRBIT_EMAIL_FROM=errbit@example.com"

Create the initial admin account:

    docker exec -ti services_errbit_1 bundle exec rake errbit:bootstrap

Log in and create users with user names matching the user names in OpenAM.
