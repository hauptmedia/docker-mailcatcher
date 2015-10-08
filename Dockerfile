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

# 25/smtp 
EXPOSE	25

CMD	["/usr/bin/supervisord"]

