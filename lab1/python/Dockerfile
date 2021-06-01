FROM python:3.9

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Bundle app source
COPY . .
CMD ["python", "app.py"]