#!/bin/sh

export registry=123923422374.dkr.ecr.us-east-1.amazonaws.com/
export tag=latest

echo:
	@echo ${tag}

build-docker-kms:
	docker build -t ${registry}research/kms -f Dockerfile-kms-dev .

build-docker-turn:
	docker build -t ${registry}research/turn -f Dockerfile-turn .

build-docker-cagliari:
	docker build -t ${registry}research/cagliari -f Dockerfile-cagliari .

build-docker-manarola:
	docker build -t ${registry}research/manarola -f Dockerfile-manarola .

build-docker-all: build-docker-kms build-docker-turn build-docker-cagliari build-docker-manarola

start-kms:
	docker-compose up -d kms

start-turn:
	docker-compose up -d turn

start-cagliari:
	docker-compose up -d cagliari

start-manarola:
	docker-compose up -d manarola

start:
	docker-compose up -d app

stop:
	docker-compose down

clean-images:
	docker rmi -f ${registry}research/kms
	docker rmi -f ${registry}research/turn
	docker rmi -f ${registry}research/cagliari
	docker rmi -f ${registry}research/manarola

clean:
	docker rm -f `docker ps -aq`

login-ecr:
	`aws ecr get-login`

push-kms: login-ecr
	docker push ${registry}research/kms:${tag}

push-turn: login-ecr
	docker push ${registry}research/turn:${tag}

push-cagliari: login-ecr
	docker push ${registry}research/cagliari:${tag}

push-manarola: login-ecr
	docker push ${registry}research/manarola:${tag}

push: push-kms push-turn push-cagliari push-manarola

pull-kms: login-ecr
	docker pull ${registry}research/kms:${tag}

pull-turn: login-ecr
	docker pull ${registry}research/turn:${tag}

pull-cagliari: login-ecr
	docker pull ${registry}research/cagliari:${tag}

pull-manarola: login-ecr
	docker pull ${registry}research/manarola:${tag}

pull: pull-kms pull-turn pull-cagliari pull-manarola

save:
	docker save -o webrtc.tar ${registry}research/kms:${tag} ${registry}research/turn:${tag} ${registry}research/cagliari:${tag} ${registry}research/manarola:${tag}
