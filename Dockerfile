# Jekyll用のDockerコンテナ
FROM ruby:3.2

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /srv/jekyll

# workspaceディレクトリからGemfileとGemfile.lockをコピー
COPY workspace/Gemfile workspace/Gemfile.lock* ./

# Bundlerをインストール
RUN gem install bundler

# Jekyllとその依存関係をインストール
RUN bundle install

# workspaceディレクトリからJekyllプロジェクトファイルをコピー
COPY workspace/_config.yml ./
COPY workspace/_layouts/ ./_layouts/
COPY workspace/_posts/ ./_posts/
COPY workspace/assets/ ./assets/
COPY workspace/index.html ./
COPY workspace/about.md ./
COPY workspace/blog.html ./

# ポートを公開
EXPOSE 4000

# Jekyllサーバーを起動
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--force_polling"]

