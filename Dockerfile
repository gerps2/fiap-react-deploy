FROM node:22-alpine AS builder

WORKDIR /app

ARG VITE_ENVIRONMENT=prod
ARG VITE_APP_VERSION=1.0.0
ARG VITE_BUILD_TIMESTAMP
ARG VITE_LOGROCKET_APP_ID
ARG VITE_LOGROCKET_PROJECT_NAME

COPY package*.json ./
COPY tsconfig*.json ./
COPY vite.config.ts ./

ENV HUSKY_SKIP_INSTALL=1
RUN npm ci --force && npm cache clean --force

COPY src/ ./src/
COPY public/ ./public/
COPY index.html ./

ENV VITE_ENVIRONMENT=${VITE_ENVIRONMENT}
ENV VITE_APP_VERSION=${VITE_APP_VERSION}
ENV VITE_BUILD_TIMESTAMP=${VITE_BUILD_TIMESTAMP}
ENV VITE_LOGROCKET_APP_ID=${VITE_LOGROCKET_APP_ID}
ENV VITE_LOGROCKET_PROJECT_NAME=${VITE_LOGROCKET_PROJECT_NAME}

RUN npm run build

FROM nginx:1.25-alpine AS production

RUN apk add --no-cache curl

RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup

COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN echo '#!/bin/sh' > /usr/local/bin/healthcheck.sh && \
    echo 'curl -f http://localhost:8080/ || exit 1' >> /usr/local/bin/healthcheck.sh && \
    chmod +x /usr/local/bin/healthcheck.sh

RUN chown -R appuser:appgroup /usr/share/nginx/html && \
    chown -R appuser:appgroup /var/cache/nginx && \
    chown -R appuser:appgroup /var/log/nginx && \
    chown -R appuser:appgroup /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD /usr/local/bin/healthcheck.sh

LABEL maintainer="FIAP React Deploy Team" \
      version="${VITE_APP_VERSION}" \
      description="Status App - Painel de Diagnóstico para monitoramento de deploys" \
      node.version="22" \
      nginx.version="1.25"

CMD ["nginx", "-g", "daemon off;"] 