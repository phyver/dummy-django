FROM python:3.13-slim-trixie

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1


# Add system dependencies
RUN apt-get update && apt-get install -y \
    git \
    ca-certificates \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user for OpenShift compatibility
RUN useradd -m django_user
USER django_user

# Set working dir
WORKDIR /app

RUN git clone https://github.com/phyver/dummy_django.git .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

ENV PATH="/home/django_user/.local/bin:$PATH"

# Expose default OpenShift port
EXPOSE 8080

# Run the app using gunicorn
CMD ["gunicorn", "dummy_django.wsgi:application", "--bind", "0.0.0.0:8080"]

