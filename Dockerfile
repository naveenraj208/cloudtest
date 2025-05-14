
FROM python:3.11-slim


ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

COPY . /app/

EXPOSE 8080
RUN python manage.py collectstatic --noinput
RUN pip install gunicorn

# Command to run the app using Gunicorn, on 0.0.0.0:8080
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "myproject.wsgi:application"]