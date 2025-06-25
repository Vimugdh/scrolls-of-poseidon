#!/usr/bin/env bash

set -e
set -x

coverage run --source=app --omit="app/gen/*" -m pytest --ignore=app/gen
coverage report --show-missing
coverage html --title "${@-coverage}"

echo "Open htmlcov/index.html to view the coverage report."
