# Use official Node.js image as the base
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy the package.json and package-lock.json (or yarn.lock) files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Next.js app for production
RUN npm run build

# Install `serve` to serve the app in production mode
RUN npm install -g serve

# Expose port 3000 (Next.js defaults to this port)
EXPOSE 3000

# Command to serve the built Next.js app
CMD ["npm", "run", "start"]