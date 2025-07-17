# dev-storage-infra

### このレポジトリの運用について

#### ■概要
systemadminアカウントで稼働しているdev-storage用のCloudFront、S3といったリソースを管理するためのリポジトリです。
Route53のレコードを除き、インフラはterraformで作成しています。

運用時は次の用途で利用されます。  
・顧客案件の追加・削除の際のCloudFrontの設定変更およびCloudFrontFunction（Basic認証用）の作成と紐付け  
・コンテンツ配信用S3バケットへのファイルのアップロード  

#### ■関係者
terraformテンプレートの作成者　：　SREユニット  
利用者　：　モバイルアプリユニット

#### ■運用手順
前提として、CloudFront関連の設定とS3へのファイルアップロードは全く別の仕組みです。  
同時に実施しても別々に実施しても問題ありませんし、それぞれの処理が他方に影響することはありません。

次の操作が可能です。

- 案件の追加/削除
- ファイルの追加/削除/変更

操作によって手順、注意点が異なります。
GitLab-CI の Job が動き出すタイミングによる違いなので、それぞれ確認してください。

##### ・案件の追加/削除をするとき

 - mainブランチから(add_******** | delete_********)ブランチを作成
 - terraform/env/prod.tfvarsファイルを編集
 - 変更を(add_******** | delete_********)ブランチにプッシュ
 - gitlabCIにより変更が反映（自動処理）
 - 変更をmainブランチへマージ

prod.tfvarsというファイルに各案件の識別子とBasic認証の認証情報（Base64エンコード済み）のマップがあります。  
これを編集して変更をプッシュすることで反映されますが、 **追加と削除で処理が異なる** ため、必ず以下の命名規則に沿ったブランチを作成しそこにプッシュするようにしてください。  
※各ブランチへプッシュした時点で変更は反映されますが、その後必ずmainブランチへマージしてください。（mainへのマージの際はCIジョブは実行されません）

| 処理内容 | ブランチ名 |
| ---- | ---- |
| 追加 | add_******** |
| 削除 | delete_******** |
  

変更すべきファイルは下記のとおりです。  
./terraform/env/prod.tfvars

```shell
identifiers = {
  "Nonstress"             = "Tm9uU3RyZXNzOk5HOXlUdEho",
  "datakit-tester"        = "dWNoaW5ldG1vYmlsZTpWZm43RWlXZHZ3OFF0QQ=="
  "prime-assistance-test" = "ZGZndmhqYms6eGRjZmd2aGpia25s"
  "r1"                    = "cjE6cjE="
  "recognitions"          = "cmVjb2duaXRpb25zOnJlY29nbml0aW9ucw=="
  "tohmatsu"              = "dG9obWF0c3U6cnNzM2tX"
  "tohmatsu-as"           = "dG9obWF0c3VhczphczIwMjE="
  "tohmatsu-test"         = null #Basic認証が不要の場合は null
  "tohmatsu-as-uat"       = "dG9obWF0c3Vhc3VhdDphc3VhdDIwMjE="
  "YarukiSwitch"          = "eXNnOmVNM0JTZkF1"
  "YSG"                   = "eXNnOmVNM0JTZkF1"
}

# 上記のマップに案件を追加/削除していく
# 順序は設定に影響を与えない
```

##### ・ファイルの追加/削除/変更をするとき

 - mainブランチから任意名のブランチを作成（※）
 - applications/ ディレクトリ配下にファイルを追加・削除
 - 変更を作業ブランチへプッシュ
 - 変更をmainブランチへマージ
 - gitlabCIにより変更が反映（自動処理）

applicationsディレクトリ配下のディレクトリおよびファイルがS3バケットと同期します。（S3 syncコマンド）  
アップロードしたいファイルを追加し、変更を **mainブランチ** にプッシュすることでgitlabCIジョブによりS3にファイルが同期されます。  
条件は「mainブランチへの変更であること」「applicationsディレクトリ以下への変更であること」の2点だけです。

なお、同期ですのでレポジトリ上で削除したファイルはS3からも削除されます。

※ 案件の追加/削除をしない場合はブランチ名を(add_******** | delete_********)以外で設定してください。


# 問い合わせ先

何か不都合があれば、モバイルアプリユニット役職者（特に清水）までご連絡ください。