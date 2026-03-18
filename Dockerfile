FROM node:22-slim

RUN npm install -g pnpm@10

WORKDIR /app

COPY pnpm-workspace.yaml .
COPY package.json .
COPY pnpm-lock.yaml .
COPY tsconfig.json .
COPY tsconfig.base.json .

COPY lib/ ./lib/
COPY artifacts/api-server/ ./artifacts/api-server/
COPY artifacts/al-mehandi/ ./artifacts/al-mehandi/

RUN pnpm install --frozen-lockfile

ENV PORT=8080
ENV NODE_ENV=production

RUN pnpm --filter @workspace/api-server run build
RUN pnpm --filter @workspace/al-mehandi run build

EXPOSE 8080

CMD ["sh", "-c", "pnpm --filter @workspace/db run push-force && node artifacts/api-server/dist/index.cjs"]
