plan:
	terraform plan

apply:
	terraform apply -auto-approve

init:
	terraform init

show:
	terraform show

## recreate terraform resources
rebuild: destroy apply

destroy:
	terraform destroy -auto-approve

metadata:
	terraform refresh && terraform output
