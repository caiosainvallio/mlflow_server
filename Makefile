build:
	docker-compose build

run:
	docker-compose up -d

stop:
	docker-compose down

logs:
	docker-compose logs -f mlflow

clear_all:
	docker-compose down --rmi all --volumes --remove-orphans

help:
	@echo "make build - build the docker image"
	@echo "make run - run the docker container"
	@echo "make stop - stop the docker container"
	@echo "make logs - show the logs of the docker container"
	@echo "make clear_all - clear all the containers and volumes"
