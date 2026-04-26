# Development
FROM node:24-alpine AS development
ENV NODE_ENV development
ARG PORT=3000
ENV PORT ${PORT}
EXPOSE ${PORT} 9229
# Set global npm dependencies to be stored under the node user directory
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin

WORKDIR /home/node
COPY --chown=node:node package*.json ./
RUN npm install --production=false
COPY --chown=node:node ./app ./app
USER node
CMD [ "npm", "run", "start:watch" ]

# Production
FROM development AS production
ENV NODE_ENV production
USER root
RUN npm ci
USER node
CMD [ "node", "app" ]
