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

# This helper encapsulates the `docker-compose run` and captures its exit code.
# The short-circuit ternary syntax prevents any potential `errexit` (fail fast
# shell) from kicking in because: "The -e setting shall be ignored when
# executinġ... any command of an AND-OR list other than the last" (from `man set`).

# It always captures exit_status, to avoid falling foul of possible `nounset`
# when the exit_status variable gets expanded.

# Execute final `exit` in a subshell so it doesn't kill the current shell
# (which would prevent subsequent commands) while still honouring the exit code
# of the docker-compose run. This means `errexit` will behave as expected and
# can still be used to control fail-fastness.
define docker-compose-run
	docker-compose run --rm $(1) && exit_status=$$? || exit_status=$$?
	[ "$$exit_status" -ne 0 ] && docker-compose ps && docker-compose logs
	docker-compose down -v
	(exit $$exit_status)
endef

docker-compose-run-fail-safe-idea:
	$(call docker-compose-run, test-fail)
