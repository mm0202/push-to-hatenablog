# push-to-hatenablog
 GitHubとはてなブログの連携用環境。GitHubに記事の編集内容をプッシュするとはてなブログの記事も更新されます。

## セットアップ
### GitHubリポジトリの追加
はてなブログ記事の管理用にGitHubリポジトリを作成してください。
### `blogsync.yaml`の追加
`blogsync.example.yaml`を`blogsync.yaml`に変更して、ドメイン名やユーザ名を書き換えてください。  
ローカル環境から記事を新規追加するために使用します。

`blogsync.yaml`については、以下のページを参照してください。

[x-motemen/blogsync #Configuration](https://github.com/x-motemen/blogsync#configuration)

### Secretの追加
GitHubリポジトリに以下の２つのSecretを追加してください。  
GitHubアクションで記事を更新するために使用します。
* `DOMAIN`という名前でSecretを追加してください。値にはブログのドメイン名を設定してください。
* `BSY`という名前で以下のような値のSecretを追加してください。
```yaml
[ブログのドメイン]:\n
  username: [ユーザ名]\n
  password: [AtomPubのAPIキー]\n
default:\n
  local_root: entries
```

※ Secretsの追加は`GitHubリポジトリページ/Settings/Secrets`から設定できます。詳細は以下のページを参照してください。

[暗号化されたシークレットの作成と保存 #暗号化されたシークレットの作成](https://help.github.com/ja/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets#about-encrypted-secrets)

## はてなブログからの記事取得
既存記事をはてなブログから取得する場合は、`domain`変数を指定してから、masterブランチで以下のコマンドを実行してください。
```bash
docker-compose run --rm blogsync pull ${domain}
```
はてなブログの更新はmasterブランチからの差分が対象となります。

記事数が多いとはてなブログの更新に時間がかかるため、masterブランチで記事を取得・コミットして、ブログの更新を回避してください。

特に初回の記事取得など記事数が多い場合はmasterブランチで取得するようにしてください。

## 新しい記事の追加
`path`と`domain`変数を設定して、以下のコマンドを実行するとはてなブログとローカルに下書きが追加されます。
```bash
docker-compose run --rm blogsync post --title=draft --draft --custom-path=${path} ${domain} < draft.md
```

## 編集した記事の更新
編集した記事ファイルをGitHubへプッシュすると、GitHubアクションによってmasterブランチからの差分がはてなブログでも更新されます。

GitHubアクションの設定は以下を確認してください。

[.github/workflows/push.yml](.github/workflows/push.yml)

※ masterブランチからの差分が更新対象となるため、masterブランチで記事ファイルを編集しても記事の更新は実行されません。master以外のブランチで編集してください。

## Slack通知設定
### `.github/workflows/push.yml`の調整
Slackに更新ワークフローの結果を通知する場合は、[.github/workflows/push.yml](.github/workflows/push.yml)内の以下のコメントアウトを解除してください。
```yaml
# - name: notify to slack
#   uses: mm0202/action_slack-notify@master
#   if: always()
#   env:
#     SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

### Secretの追加
`GitHubリポジトリページ/Settings/Secrets`から以下のSecretを追加してください。
| key | value
| - | - 
| SLACK_WEBHOOK_URL | Incoming Webhookで指定されたWebhook URL

## `scripts`ディレクトリについて
`scripts`ディレクトリに記事の取得、投稿スクリプトを設置しています。

`scripts`内のスクリプトを使用する場合は、`.env`ファイルを作成して`DOMAIN=[ブログのドメイン]`を追加してください。

### 記事の取得
ルートディレクトリで`scripts/pull.sh`を実行してください。

`npm`(または`yarn`)環境がある場合は、`npm run pull`(または`yarn run pull`)でも記事を取得できます。

### 記事の投稿
`scripts/pull.sh`の`custom_path=[custom_path]`の部分に投稿する記事のカスタムパスを設定して、ルートディレクトリで`scripts/pull.sh`を実行してください。

`npm`(または`yarn`)環境がある場合は、`npm run push`(または`yarn run push`)でも記事を取得できます。

