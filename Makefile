INTRA_LOGIN := harndt
DOMAIN_NAME := $(INTRA_LOGIN).42.fr

VOLUME_DIRS := wordpress mariadb
VOLUME_PATH := $(addprefix /home/$(INTRA_LOGIN)/data/, $(VOLUME_DIRS))

DOCKER_PATH := ./srcs

DOCKER_COMPOSE_FILE := $(DOCKER_PATH)/docker-compose.yml

all: up

up: | $(VOLUME_PATH)
	@cat /etc/hosts | grep $(DOMAIN_NAME) > /dev/null || \
	echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee /etc/hosts > /dev/null
	docker-compose --file $(DOCKER_COMPOSE_FILE) up --build

d: detach

detach: | $(VOLUME_PATH)
	@cat /etc/hosts | grep $(DOMAIN_NAME) > /dev/null || \
	echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee /etc/hosts > /dev/null
	docker-compose --file $(DOCKER_COMPOSE_FILE) up --build --detach

$(VOLUME_PATH):
	sudo mkdir -p $@

clean:
	docker-compose --file $(DOCKER_COMPOSE_FILE) down

fclean: clean
	docker-compose --file $(DOCKER_COMPOSE_FILE) rm -f -s -v

re: fclean all

prune: fclean
	sudo rm -rf $(VOLUME_PATH)
	docker system prune --all --volumes --force

purge: prune
	docker stop $(docker ps -qa) 2> /dev/null || true
	docker rm $(docker ps -qa) 2> /dev/null || true
	docker rmi -f $(docker images -qa) 2> /dev/null || true
	docker volume rm $(docker volume ls -q) 2> /dev/null || true
	docker network rm $(docker network ls -q) 2> /dev/null || true

.PHONY: all up d detach clean fclean re prune purge