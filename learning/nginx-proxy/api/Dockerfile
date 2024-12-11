FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY doc.html doc.html
COPY app.py app.py

EXPOSE 8080

CMD ["python", "app.py"]

