default-output:
	mkdir some-dir
	touch some-dir/some-file
	ls -l some-dir/*
	rm -r some-dir

suppressed-output:
	@mkdir some-dir
	@touch some-dir/some-file
	@ls -l some-dir/*
	@rm -r some-dir

.SILENT: silent-output
silent-output:
	mkdir some-dir
	touch some-dir/some-file
	ls -l some-dir/*
	rm -r some-dir

default-shell:
	echo "Shell is $$0"

bash-shell: SHELL := bash
bash-shell:
	echo "Shell is $$0"

non-fail-fast-shell:
	echo Before; no-such-command; echo After

fail-fast-shell: .SHELLFLAGS := -ceuo pipefail
fail-fast-shell:
	echo Before; no-such-command; echo After

# .ONESHELL: # .ONESHELL is global, so uncomment see the fix
state-between-commands:
	some_data='important things'
	echo "The data is: $$some_data"

state-between-commands-workaround:
	some_data='important things'; \
	echo "The data is: $$some_data"


# Bonus: templating config and enforcing env vars. To make it work:
# make -s fake-config/config.uat.json FIRST_VALUE=123 SECOND_VALUE=456
# then look for fake-config/config.uat.json

_needs_%:; if [ -z '$($*)' ]; then echo '$* variable not set'; exit 1; fi

fake-config/config.%.json: _needs_FIRST_VALUE _needs_SECOND_VALUE
		envsubst < $(@:json=template.json) > $@
