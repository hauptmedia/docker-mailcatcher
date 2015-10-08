FROM	debian:jessie
ENV	DEBIAN_FRONTEND noninteractive

# install required packages
RUN	apt-get update -qq && \
	echo 'courier-base courier-base/webadmin-configmode boolean false' | debconf-set-selections && \
	apt-get -y install exim4 courier-imap supervisor && \
	apt-get clean autoclean && \
	apt-get autoremove --yes && \
	rm -rf /var/lib/{apt,dpkg,cache,log}/

ADD	docker-entrypoint.sh /usr/local/sbin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/sbin/docker-entrypoint.sh"]

ADD	etc/supervisor/conf.d/ /etc/supervisor/conf.d/

# 25/smtp 143/imap 
EXPOSE	25 143

CMD	["/usr/bin/supervisord"]

