FROM mysql:5.6
RUN { \
		echo 'performance_schema = 0'; \
		echo 'innodb_buffer_pool_size = 20M'; \
	} >> /etc/mysql/my.cnf