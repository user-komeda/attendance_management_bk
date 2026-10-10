FROM ghcr.io/user-komeda/docker_node:sha-79897d5@sha256:e61f8ea86e1ca9c598bcec2163cdf0adeb0418b26deb08b637ef4d42bafe79a0 AS base

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
RUN microdnf install -y shadow-utils && \
    microdnf clean all && \
    useradd -r -u 1001 solidjs
# 必要ファイルをコピー
COPY --from=installer --chown=solidjs:solidjs /app/apps/frontend/dist/ /app/dist/
COPY --from=installer --chown=solidjs:solidjs /app/apps/frontend/package.json /app/
COPY --from=installer --chown=solidjs:solidjs /app/node_modules /app/node_modules/


USER solidjs

EXPOSE 3000

CMD ["node", "./node_modules/infisicalLauncher/dist/index.cjs", "--path=/microCms/solid/", "--", "node", ".output/server/index.mjs"]
