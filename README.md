# はじめに
GithubActionsでTerraformを利用して、GKEクラスタを作成するリポジトリです。

# GKEクラスタ構成
|||
|-|-|
|マシンタイプ|f1-micro|
|ノード数|1|
|プリエンティブノード数|2|
|ゾーン|us-west1-1|

## クラスタ費用について
* GKEにおいてmasterNodeは元から無料
* WorkerNodeにおける1Nodeは無料枠の「f1-micro」で作成
* WorkerNodeの残り2Nodeは安価なpreemptibleで作成
  - ただし、preemptibleなインスタンスは安価な代わりに様々な制約がある。
  - 詳細は参考に示す公式ドキュメントを確認すること

# 参考
* [Terraform公式](https://www.terraform.io/docs/providers/google/r/container_cluster.html)
* [プリエンプティブル VM インスタンス](https://cloud.google.com/compute/docs/instances/preemptible?hl=ja)


# メモ書き

* このクラスターでクライアント証明書が有効かどうか
```
remove_default_node_pool = true
```

* ノードを自動的に修復するか
```
management.auto_repair = true
```

* 以前のメタデータAPIを無効にして新しいノードプールを作成する
```
metadata.disable-legacy-endpoints = "true"
```

* 作成するNODEインスタンスをプリランプティブなものにするか  
```
node_config.preemptible = true
```
※preemptibleインスタンスを使った場合は価格がかなり安くなるが以下のような特性を持つ
* 勝手にシャットダウンされる
* 最大4時間しか起動しつづけられない
* 要求したタイミングでインスタンスを立ち上げることができない可能性もある

* kubernetesマスターAPIにアクセスするためのbasic認証情報(両方を空にすることで明示的に無効にできる)
```
  master_auth {
    username = ""
    password = ""
```


## node_config.oauth_scopes 
- https://www.googleapis.com/auth/logging.write  
roles/logging.logWriterの権限が付与される
- https://www.googleapis.com/auth/devstorage.read_only  
バケットの一覧表示を含め、データを読み取るためのアクセスのみを許可される
- https://www.googleapis.com/auth/monitoring  
Monitoring に対する完全アクセス権