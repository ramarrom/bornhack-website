DOCKER_COMPOSE = COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose -f docker/docker-compose.yml
DOCKER_RUN = ${DOCKER_COMPOSE} run -u `id -u`
MANAGE_EXEC = ${DOCKER_COMPOSE} exec app python /app/src/manage.py
MANAGE_RUN = ${DOCKER_RUN} app python /app/src/manage.py
PARALLEL=4
TEST_OPTIONS = --failfast --keepdb --parallel ${PARALLEL}
TEST_TO_RUN = .

run:
	${DOCKER_COMPOSE} up

migrate:
	${MANAGE_RUN} $@ ${EXTRA_ARGS}

makemigrations:
	${MANAGE_RUN} $@ ${EXTRA_ARGS}

shell:
	${MANAGE_RUN} $@ ${EXTRA_ARGS}

manage_command:
	${MANAGE_RUN} ${COMMAND}

test:
	${DOCKER_RUN} app \
		bash -c "cd /app/src/; python manage.py test $(TEST_OPTIONS) ${TEST_TO_RUN}"

build_docker_image:
	${DOCKER_COMPOSE} build app