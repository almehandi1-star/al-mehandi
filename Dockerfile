FROM node:22-slim

RUN npm install -g pnpm@10

WORKDIR /app

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml tsconfig.json tsconfig.base.json ./
COPY . .

ENV PORT=8080
ENV NODE_ENV=production

RUN pnpm install --frozen-lockfile
RUN pnpm --filter @workspace/api-server run build
RUN pnpm --filter @workspace/al-mehandi run build

EXPOSE 8080

CMD ["sh", "-c", "pnpm --filter @workspace/db run push-force && node artifacts/api-server/dist/index.cjs"]
