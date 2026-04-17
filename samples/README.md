# terraform
terraformとconftestのテスト用リポジトリです。このリポジトリではテスト対象となるterraformプロジェクトを管理します。

https://github.sakura.codes/hi-ito/terraform-policy にて、テストの実体となるOPAのルールを管理しています。

## 実行方法
予めconftest, OPAをインストール済みである前提です。

- https://www.conftest.dev/install/
- https://www.openpolicyagent.org/docs/latest/#1-download-opa

```sh
# ポリシーをダウンロード
$ conftest pull 'git::https://github.com/sacloud/terraform-provider-sakuracloud-policy.git//policy?ref=v1.1.0'

# 通常のテスト実行
$ conftest test . --ignore=".git|.terraform"

# 特定のリソースを例外としたい場合
$ conftest test . --ignore=".git/|.terraform/" --data="exception.yml"
```
