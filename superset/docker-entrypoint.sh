#!/bin/bash

set -eo pipefail

stderr() {
    echo "$@" >&2
}

echo_step() {
cat <<EOF

######################################################################
Init Step ${1}/${STEP_CNT} [${2}] -- ${3}
######################################################################

EOF
}

SUPERSET_ADMIN_USERNAME="${SUPERSET_ADMIN_USERNAME-admin}"
SUPERSET_ADMIN_PASSWORD="${SUPERSET_ADMIN_PASSWORD:-admin}"
superset fab list-users
user_count="$(superset fab list-users | sed -n "/^username:${SUPERSET_ADMIN_USERNAME}\b/p" | wc -l)"
if test "${user_count}" = 0; then
    stderr "Creating '${SUPERSET_ADMIN_USERNAME}' admin user."
    superset fab create-admin \
        --username "${SUPERSET_ADMIN_USERNAME}" --password "${SUPERSET_ADMIN_PASSWORD}" \
        --firstname Admin --lastname Admin --email admin@localhost
fi
unset SUPERSET_ADMIN_PASSWORD

stderr "Updating the database."
superset db upgrade
superset init

if test -v SUPERSET_POST_INIT; then
    stderr "Running post-init hook ${SUPERSET_POST_INIT}."
    bash -euo pipefail -c "${SUPERSET_POST_INIT}"
fi

if [ "${#}" -ne 0 ]; then
    exec "${@}"
else
  echo_step "1" "Starts" "Starting Gunicorn"
    gunicorn \
        --bind  "0.0.0.0:${SUPERSET_PORT}" \
        --access-logfile '-' \
        --error-logfile '-' \
        --workers 1 \
        --worker-class gthread \
        --threads 20 \
        --timeout 60 \
        --limit-request-line 0 \
        --limit-request-field_size 0 \
        "${FLASK_APP}"
fi

set -x
exec "$@"