FROM node:24-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json .npmrc ./
RUN npm ci

FROM node:24-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:24-alpine AS runner
WORKDIR /app
# PORT nao e fixado de proposito: o Render injeta PORT em runtime (default 10000)
# e o server.js do Next escuta em process.env.PORT (fallback 3000 no docker local).
ENV NODE_ENV=production \
    HOSTNAME=0.0.0.0 \
    DATABASE_PATH=/app/data/ponte.db
RUN mkdir -p /app/data
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public
EXPOSE 3000
CMD ["node", "server.js"]
