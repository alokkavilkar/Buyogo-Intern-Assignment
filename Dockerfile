FROM python:3.10-alpine

WORKDIR /app

ENV MONGODB_URI=mongodb://mongo:27017/
# ENV MONGO_URI=mongodb://mongo-0.mongo,mongo-1.mongo,mongo-2.mongo:27017/dbname\_?

COPY requirements.txt /app/
COPY app.py /app/

RUN pip install -r requirements.txt

ENV FLASK_APP=app.py
ENV FLASK_ENV=development

EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]
