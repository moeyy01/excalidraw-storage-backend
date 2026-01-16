FROM oven/bun:1-alpine as builder

RUN apk add --update python3 make g++ curl

WORKDIR /app

COPY package.json .
COPY package-lock.json .
RUN bun install

COPY . .
RUN bun run build


FROM oven/bun:1-alpine

WORKDIR /app

COPY --from=builder /app/bun.lock /app/bun.lock
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/node_modules /app/node_modules

EXPOSE 8080

ENTRYPOINT ["bun", "run", "start:prod"]
