FROM ghcr.io/user-komeda/docker_node:sha-7b65646@sha256:618e3e78e6e46af2edfc263f81eb1e23f642c387398424e502562381e2c97a60 AS base

FROM base AS builder
RUN yarn global add turbo
COPY . .
RUN turbo prune --scope=frontend --docker

FROM base AS installer
WORKDIR /app

COPY --from=builder /out/json/ .
RUN corepack enable
RUN corepack install -g yarn@stable
RUN yarn install
COPY --from=builder /out/full/ .
RUN yarn build


FROM base AS runner
WORKDIR /app

# セキュリティ: 実行ユーザー作成
RUN adduser --system --uid 1001 solidjs
USER solidjs

# 必要ファイルをコピー
COPY --from=installer /app/apps/frontend/.output/ /app/.output/
COPY --from=installer /app/apps/frontend/package.json /app/
COPY --from=installer /app/node_modules /app/node_modules/

EXPOSE 3000

# SolidStart v2は .output/server/index.mjs を直接起動
CMD ["node", ".output/server/index.mjs"]

