# ベースは Ruby イメージ
FROM ghcr.io/user-komeda/docker_ruby:sha-02f0c64@sha256:7c959cee61a374f88606510d356da848c80c7e15271009707dd7b66abe3fb5ae
# 作業ディレクトリ作成（root）
WORKDIR /app

# 非 root ユーザー作成

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

ENV PORT=4567
CMD ["bundle", "exec", "rake", "app:start"]
