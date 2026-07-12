# Junie Agent Guidelines

## Critical Rules (Must Follow First)

- [ ] 回答・実装前にこのファイルを読む
- [ ] 不明点は推測せず質問する
- [ ] ルール違反でエラーを「抑制」しない（コードを修正する）

## Output Contract

- 断定には根拠を示す（必要ならURL付き）
- 未確認事項は「未確認」と明記し、断定しない

## 絶対禁止事項（lintエラー修正時）

- `# rubocop:disable` コメントの追加は禁止（RBS注釈行を除く）
- RBSコメントに対するエラーに対しては `# rubocop:disable all` を使用して無視してください
- `.rubocop.yml` の変更は禁止
- `// eslint-disable` コメントの追加は禁止
- lintエラーは必ずコード自体を修正して解決すること

## ガイドライン参照ポリシー（公式順序）

- 本リポジトリでは `.junie/AGENTS.md` を最優先の運用ガイドラインとする。
- `.junie/guidelines.md` はレガシー形式として参照可能だが、運用ルールは本ファイルに集約する。
- ルール追加・更新時は本ファイルを先に更新し、必要に応じて補足をレガシーファイルへ反映する。

## 作業の基本方針

- 変更は小さく、既存スタイル・既存設計に合わせる。
- 不明点は推測で実装せず、仕様・テスト・OpenAPIを確認する。
- 長時間常駐プロセスや新規外部サービスは、要求がある場合のみ導入する。

## 実行コマンド方針

- タスク・テスト・開発で使うコマンドは `package.json` に定義されたもののみ使用する。
- Windows は PowerShell を前提にする（パスは `\`、連結は `;`）。

## 実行コマンド（標準）

### ルート

- 依存インストール: `yarn install`
- バックエンド/フロント同時起動: `yarn dev`
- フック手動実行: `yarn lefthook run pre-commit`

### Backend (`apps\\backend`)

- 依存インストール: `cd apps\backend; bundle install`
- 起動: `cd apps\backend; yarn dev`
- DBマイグレーション: `cd apps\backend; yarn migrate`
- テスト: `cd apps\backend; yarn test`
- Lint: `cd apps\backend; yarn lint`
- Typecheck: `cd apps\backend; yarn typecheck`

### Frontend (`apps\\frontend`)

- 依存インストール: `cd apps\frontend; yarn install`
- 起動: `cd apps\frontend; yarn dev`
- テスト: `cd apps\frontend; yarn test`
- E2E: `cd apps\frontend; yarn test:e2e`
- API型生成: `cd apps\frontend; yarn generate:api-types`

## テスト実行方針

- `apps/backend/lib` の変更時は、関連RSpecを実行する。
- バックエンドの広範囲変更時は `cd apps\backend; yarn test` を実行する。
- フロントエンド変更時は対象レイヤーに応じたテストを実行する。
  - `src/util`: Unit tests
  - `src/features/pages`: Integration tests
  - `src/routes`: Unit tests
  - `src/lib`: Unit tests
- OpenAPI変更時は `cd apps\frontend; yarn generate:api-types` を実行する。
- ドキュメントのみの変更はテスト不要。

## コードスタイル

- LF改行を使用する。
- Rubyは `apps/backend/lib` の既存スタイル・命名・構成に従う。
- 公開API変更時は `apps/backend/sig` の整合性を保つ。
- RSpecは近傍の既存記法に合わせる。
- JavaScript/TypeScriptは `apps/frontend/src` の既存パターンに従う。

## 参照先

- 仕様不明時は `apps/backend/spec` と `apps/backend/openApi` を優先参照する。
- OpenAPIはバックエンドの入出力仕様と、フロントエンド型生成の基準とする。

## プロジェクト構造（主要ディレクトリ）

- ルート
  - `apps/backend` — Rubyバックエンド本体
  - `apps/frontend` — フロントエンド本体
  - `docker-compose.yaml` — ローカル開発用サービス定義
  - `lefthook.yml` — Git hooks 設定
  - `package.json`, `turbo.json` — モノレポの実行・タスク管理

- `apps/backend`
  - `lib`
    - `app_exception` — カスタム例外定義
    - `constant` — 定数定義
    - `application` — ユースケース層（例: `use_case/auth/signup_use_case.rb`）
    - `domain` — エンティティ・リポジトリIFなどドメイン層
    - `infrastructure` — ROMエンティティ/リポジトリなど永続化実装
    - `presentation` — controller / request / response など入出力層
  - `spec`
    - `integration` — 認証・コントローラのE2E寄りテスト
    - `application` — ユースケースのテスト
    - `domain` — ドメインロジックのテスト
    - `infrastructure` — repository/entity のテスト
    - `presentation` — request/response/controller のテスト
  - `openApi`
    - `openapi.yaml` — OpenAPIエントリポイント
    - `components/` — schema 等のコンポーネント定義
    - `paths/` — APIパス定義
  - `sig`
    - `generated` — 生成RBS
    - `stub` — 手動管理スタブRBS
  - `helper` — 共通ヘルパー（JWT検証・レスポンス整形等）。ユニットテスト不要。
  - `tasks` — Rakeタスク（例: DBマイグレーション）。ユニットテスト不要。
  - `schema` — テーブル定義などDB関連定義

- `apps/frontend`
  - `src`
    - `components` — ロジックレスUIコンポーネント
    - `features/components` — ビジネスロジックを持つコンポーネント
    - `features/pages` — API呼び出しと機能コンポーネントのオーケストレーション
    - `routes` — ルート定義
    - `lib` — ドメイン共通関数
    - `util` — 汎用ユーティリティ
    - `schema` — スキーマ/型関連定義（例: Zod, Valibot, API types）
    - `hooks` — 再利用フック
  - `package.json` — フロントエンド用スクリプト定義

## Infrastructure 層のリポジトリ追加時の注意

- `apps/backend/lib/infrastructure/repository/` 配下に新しいリポジトリクラスを**追加**した場合は、
  対応する `apps/backend/sig/stub/infrastructure/repository/` 以下の `.rbs` ファイルも必ず追加してください。
- 既存リポジトリの編集のみの場合は、RBS スタブファイルの更新は不要です。
- **対象は `rom/` 配下のリポジトリのみです。** `rom/` 以外のリポジトリ（例：`work_space/` や `content_api/`
  直下）に対してはRBSスタブの作成は不要です。
- 例：`lib/infrastructure/repository/rom/work_space/new_rom_repository.rb` を新規追加した場合は
  `sig/stub/infrastructure/repository/new_rom_repository.rbs` も合わせて作成すること。
