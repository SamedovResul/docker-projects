FROM node:19.6-bullseye-slim AS build

WORKDIR /usr/src/app

COPY ./src/package*.json ./

RUN --mount=type=cache,target=/usr/src/app/.npm \
  npm set cache /usr/src/app/.npm && \
  npm install

COPY ./src/ ./

FROM node:20-alpine AS runtime

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package*.json ./

COPY --from=build /usr/src/app/index.js ./

RUN addgroup -S app && adduser -S app -G app

USER app

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD node -e "fetch('http://localhost:3000').then(r => process.exit(r.ok ? 0 : 1)).catch(() => process.exit(1))"


EXPOSE 3000

CMD [ "node", "index.js" ]