#!/bin/sh

export registry ?= 123923422374.dkr.ecr.us-east-1.amazonaws.com/research
export tag ?= latest

echo:
	@echo "\nRegistry: $(registry)\nTag: $(tag)\n"

build-docker-kms:
	docker build -t $(registry)/kms:$(tag) -f Dockerfile-kms --build-arg tag=6.6.1 .

build-docker-kms-dev:
	docker build -t ${registry}/kms-dev:$(tag) -f Dockerfile-kms-dev --build-arg tag=6.6.1 .

build-docker-turn:
	docker build -t $(registry)/turn:$(tag) -f Dockerfile-turn .

build-docker-wowza:
	docker build -t $(registry)/wowza:$(tag) -f Dockerfile-wowza .

build-docker-nginx:
	docker build -t $(registry)/nginx -f Dockerfile-nginx .

build-docker-all: build-docker-kms build-docker-turn build-docker-wowza build-docker-nginx

squash-docker-kms:
	docker-squash -t $(registry)/kms:$(tag) $(registry)/kms:$(tag)

start-kms:
	docker-compose up -d kms

start-kms-dev:
	docker-compose up -d kms-dev

start-turn:
	docker-compose up -d turn

start-redis:
	docker-compose up -d redis

start-wowza:
	docker-compose up -d wowza

start-nginx:
	docker-compose up -d nginx

start-manarola:
	docker-compose up -d manarola

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

push-kms-dev: login-ecr
    docker push $(registry)/kms-dev:$(tag)

push-turn: login-ecr
	docker push $(registry)/turn:$(tag)

push-wowza-4.6.0: login-ecr
	docker push $(registry)/wowza-4.6.0:$(tag)

push-wowza: login-ecr
	docker push $(registry)/wowza:$(tag)

push-nginx: login-ecr
	docker tag $(registry)/nginx $(registry)/nginx:$(tag)
	docker push $(registry)/nginx
	docker push $(registry)/nginx:$(tag)

push: push-kms push-turn push-wowza push-nginx

pull-kms: login-ecr
	docker pull $(registry)/kms:$(tag)

pull-kms-dev: login-ecr
    docker pull $(registry)/kms-dev:$(tag)

pull-turn: login-ecr
	docker pull $(registry)/turn:$(tag)

pull-wowza: login-ecr
	docker pull $(registry)/wowza:$(tag)

pull-nginx: login-ecr
	docker pull $(registry)/nginx:$(tag)

pull-manarola: login-ecr
	docker pull $(registry)/manarola:$(tag)

pull: pull-kms pull-turn pull-wowza pull-nginx

save:
	docker save -o webrtc.tar $(registry)/kms:$(tag)
							  $(registry)/turn:$(tag)
						      $(registry)/wowza:$(tag)
						      $(registry)/nginx:$(tag)
