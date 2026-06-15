# ベースは Ruby イメージ
FROM ghcr.io/user-komeda/docker_ruby:sha-02f0c64@sha256:7c959cee61a374f88606510d356da848c80c7e15271009707dd7b66abe3fb5ae

# 作業ディレクトリ作成（root）
WORKDIR /app

# 1. root ユーザーで必要な CLI と Node.js をインストール
RUN curl -sL https://rpm.nodesource.com/setup_22.x | bash - && \
    microdnf install -y nodejs git openssh-clients && \
    microdnf clean all

# 2. SSH と Yarn を準備
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan -H github.com >> ~/.ssh/known_hosts
RUN corepack enable

# Node workspace の依存関係をインストール
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn .yarn
COPY apps/backend/package.json apps/backend/package.json
COPY apps/frontend/package.json apps/frontend/package.json

RUN --mount=type=ssh yarn install --immutable

# Gemfile 系を先にコピーしてキャッシュ効かせる
COPY ./apps/backend/Gemfile ./apps/backend/Gemfile.lock ./

RUN useradd -m appuser && \
    mkdir -p /app/vendor/bundle && \
    chown -R appuser:appuser /app

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV BUNDLE_WITHOUT=development:test

# --- 非root部分 ---
USER appuser

ENV GEM_HOME=/app/vendor/bundle
ENV GEM_PATH=$GEM_HOME:/usr/local/lib/ruby/gems/3.4.0
ENV PATH=$GEM_HOME/bin:$PATH

RUN bundle install

# アプリ全体をコピー
COPY --chown=appuser:appuser apps/backend apps/backend

WORKDIR /app/apps/backend

CMD ["node", "../../node_modules/infisicalLauncher/dist/index.cjs", "--path=/microCms/sinatra", "--", "env", "APP_RUNTIME_ONLY=true", "bundle", "exec", "rake", "app:start"]
