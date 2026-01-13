# ベースは Ruby イメージ
FROM ghcr.io/user-komeda/docker_ruby:sha-02f0c64@sha256:7c959cee61a374f88606510d356da848c80c7e15271009707dd7b66abe3fb5ae
# 作業ディレクトリ作成（root）
WORKDIR /app

# 1. root ユーザーで必要な CLI と Node.js をインストール
RUN curl -sL https://rpm.nodesource.com/setup_22.x | bash - && \
    microdnf install -y nodejs git openssh-clients && \
    curl -1sLf 'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.rpm.sh' | bash && \
    microdnf install -y infisical && \
    microdnf clean all

# 2. Infisical Launcher だけをインストール
# corepack を有効にして最新のパッケージを node_modules/.bin に入れる
RUN  mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# package.json を作らず、直接 git 経由でインストールして実行バイナリを確保する
RUN --mount=type=ssh npm install -g dotenv "git+ssh://git@github.com:user-komeda/infisicalLauncher.git"

# Gemfile 系を先にコピーしてキャッシュ効かせる
COPY ./apps/backend/Gemfile ./apps/backend/Gemfile.lock ./
RUN useradd -m appuser && mkdir -p /app/vendor/bundle && chown -R appuser:appuser /app
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
# --- 非root部分 ---
USER appuser
ENV GEM_HOME=/app/vendor/bundle
ENV GEM_PATH=$GEM_HOME:/usr/local/lib/ruby/gems/3.4.0
ENV PATH=$GEM_HOME/bin:$PATH

RUN bundle install

# アプリ全体をコピー
COPY apps/backend .
COPY ./.env .

ENV PORT=4567
CMD ["node", "/usr/lib/node_modules/infisicalLauncher/index.js", "--path=/microCms/sinatra/local", "--cmd=bundle exec rake app:start"]
