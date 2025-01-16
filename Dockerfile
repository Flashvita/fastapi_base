FROM python:3.11 as requirements-stage

WORKDIR /tmp

# For install poetry >=2.0
# https://python-poetry.org/docs/pyproject#entry-points
RUN pip install poetry && poetry self add poetry-plugin-export

# For install poetry version <2.0 use command below
# RUN pip install poetry

COPY ./pyproject.toml ./poetry.lock* /tmp/

RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

FROM python:3.11

WORKDIR /app

COPY --from=requirements-stage /tmp/requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY . /app

CMD ["uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "8000", "--log-level", "debug" , "--use-colors"]
