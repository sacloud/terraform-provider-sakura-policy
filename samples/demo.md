# demo
Conftest, OPA, Regoを利用した、terraformの静的チェックのデモ説明用資料です。

## Conftest, OPA, Regoとは？
### OPA
https://www.openpolicyagent.org/docs/latest/

汎用ポリシーエンジン。これが核となってPolicy as Code (PaC)を実現する。

### Rego
https://www.openpolicyagent.org/docs/latest/policy-language/

OPAで動作するポリシーを記述するための言語。

### Conftest
https://www.conftest.dev/

OPAとRegoを利用して、k8sマニフェストやterraformコードのポリシー違反を検査してくれるツール。

## 全体構成
### terraformリポジトリ
- さくらのクラウド利用者が手元につくるterraformリポジトリ

### policyリポジトリ
- [terraform sakuracloud provider](https://docs.usacloud.jp/terraform/) を利用したterraformコードに対するセキュリティ・ガバナンスのpolicyを管理するリポジトリ
  - サンプルは https://github.sakura.codes/hi-ito/terraform-policy になります
- `policy/` 配下に[Rego](https://www.openpolicyagent.org/docs/latest/policy-language/)で記述されたルール及び、それらのテストコードが配置されています
  - ルールの記述においてはConftestに依存する書き方もあるため注意が必要
- なお、正式リリース時は https://github.com/sacloud/ 配下にリポジトリを作成する予定です（リポジトリ名は `terraform-provider-sakuracloud-policy` とか？）

## GitHub Actionsで実行 (2 step)
### 1. GitHub Actions用のymlを作成
terraformリポジトリ内にGitHub Actions用のymlを作成します。

今回は [.github/workflows/test.yml](.github/workflows/test.yml) に既に作成済みです。

### 2. 適当なPRを作り、Github Actions上でConftestを実行
https://github.sakura.codes/hi-ito/terraform/pull/3

## 手元で実行
### 1. OPA, Conftestのインストール
- https://www.openpolicyagent.org/docs/latest/#1-download-opa
- https://www.conftest.dev/install/

### 2. terraformのサンプルリポジトリ（本リポジトリ）をclone
```sh
$ git clone git@github.sakura.codes:hi-ito/terraform.git
$ cd terraform
```

### 3. 実行
```sh
# ポリシーをダウンロード
$ conftest pull git::git@github.sakura.codes:hi-ito/terraform-policy.git//policy

# 実行
$ conftest test . --ignore=".git/|.github/|.terraform/"
WARN - proxylb.tf - main - sakuracloud_proxylb.fail_proxylb_1 にsyslogサーバが設定されていません。
FAIL - proxylb.tf - main - sakuracloud_proxylb.fail_proxylb_1 HTTPからHTTTPSへのリダイレクトが有効化されていません。
FAIL - server.tf - main - sakuracloud_server.fail_server_1 でパスワード認証が有効化された状態で password が設定されています。
WARN - vpc_router.tf - main - sakuracloud_vpc_router.fail_vpc_1 にsyslogサーバが設定されていません。
FAIL - vpc_router.tf - main - sakuracloud_vpc_router.fail_vpc_1 でインターネット接続が有効化された状態で、グローバルインターフェースにファイアウォールが設定されていません。
FAIL - lb.tf - main - sakuracloud_load_balancer.fail_lb_1 のVIPアドレスで80番ポートが公開されています。
FAIL - disk.tf - main - sakuracloud_disk.fail_disk_1 でディスク暗号化機能が有効化されていません。
FAIL - enhanced_db.tf - main - sakuracloud_enhanced_db.fail_enhanced_db_1 でデータベースに接続できる送信元ネットワークが制限されていません。

112 tests, 104 passed, 2 warnings, 6 failures, 0 exceptions
```

## ポリシーのテスト
- ポリシーが期待通りに動作するかどうかをテストすることができます
- テストコードはポリシーと同じディレクトリで管理され、Goのようにファイル名末尾に `_test` を付与します
- テストを記述したら `conftest verify` でテストを実行することができます
- ここではGitHub ActionsによるCIの紹介をします

### 1. GitHub Actions用のymlを作成
[/hi-ito/terraform-policy/.github/workflows/verify.yml](https://github.sakura.codes/hi-ito/terraform-policy/blob/main/.github/workflows/verify.yml) に作成済み。

### 2. 適当なPRを作り、Github Actions上でポリシーのテストを実行
https://github.sakura.codes/hi-ito/terraform-policy/pull/2
