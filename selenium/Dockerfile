FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3.7 python3-pip \
    tk-dev \
    python-tk \
    python3-tk \
    fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 \
    libnspr4 libnss3 lsb-release xdg-utils libxss1 libdbus-glib-1-2 \
    curl unzip wget iputils-ping \
    xvfb


# install geckodriver and firefox

RUN GECKODRIVER_VERSION=`curl https://github.com/mozilla/geckodriver/releases/latest | grep -Po 'v[0-9]+.[0-9]+.[0-9]+'` && \
    wget https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
    tar -zxf geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/geckodriver && \
    rm geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz

RUN FIREFOX_SETUP=firefox-setup.tar.bz2 && \
    apt-get purge firefox && \
    wget -O $FIREFOX_SETUP "https://download.mozilla.org/?product=firefox-latest&os=linux64" && \
    tar xjf $FIREFOX_SETUP -C /opt/ && \
    ln -s /opt/firefox/firefox /usr/bin/firefox && \
    rm $FIREFOX_SETUP


# install chromedriver and google-chrome

RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip -d /usr/bin && \
    chmod +x /usr/bin/chromedriver && \
    rm chromedriver_linux64.zip

RUN CHROME_SETUP=google-chrome.deb && \
    wget -O $CHROME_SETUP "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" && \
    dpkg -i $CHROME_SETUP && \
    apt-get install -y -f && \
    rm $CHROME_SETUP


# install phantomjs

RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    tar -jxf phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    cp phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && \
    rm phantomjs-2.1.1-linux-x86_64.tar.bz2


# install python requirements
COPY requirements.txt /tmp
RUN pip3 install selenium && \
    pip3 install pyvirtualdisplay && \
    pip3 install -r /tmp/requirements.txt

# ^^^ PLEASE PLACE ALL PACKAGE INSTALL/COMPILATION TASKS ABOVE THIS LINE ^^^

# Import values set in docker-compose, some of which are from .env
ARG DISPLAY_ENVIRONMENT
ARG SERVICE_USER_ID
ARG SERVICE_GROUP_ID
ARG BUILD_TARGET

# Change www-data to run on correct UID/GID, so we don't get permission errors
RUN usermod -u ${SERVICE_USER_ID} www-data && \
    groupmod -g ${SERVICE_GROUP_ID} www-data && \
    mkdir -p /var/www/app && \
    chown -R www-data:www-data /var/www


# dshell
COPY common/dshell /usr/local/bin
COPY common/profile /etc/dshell/profile
RUN ln -s /etc/dshell/profile /var/www/.profile && \
    echo "source /etc/dshell/profile" >> /root/.bashrc && \
    echo "source /etc/dshell/profile" >> /var/www/.bashrc && \
    echo "${DISPLAY_ENVIRONMENT} (${BUILD_TARGET})" > /etc/dshell/display-environment && \
    echo "www-data" > /etc/dshell/default-user && \
    echo "/var/www/app" > /etc/dshell/default-user-start-dir


ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONUNBUFFERED=1

ENV APP_HOME /var/www/app
WORKDIR /$APP_HOME

# COPY . $APP_HOME/

CMD tail -f /dev/null
# CMD python3 example.py


# ADD ./docker-user-fix.sh /usr/bin/docker-user-fix.sh
# ADD ./build-for-deploy.sh /usr/bin/build-for-deploy.sh
# RUN chmod +x /usr/bin/docker-user-fix.sh /usr/bin/build-for-deploy.sh
# RUN addgroup -g ${GROUP_ID} deploy && adduser -D -u ${USER_ID} -G deploy deploy 
# RUN apk add sudo
# RUN sed -e 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' \
#       -i /etc/sudoers
# RUN sed -e 's/^wheel:\(.*\)/wheel:\1,deploy/g' -i /etc/group

# USER deploy
