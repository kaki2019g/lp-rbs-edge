# RBS.edge Landing Page

RBS.edgeの販売用ランディングページです。  
HTML、CSS、JavaScriptのみで構成されており、ビルド処理を行わずFirebase Hostingへ公開できます。

## 主な内容

- 商品の特徴、バックテスト結果、稼働画面の紹介
- 取引履歴、利用者の声の画像ギャラリー
- 商品内容、FAQ、価格、推奨動作環境の案内
- 投資リスクおよび注意事項の表示
- 特定商取引法に基づく表記
- スクロールに連動した表示アニメーション
- PC、タブレット、スマートフォン向けのレスポンシブ表示

## 技術構成

- HTML5
- CSS3
- Vanilla JavaScript
- Firebase Hosting

フレームワークやパッケージ管理ツールは使用していません。

## ディレクトリ構成

```text
.
├── index.html          # 商品ランディングページ
├── legal.html          # 特定商取引法に基づく表記
├── styles.css          # 共通スタイル、レスポンシブ対応
├── script.js           # 購入リンク制御、表示アニメーション
├── assets/             # 公開ページで使用する画像
│   ├── banners/        # アフィリエイト向けバナー（公開対象外）
│   └── old/            # 旧画像（公開対象外）
├── affiliate-guide.md  # アフィリエイター向け紹介資料（公開対象外）
├── firebase.json       # Firebase Hosting設定
└── .firebaserc         # Firebaseプロジェクト設定
```

## ローカルで確認する

このサイトは静的ファイルのみで動作します。リポジトリのルートでHTTPサーバーを起動してください。

```bash
python3 -m http.server 8080
```

ブラウザで以下を開きます。

```text
http://localhost:8080/
```

ファイルを直接開くこともできますが、公開環境に近い状態で確認するためHTTPサーバーの利用を推奨します。

## 購入URLを設定する

購入ボタンには`.purchase-link`クラスが付いています。全購入ボタンを同じ決済ページへ遷移させる場合は、`script.js`の`PURCHASE_URL`を設定します。

```js
const PURCHASE_URL = "https://example.com/order";
```

`PURCHASE_URL`が空文字の場合、各リンクに記述された`href`がそのまま使用されます。現在は価格欄のボタンにInfotopの決済URLが設定され、それ以外の購入ボタンは価格欄へ移動する構成です。

URL変更後は、ヘッダー、ファーストビュー、価格欄、モバイル固定ボタンの全導線を確認してください。

## Firebase Hosting

### 前提条件

- Node.js
- Firebase CLI
- 対象Firebaseプロジェクトへのデプロイ権限

Firebase CLIを未導入の場合:

```bash
npm install -g firebase-tools
firebase login
```

### プレビュー

```bash
firebase emulators:start --only hosting
```

### デプロイ

```bash
firebase deploy --only hosting
```

デフォルトのFirebaseプロジェクトは`.firebaserc`の`test-8abb4`です。別環境へ公開する場合は、デプロイ前に対象プロジェクトを確認してください。

```bash
firebase use
```

### Hosting設定

`firebase.json`では次の設定を行っています。

- リポジトリのルートを公開ディレクトリとして使用
- HTML、CSS、JavaScriptは常に再検証
- 画像は24時間キャッシュ
- 拡張子を省略したURLを有効化（例: `/legal`）
- 基本的なセキュリティヘッダーを付与
- 管理資料、バナー、旧画像、READMEを公開対象から除外

公開ディレクトリが`.`のため、新しいファイルを追加すると原則として公開対象になります。運用資料や公開不要なファイルを追加した場合は、`firebase.json`の`hosting.ignore`にも追加してください。

## コンテンツ更新時の確認項目

1. `index.html`内の価格、商品内容、動作環境、実績数値を確認する
2. `legal.html`の販売者情報、価格、支払方法、引渡条件を確認する
3. `affiliate-guide.md`の記載内容と商品ページの内容を一致させる
4. 購入ボタンが正しい決済ページへ遷移することを確認する
5. 画像のリンク切れ、代替テキスト、PC・スマートフォン表示を確認する
6. 利益保証と誤認される表現がなく、リスク表示が維持されていることを確認する

バックテスト結果や運用実績は将来の利益を保証するものではありません。数値や訴求表現を変更する際は、根拠資料と広告・販売に関する規約を確認してください。
