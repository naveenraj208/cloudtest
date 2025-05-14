FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Cloud SQL Auth Proxy
RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy && \
    chmod +x cloud_sql_proxy

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy project files
COPY . .

# Run migrations and start Gunicorn with correct PORT
CMD ./cloud_sql_proxy -dir=/cloudsql -instances=expensetracker-1000771588940:asia-south1:myfinancetool=tcp:5432 & \
    sleep 5 && \
    python manage.py migrate && \
    gunicorn myproject.wsgi:application --bind 0.0.0.0:$PORT
