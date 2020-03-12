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

## 新規追加
`path`と`domain`変数を設定して、以下のコマンドを実行するとはてなブログとローカルに下書きが追加されます。
```bash
docker-compose run go blogsync post --title=draft --draft --custom-path=${path} ${domain} < draft.md
```

## 一括更新
編集した記事ファイルをGitHubへプッシュすると、GitHubアクションによってmasterブランチからの差分がはてなブログでも更新されます。

GitHubアクションの中身は以下を確認してください。

[.github/workflows/push.yml](.github/workflows/push.yml)

※ masterブランチからの差分を更新するため、masterブランチで編集しても更新されません。master以外のブランチで編集してください。
