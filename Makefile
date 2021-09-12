app_name = aws-eb-bluegreen-java
env_name = $(app_name)-dev
platform = corretto-11
region = eu-west-1

init:
	test -f target/*.jar && \
	eb init -p $(platform) --region $(region) $(app_name) && \
	echo "deploy:" >> .elasticbeanstalk/config.yml && \
	echo "  artifact: $(shell ls -1 target/*.jar)" >> .elasticbeanstalk/config.yml && \
	eb create $(env_name) --envvars SERVER_PORT=5000 || \
	echo No jar found, Perform mvn clean install first
deploy:
	mvn clean install && eb deploy
destroy:
	eb terminate --all --force 
