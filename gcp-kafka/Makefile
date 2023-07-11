THISDIR := $(notdir $(CURDIR))
PROJECT := $(THISDIR)

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

## ssh into VM, unique after each rebuild so refresh known_hosts
# ssh:
# 	ssh-keygen -f ~/.ssh/known_hosts -R $(IP)
# 	ssh-keyscan "$(IP)" >> ~/.ssh/known_hosts
# 	ssh sysadmin@$(IP) -i id_rsa

## create public/private keypair for ssh
# create-keypair:
#	@echo "THISDIR=$(THISDIR)"
#	ssh-keygen -t rsa -b 4096 -f id_rsa -C $(PROJECT) -N "" -q

metadata:
	terraform refresh && terraform output

## validate syntax of cloud_init
validate-cloud-config:
	cloud-init schema --config-file ./cloud_init_ubuntu.cfg
