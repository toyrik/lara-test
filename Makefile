up: docker-up
down: docker-down
init: docker-down-clear app-clear docker-pull docker-build docker-up app-init

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-down-clear:
	docker-compose down -v --remove-orphans

docker-pull:
	docker-compose pull

docker-build:
	docker-compose build

app-init: app-perm app-composer-install app-assets-install app-migration app-ready

app-clear:
	docker run --rm -v ${PWD}/src:/app --workdir=/app alpine rm -f .ready

app-ready:
	docker run --rm -v ${PWD}/src:/app --workdir=/app alpine touch .ready

app-perm:
	docker-compose run --rm php-cli chgrp www-data -R storage/
	docker-compose run --rm php-cli chmod 775 -R storage

app-composer-install:
	docker-compose run --rm php-cli composer install

app-migration:
	docker-compose run --rm php-cli php artisan migrate --no-interaction

app-assets-install:
	docker-compose run --rm node yarn install
