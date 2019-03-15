FROM mariadb:10.3

COPY init.sql /docker-entrypoint-initdb.d/
COPY app.cnf /etc/mysql/conf.d/

ARG USER_ID
ENV USER_ID $USER_ID
ARG GROUP_ID
ENV GROUP_ID $GROUP_ID

RUN [ -z $(getent group $GROUP_ID | cut -d: -f1) ] && groupmod -g $GROUP_ID mysql || true
RUN usermod -u $USER_ID -g $GROUP_ID mysql
