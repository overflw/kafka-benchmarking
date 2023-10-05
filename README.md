# Kafka benchmarking

This repo contains terraform configs to setup a kafka cluster for benchmarking on google cloud platform (gcp) and amazon web services (aws).

Be careful with costs caused by using the cloud providers - unfortunately we could not use free-tier vm-instances, as they do not offer enough RAM to run our benchmarking setup.

### Setup 

If you are setting up for the first time, follow the [intitial setup steps](#initial-setup-aws).

#### Machine deployment terraform 

You can execute the terraform configs via the corresponding make commands.

First enter the folder with the terraform files for amazon web services (aws):

    cd aws

If you have your gcp or aws credentials in place you can now plan and apply the terraform config with:

    make apply

To deprovision the deployed instances just run:

    make destroy

#### Machine deployment terraform with ansible

When the vm instances are deployed you can set up the kafka cluster with the confluent ansible playbooks. First, change to the ansible folder

    cd ansible

To apply the _kafka-confluent playbooks_ on the created vms using our automatically created inventory file `hosts.yml`, use:

    ansible-playbook -i hosts.yml confluent.platform.all


To deploy the _benchmark test client_ from the openmessaging benchmarking tool run:

    ansible-playbook -i hosts.yml client_deploy.yaml


To deploy the _anoniks framework_ from the ganges students project run:

    ansible-playbook -i hosts.yml anoniks_deploy.yaml


#### Initial setup: AWS

Login to aws and create credentials (access key & ssh key):
Account(top right) -> security credentials -> access keys -> create access key -> command line interface -> enter tag value & create

We can use the id and key either via exporting them as enviroment variables: 

    export AWS_ACCESS_KEY_ID=<access-key-id>
    export AWS_SECRET_ACCESS_KEY=<access-key-secret>

Or install the `awscli2` and follow the `aws configure` flow.

We also need to add a ssh-public-key to aws. We can either generate the key-pair in their frontend or copy the public key of an existing local keypair to their backend. Since ssh-keys are stored per region, lets first change to eu-central-1, the region configured per default in our terraform config. You can find this setting in the top right. Now we can create or import the ssh-key: EC2 -> Network & Security (Key Pairs) -> either Actions (Import ..) or Create key pair (top right)
The key name referenced by default from our terraform config is "tf-key"


#### Initial setup: terraform

Install [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

Change to aws directory

    cd aws

To initialize terraform execute:

    make init


#### Initial setup: ansible

The kafka deployment playbook from confluent can be installed with:

    ansible-galaxy collection install confluent.platform

The open-messaging client archive, required for the `client-deploy.yml` playbook, can be created via the docker file:

    cd ansible/om-benchmark
    docker run --rm -v ./:/benchmark-target $(docker build -q .)

### Benchmarking

ssh into the machine

    ssh -i ~/.ssh/<your-key> ubuntu@<your-client-machine>


### Tips / Notes

Each vm is provisioned with a `ubuntu` user and the given ssh key.

Useful to check the services functionality on the vms is the following systemctl command:

    systemctl status confluent*



