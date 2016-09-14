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

build-docker-wowza:
	docker build -t ${registry}research/wowza -f Dockerfile-wowza .

build-docker-all: build-docker-kms build-docker-turn build-docker-cagliari build-docker-manarola build-docker-wowza

start-kms:
	docker-compose up -d kms

start-turn:
	docker-compose up -d turn

start-cagliari:
	docker-compose up -d cagliari

start-manarola:
	docker-compose up -d manarola

start-wowza:
	docker-compose up -d wowza

start:
	docker-compose up -d app

stop:
	docker-compose down

clean-images:
	docker rmi -f ${registry}research/kms
	docker rmi -f ${registry}research/turn
	docker rmi -f ${registry}research/cagliari
	docker rmi -f ${registry}research/manarola
	docker rmi -f ${registry}research/wowza-4.5.0
	docker rmi -f ${registry}research/wowza

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

push-wowza-4.5.0: login-ecr
	docker push ${registry}research/wowza-4.5.0:${tag}

push-wowza: login-ecr
	docker push ${registry}research/wowza:${tag}

push: push-kms push-turn push-cagliari push-manarola push-wowza

pull-kms: login-ecr
	docker pull ${registry}research/kms:${tag}

pull-turn: login-ecr
	docker pull ${registry}research/turn:${tag}

pull-cagliari: login-ecr
	docker pull ${registry}research/cagliari:${tag}

pull-manarola: login-ecr
	docker pull ${registry}research/manarola:${tag}

pull-wowza: login-ecr
	docker pull ${registry}research/wowza:${tag}

pull: pull-kms pull-turn pull-cagliari pull-manarola pull-wowza

save:
	docker save -o webrtc.tar ${registry}research/kms:${tag} ${registry}research/turn:${tag} ${registry}research/cagliari:${tag} ${registry}research/manarola:${tag} ${registry}research/wowza:${tag}
