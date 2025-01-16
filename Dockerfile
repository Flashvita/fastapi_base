FROM python:3.13-alpine AS builder

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1


WORKDIR /build

# For install poetry >=2.0
# https://python-poetry.org/docs/pyproject#entry-points
RUN pip install poetry && poetry self add poetry-plugin-export

# For install poetry version <

COPY ./pyproject.toml /build/
COPY ./poetry.lock /build/

RUN poetry lock
RUN poetry export -f requirements.txt --output requirements.txt && \
    pip wheel --no-cache-dir --no-deps --wheel-dir /build/wheels -r requirements.txt


FROM python:3.13
WORKDIR /app

COPY --from=builder /build/requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt


COPY . /app
CMD ["python", "main.py"]
# CMD ["uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "8000", "--log-level", "debug" , "--use-colors"]
