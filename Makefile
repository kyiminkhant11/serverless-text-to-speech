.PHONY: dev lint complex coverage pre-commit yapf sort deploy destroy deps unit integration e2e pipeline-tests docs lint-docs build



dev:
	pip install --upgrade pip pre-commit poetry
	make deps
	pre-commit install
	poetry shell

format:
	poetry run ruff check . --fix

format-fix:
	poetry run ruff format .


lint:
	@echo "Running mypy"
	make mypy-lint

complex:
	@echo "Running Radon"
	radon cc -e 'tests/*,cdk.out/*' .
	@echo "Running xenon"
	xenon --max-absolute B --max-modules A --max-average A -e 'tests/*,.venv/*,cdk.out/*' .


pre-commit:
	pre-commit run -a --show-diff-on-failure

mypy-lint:
	mypy --pretty service cdk tests

deps:
	poetry export --only=dev --without-hashes --format=requirements.txt > dev_requirements.txt
	poetry export --without=dev --without-hashes --format=requirements.txt > lambda_requirements.txt

unit:
	pytest tests/unit  --cov-config=.coveragerc --cov=service --cov-report xml

build:
	make deps
	mkdir -p .build/lambdas ; cp -r service .build/lambdas
	mkdir -p .build/common_layer ; poetry export --without=dev --without-hashes --format=requirements.txt > .build/common_layer/requirements.txt

integration:
	pytest tests/integration  --cov-config=.coveragerc --cov=service --cov-report xml

e2e:
	pytest tests/e2e  --cov-config=.coveragerc --cov=service --cov-report xml

pr: deps pre-commit complex lint unit deploy integration e2e


pipeline-tests:
	pytest tests/unit tests/integration  --cov-config=.coveragerc --cov=service --cov-report xml

deploy:
	make build
	cdk deploy --app="python3 ${PWD}/app.py" --require-approval=never

destroy:
	cdk destroy --app="python3 ${PWD}/app.py" --force

docs:
	mkdocs serve

lint-docs:
	docker run -v ${PWD}:/markdown 06kellyjac/markdownlint-cli --fix "docs"


update-deps:
	poetry update
	pre-commit autoupdate
