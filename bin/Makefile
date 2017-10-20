WORKDIR := /home/node/workdir
ERRORSTRING := `make <TARGET> TEMPLATE=something.yaml STACK=somestack`

ifndef TEMPLATE
$(error usage: ${ERRORSTRING})
endif

ifndef STACK
$(error usage: ${ERRORSTRING})
endif

.PHONY: merge-vars
# Combine contents of the docker env-file and vars beginning `cfn_` from the
# env. Any matching from the latter will override.
merge-vars:
	@awk '{if ($$0 ~ /^cfn_/ || $$0 ~ /^#/) {print $$0; next}; print "cfn_"$$0}' cfn-vars.env >> vars.merged
	@env | grep ^cfn_ >> vars.merged || true
	@echo; echo "**** MERGED VARS: ENV overrides cfn.vars.env"; echo
	@( set -a; . ./vars.merged && env|grep ^cfn_ || true ); echo

.PHONY: create-or-update
create-or-update: merge-vars
	docker run \
-w ${WORKDIR} \
-t \
-u node \
--env AWS_REGION=eu-west-1 \
-v ${HOME}/.aws:/home/node/.aws \
-v `pwd`:/home/node/workdir \
--env-file vars.merged \
quay.io/btisdall/cfn-ci:latest \
create-or-update ${STACKNAME} ${TEMPLATE}
