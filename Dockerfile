# Stage 1: Build the Angular application
FROM node:18-alpine AS builder

WORKDIR /app

# Build-time argument for REST_API_URL
ARG REST_API_URL=http://localhost:9966/petclinic/api/

# Copy package files first for better layer caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Replace the REST_API_URL in environment.ts with the build argument
RUN sed -i "s|REST_API_URL: '.*'|REST_API_URL: '${REST_API_URL}'|g" src/environments/environment.ts

# Build the Angular application for production
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy the built Angular app from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom nginx configuration (commented for now, might be useful later)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
