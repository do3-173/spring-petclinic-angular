# Node.js is needed to build Angular applications
FROM node:18-alpine

# Setting the working directory inside the container
WORKDIR /app

# Copy everything from the current directory into the container
COPY . .

# npm install downloads all the libraries and tools needed to build the app
RUN npm install

# Build the Angular application for production
RUN npm run build

# The frontend web server runs on port 4200
EXPOSE 4200

# Start the Angular development server
# --host 0.0.0.0 allows connections from outside the container
CMD ["npm", "start", "--", "--host", "0.0.0.0"]
