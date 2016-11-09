#!/bin/sh

registry ?= 123923422374.dkr.ecr.us-east-1.amazonaws.com/research
tag ?= latest

echo:
	@echo "\nRegistry: $(registry)\nTag: $(tag)\n"

build-docker-kms:
	docker build -t $(registry)/kms:$(tag) -f Dockerfile-kms .

build-docker-turn:
	docker build -t $(registry)/turn:$(tag) -f Dockerfile-turn .

build-docker-wowza:
	docker build -t $(registry)/wowza:$(tag) -f Dockerfile-wowza .

build-docker-nginx:
	docker build -t $(registry)/nginx -f Dockerfile-nginx .

build-docker-all: build-docker-kms build-docker-turn build-docker-wowza build-docker-nginx

start-kms:
	docker-compose up -d kms

start-turn:
	docker-compose up -d turn

start-redis:
	docker-compose up -d redis

start-wowza:
	docker-compose up -d wowza

start-nginx:
	docker-compose up -d nginx

start:
	docker-compose up -d app

stop:
	docker-compose down

clean-images:
	docker rmi -f $(registry)/kms
	docker rmi -f $(registry)/turn
	docker rmi -f $(registry)/wowza-4.5.0
	docker rmi -f $(registry)/wowza
	docker rmi -f $(registry)/nginx

clean:
	docker rm -f `docker ps -aq`

login-ecr:
	`aws ecr get-login`

push-kms: login-ecr
	docker push $(registry)/kms:$(tag)

push-turn: login-ecr
	docker push $(registry)/turn:$(tag)

push-wowza-4.5.0: login-ecr
	docker push $(registry)/wowza-4.5.0:$(tag)

push-wowza: login-ecr
	docker push $(registry)/wowza:$(tag)

push-nginx: login-ecr
	docker tag $(registry)/nginx $(registry)/nginx:$(tag)
	docker push $(registry)/nginx
	docker push $(registry)/nginx:$(tag)

push: push-kms push-turn push-wowza push-nginx

pull-kms: login-ecr
	docker pull $(registry)/kms:$(tag)

pull-turn: login-ecr
	docker pull $(registry)/turn:$(tag)

pull-wowza: login-ecr
	docker pull $(registry)/wowza:$(tag)

pull-nginx: login-ecr
	docker pull $(registry)/nginx:$(tag)

pull: pull-kms pull-turn pull-wowza pull-nginx

save:
	docker save -o webrtc.tar $(registry)/kms:$(tag)
							  $(registry)/turn:$(tag)
						      $(registry)/wowza:$(tag)
						      $(registry)/nginx:$(tag)
