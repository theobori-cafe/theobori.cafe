FROM node:18-slim

WORKDIR /app

COPY . ./

# Install dependencies and build
RUN npm ci && npm run build

# Remove build files
RUN rm -rf \
    _includes \
    assets \
    posts \
    styles \
    feed.njk \
    index.md

CMD [ "npm", "run", "serve" ]