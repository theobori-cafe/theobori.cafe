FROM node:18-slim as build

WORKDIR /app

COPY . ./

RUN npm ci && npm run build

FROM nginx:latest as run

COPY --from=build /app/_site/ /usr/share/nginx/html/
COPY ./docker/nginx/default.conf /etc/nginx/conf.d/default.conf
