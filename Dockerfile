FROM node:18-slim AS build

WORKDIR /app

COPY . .

RUN \
    npm ci && \
    npm run build

FROM linuxserver/nginx:1.26.1

COPY --from=build /app/_site /config/www
