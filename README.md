# はじめに

GithubActions で Terraform を利用して、GKE クラスタを作成するリポジトリです。

## GKE クラスタ構成

|                        |            |
| ---------------------- | ---------- |
| ノード数               | 0          |
| プリエンティブノード数 | 1          |
| ゾーン                 | us-west1-a |

## クラスタ費用について

- GKE において masterNode は元から無料
- WorkerNode における 1Node は無料枠の「f1-micro」で作成
  - f1-micro サイズでは割り当てメモリが足りずサポートできない旨のエラーメッセージが出るようになった(2020/4)
  - preemptible ノードのみで稼働可能なため、無料枠の f1-micro の NODE はコメントアウトする
  - エラーメッセージ : `error creating NodePool: googleapi: Error 400: Node pools of f1-micro machines are not supported due to insufficient memory., badRequest`
- WorkerNode の残り Node は安価な preemptible で作成
  - ただし、preemptible なインスタンスは安価な代わりに様々な制約がある。
  - 詳細は参考に示す公式ドキュメントを確認すること

## JOB の手動実行

以下のコマンドで push を行わずに master ブランチの状態で apply or destroy を行うことができる

```bash
curl -vv \
  -H "Authorization: token $PERSONAL_ACCESS_TOKEN" \
  -H "Accept: application/vnd.github.everest-preview+json" \
  "https://api.github.com/repos/sabure500/gke-terraform/dispatches" \
  -d '{"event_type": "apply or destroy", "client_payload": {"target_brunch": "master"}}'
```

## 参考

- [google_container_cluster](https://www.terraform.io/docs/providers/google/r/container_cluster.html)
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google/)
- [プリエンプティブル VM インスタンス](https://cloud.google.com/compute/docs/instances/preemptible?hl=ja)
- [利用可能な GKE クラスタ バージョン](https://cloud.google.com/run/docs/gke/cluster-versions)
- [VM インスタンスの料金](https://cloud.google.com/compute/vm-instance-pricing)
- [Create a repository dispatch event](https://developer.github.com/v3/repos/#create-a-repository-dispatch-event)
- [Terraform 用の Github Action](https://github.com/hashicorp/setup-terraform)

## メモ書き

- デフォルトの Node を削除するかどうか(true の場合は initial_node_count を 1 にする)

```h
remove_default_node_pool = true
initial_node_count       = 1
```

- このクラスターでクライアント証明書が有効かどうか

```h
remove_default_node_pool = true
```

- ノードを自動的に修復するか

```h
management.auto_repair = true
```

- 以前のメタデータ API を無効にして新しいノードプールを作成する

```h
metadata.disable-legacy-endpoints = "true"
```

- 作成する NODE インスタンスをプリランプティブなものにするか

```h
node_config.preemptible = true
```

※preemptible インスタンスを使った場合は価格がかなり安くなるが以下のような特性を持つ

- 勝手にシャットダウンされる
- 最大 4 時間しか起動しつづけられない
- 要求したタイミングでインスタンスを立ち上げることができない可能性もある

- kubernetes マスター API にアクセスするための basic 認証情報(両方を空にすることで明示的に無効にできる)

```h
  master_auth {
    username = ""
    password = ""
```

- GKE 上で稼働するデフォルトの Pod を最小限にする

```h
  monitoring_service = "none"
  logging_service    = "none"
```

## node_config.oauth_scopes

- <https://www.googleapis.com/auth/logging.write>  
  roles/logging.logWriter の権限が付与される
- <https://www.googleapis.com/auth/devstorage.read_only>  
  バケットの一覧表示を含め、データを読み取るためのアクセスのみを許可される
- <https://www.googleapis.com/auth/monitoring>  
  Monitoring に対する完全アクセス権
