## BUILDER BASE IMAGE ##

# pull official base image
FROM python:3.8.1-slim-buster as builder

# set work directory
WORKDIR /usr/src/app

# install system deps
# RUN apt-get update && apt-get install -y --no-install-recommends gcc

# linting
RUN pip install --upgrade pip
RUN pip install flake8
COPY . /usr/src/app
RUN flake8 .
#RUN flake8 --ignore=E501,F401 .

# install python deps
COPY requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /usr/src/app/wheels -r requirements.txt


## FINAL IMAGE ##
FROM python:3.8.1-slim-buster

# create non-root user
RUN mkdir -p /home/app
RUN addgroup --system app && adduser --system --group app
ENV HOME=/home/app
ENV APP_HOME=/home/app/web
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# install deps
# RUN apt-get update && apt-get install -y --no-install-recommends netcat
COPY --from=builder /usr/src/app/wheels /wheels
COPY --from=builder /usr/src/app/requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache /wheels/*

# copy entrypoint
COPY entrypoint.sh $APP_HOME
COPY . $APP_HOME

# Run as app user
RUN chown -R app:app $APP_HOME
USER app

## run entrypoint script
EXPOSE 5000
ENTRYPOINT ["/home/app/web/entrypoint.sh", "gunicorn", "--bind", "0.0.0.0:5000", "--timeout", "3600", "--threads", "4", "app:app"]
