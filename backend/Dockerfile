FROM node:22-alpine

WORKDIR /app

# Copy package files first for cache
COPY package*.json ./

# Install root deps
RUN npm install

# Copy source
COPY . .

RUN apk add --no-cache curl

ENV DATABASE_URL=
ENV ADMIN_USER=
ENV ADMIN_PASS=
ENV SESSION_SECRET=
ENV FRONTEND_URL=

EXPOSE 3000

CMD ["npm", "start"]