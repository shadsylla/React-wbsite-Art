# This image makes use of a Node image running on Linux Alpine (latest versions of both)
# Using digest SHA256 increases security
FROM node:14.17.1-alpine3.13@sha256:dea2df28d36f6918af3e66522f608ddc0c997803de0e465ca28ef8804658b80c

# Adds a package to act as PID 1 so that Node doesn't take that place.
# Node wasn't built to run as PID 1 and avoiding it prevents unexpected behaviour.
RUN apk add dumb-init

# A work directory is required to be used by npm install
WORKDIR /var/shad-react-app

# Copy all project files to the container
# Files in the location of this file are copied to WORKDIR in the container
# Scopes permissions to user node instead of root.
COPY --chown=node:node ["./*", "./"]

# Install dependencies
RUN npm ci

EXPOSE 3000

# Switches user from root to node.
USER node

# The process this container should run
CMD ["dumb-init", "npm", "start"]