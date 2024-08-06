FROM python:2.7-alpine3.10

WORKDIR /app

ENV MONGODB_URI mongodb://localhost:27017/

COPY requirements.txt /app/
COPY app.py /app/
COPY .env /app/

RUN pip install -r requirements.txt &\
    echo $ENV > .env &\
    export FLASK_APP=app.py &\
    export FLASK_ENV=development

EXPOSE 5000

CMD [ "flask", "run" ]
