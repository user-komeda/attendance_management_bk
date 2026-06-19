FROM ghcr.io/user-komeda/docker_node:sha-7b65646@sha256:618e3e78e6e46af2edfc263f81eb1e23f642c387398424e502562381e2c97a60 AS base

WORKDIR /app

FROM base AS builder
COPY . .
RUN corepack enable && yarn dlx turbo prune --scope=frontend --docker


FROM base AS installer
RUN microdnf install -y git openssh-clients && \
    microdnf clean all && \
    mkdir -p -m 0700 ~/.ssh && \
    ssh-keyscan -H github.com >> ~/.ssh/known_hosts
RUN corepack enable
COPY --from=builder /app/out/json/ .
RUN --mount=type=ssh yarn install --immutable

COPY --from=builder /app/out/full/ .
RUN yarn build


FROM base AS runner
WORKDIR /app

# セキュリティ: 実行ユーザー作成
RUN adduser --system --uid 1001 solidjs

# 必要ファイルをコピー
COPY --from=installer --chown=solidjs /app/apps/frontend/.output/ /app/.output/
COPY --from=installer --chown=solidjs /app/apps/frontend/package.json /app/
COPY --from=installer --chown=solidjs /app/node_modules /app/node_modules/

USER solidjs

EXPOSE 3000

CMD ["node", "./node_modules/infisicalLauncher/dist/index.cjs", "--path=/microCms/solid/", "--", "node", ".output/server/index.mjs"]
