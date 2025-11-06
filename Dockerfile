# Node.js is needed to build Angular applications
FROM node:18-alpine

# Setting the working directory inside the container
WORKDIR /app

# Build-time argument for REST_API_URL
ARG REST_API_URL=http://localhost:9966/petclinic/api/

# Copy everything from the current directory into the container
COPY . .

# npm install downloads all the libraries and tools needed to build the app
RUN npm install

# Replace the REST_API_URL in environment.ts with the build argument
RUN sed -i "s|REST_API_URL: '.*'|REST_API_URL: '${REST_API_URL}'|g" src/environments/environment.ts

# Build the Angular application for production
RUN npm run build

# The frontend web server runs on port 4200
EXPOSE 4200

# Start the Angular development server
# --host 0.0.0.0 allows connections from outside the container
CMD ["npm", "start", "--", "--host", "0.0.0.0"]
