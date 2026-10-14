# FROM python:3.12

# WORKDIR /app

# COPY flask_app/ /app/

# COPY models/vectorizer.pkl /app/models/vectorizer.pkl

# RUN pip install -r requirements.txt

# RUN python -m nltk.downloader stopwords wordnet

# EXPOSE 5000

# CMD ["gunicorn","-b","0.0.0.0:5000","app:app"]

# it uses a small os 
FROM python:3.12-slim  

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN python -m nltk.downloader stopwords wordnet

COPY flask_app/ /app/
COPY models/vectorizer.pkl /app/models/vectorizer.pkl

EXPOSE 5000

CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
