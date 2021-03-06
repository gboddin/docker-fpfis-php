FROM centos:6
MAINTAINER Gregory Boddin

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV COMPOSER_VERSION 1.3.1

RUN curl http://repo.ne-dev.eu/el/6/fpfis.repo > /etc/yum.repos.d/fpfis.repo
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum update -y && yum install -y mysql rsync patch zip unzip git httpd php56e mod_php56e php56e-gd php56e-cli php56e-imap php56e-intl php56e-ldap php56e-mbstring php56e-mcrypt php56e-mssql php56e-mysqlnd  php56e-opcache php56e-pdo php56e-soap php56e-xml php56e-pgsql php56e-pecl-redis php56e-pecl-imagick && yum clean all
RUN curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/2091762d2ebef14c02301f3039c41d08468fb49e/web/installer \
 && php -r " \
    \$signature = '55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30'; \
    \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
 && rm /tmp/installer.php \
 && composer --ansi --version --no-interaction
ADD resources/envvars /etc/httpd/envvars
ADD resources/php.ini /etc/php.d/fpfis.ini
ADD resources/run.sh /run.sh
ADD resources/httpd.conf /etc/httpd/conf/httpd.conf
CMD /run.sh
