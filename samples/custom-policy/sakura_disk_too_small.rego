package main

import data.exception
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