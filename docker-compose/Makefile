.SILENT:
SHELL := bash
.SHELLFLAGS := -ceuo pipefail
.ONESHELL:

test-pass-with-cleanup:
	docker-compose run --rm test
	docker-compose down

test-fail-no-cleanup:
	docker-compose run --rm test-fail
	docker-compose down # Doesn't get run

test-fail-with-cleanup-but-wrong-exit-code: .SHELLFLAGS = -cuo pipefail
test-fail-with-cleanup-but-wrong-exit-code:
	docker-compose run --rm test-fail
	docker-compose down

test-fail-with-cleanup-and-correct-exit-code: .SHELLFLAGS = -cuo pipefail
test-fail-with-cleanup-and-correct-exit-code:
	docker-compose run --rm test-fail
	exit_status=$$?
	docker-compose down
	exit $$exit_status

test-fail-with-cleanup-and-correct-exit-code-using-set:
	set +e
	docker-compose run --rm test-fail
	exit_status=$$?
	set -e
	docker-compose down
	exit $$exit_status

test-fail-with-cleanup-and-correct-exit-code-using-logical-or:
	docker-compose run --rm test-fail || exit_status=$$?
	docker-compose down
	exit $$exit_status

define docker-compose-run
	docker-compose run --rm $(1) || exit_status=$$?
	[ $$exit_status -ne 0 ] && docker-compose logs
	docker-compose down
	exit $$exit_status
endef

docker-compose-run-fail-safe-idea:
	$(call docker-compose-run, test-fail)
