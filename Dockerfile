FROM node:18-slim

WORKDIR /app

COPY . ./

# Install dependencies and build
RUN npm ci && npm run build

CMD [ "npm", "run", "serve" ]