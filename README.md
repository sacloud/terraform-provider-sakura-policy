# terraform-policy

![conftest verify](https://github.com/sacloud/terraform-provider-sakura-policy/actions/workflows/verify.yml/badge.svg)

This repository manages the standard policies for security and governance checks in Terraform code that utilizes the [terraform-provider-sakura](https://github.com/sacloud/terraform-provider-sakura). It leverages OPA (Open Policy Agent) and Conftest to ensure comprehensive policy enforcement.

## Directories

- policy: OPA based Rules for terraform-provider-sakura
- samples: Configuration samples for policy testing

## Usage Example

This assumes that OPA and Conftest are installed in the execution environment.

- https://www.openpolicyagent.org/docs/latest/#running-opa
- https://www.conftest.dev/install/

### Usage in Local Environment

This is the method for Terraform code implementers to run the policy checks in their local environment.

As mentioned earlier, OPA and Conftest must be installed in the local environment.

```sh
# Run within the Terraform repository that uses the terraform-provider-sakura
$ cd terraform

# Download the policy
$ conftest pull 'git::https://github.com/sacloud/terraform-provider-sakura-policy.git//policy'

# Run the tests
$ conftest test . --ignore=".git/|.github/|.terraform/"
```

If you use mise to install conftest, use `mise exec conftest -- conftest test` instead of `conftest test`

### GitHub Actions

This is the method to perform CI (Continuous Integration) using [GitHub Actions](https://docs.github.com/ja/actions).

```yaml
name: conftest terraform policy check
on:
  pull_request:
env:
  CONFTEST_VERSION: 0.67.1
jobs:
  test:
    name: policy check
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd # v6.0.2
        with:
          fetch-depth: 0

      - name: Install Conftest
        run: |
          mkdir -p $HOME/.local/bin
          echo "$HOME/.local/bin" >> $GITHUB_PATH
          wget -O - 'https://github.com/open-policy-agent/conftest/releases/download/v${{ env.CONFTEST_VERSION }}/conftest_${{ env.CONFTEST_VERSION }}_Linux_x86_64.tar.gz' | tar zxvf - -C $HOME/.local/bin

      - name: Conftest version
        run: conftest -v

      - name: download policy
        run: conftest pull 'git::https://github.com/sacloud/terraform-provider-sakura-policy.git//policy'

      - name: run test
        run: conftest test ./samples --ignore=".git/|.github/|.terraform/" --data="samples/exception.json"
```

## Exception
You can use the Exception feature in Conftest to treat specific rules as exceptions.

In the Conftest execution environment, add a YAML file like the one below. This file should list the names of the rules that you want to treat as exceptions.

```yaml
exception:
  rule:
    - sakura_disk_not_encrypted
```

Then, use the [--data](https://www.conftest.dev/options/#-data) option with the `conftest test` command to load the above file.

This will cause the listed rules to be counted as exceptions, not failures.

```sh
$ conftest test samples/disk.tf --ignore=".git/|.github/|.terraform/" --data="samples/exception.yml"
EXCP - samples/disk.tf - main - data.main.exception[_][_] == "sakura_disk_not_encrypted"

9 tests, 8 passed, 0 warnings, 0 failures, 1 exception
```

## Custom Policies
In addition to the default policies provided, users can add their own custom policies.

For example, by incorporating organization-specific rules, you can ensure that your infrastructure adheres to your organization’s unique policies and guidelines.

### 1. Creating a Custom Policy
Prepare a `.rego` file where you define the custom policy. It is assumed that this file will be managed in the same repository as the Terraform code.

Below is an example of creating a file named `/samples/custom-policy/sakura_disk_too_small.rego`.

This example defines a custom policy that returns an error when the disk size is less than 40GB.

```rego
package main

import data.helpers.has_field
import rego.v1

deny_sakura_disk_too_small contains msg if {
    resource := "sakura_disk"
    rule := "sakura_disk_too_small"

    some name
    disk := input.resource[resource][name][_]
    disk.size < 40

    msg := sprintf(
        "%s\nDisk is too small %s.%s\n",
        [rule, resource, name],
    )
}
```

### 2. Running Custom Policies with the conftest Command

To apply custom policies in addition to the default policies, use the [--policy](https://www.conftest.dev/options/#-policy) option of the `conftest test` command as shown below.

This command applies both the default policies in the `policy/` directory and the custom policies in the `samples/custom-policy/` directory.

```sh
$ conftest test samples/disk.tf --ignore=".git/|.github/|.terraform/" --policy="policy/" --policy="samples/custom-policy/"
FAIL - samples/disk.tf - main - sakura_disk_too_small
Disk is too small sakura_disk.fail_disk_1

FAIL - samples/disk.tf - main - sakura_disk_not_encrypted
Disk encryption is not enabled in sakura_disk.fail_disk_1
More Info: https://docs.usacloud.jp/terraform-policy/rules/sakuracloud_disk/not_encrypted/


9 tests, 7 passed, 0 warnings, 2 failures, 0 exceptions
```

## Requirements
[Open Policy Agent](https://www.openpolicyagent.org/) v1.14.1+

[Conftest](https://www.conftest.dev/) v0.67.1+

[Terraform provider for Sakura](https://registry.terraform.io/providers/sacloud/sakura/latest) v3.6.0+

## TODO

- Support new resources since terraform-provider-sakura v3.
- Update link to docs.usacloud.jp. docs.usacloud.jp pages will be migrated to SAKURA's manuals.

## License

`terraform-proivder-sakura-policy` Copyright (C) 2026- terraform-provider-sakura-policy authors.

This project is published under [Apache 2.0 License](LICENSE).
