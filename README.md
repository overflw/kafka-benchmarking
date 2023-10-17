# Kafka benchmarking

This repository contains terraform configs to setup a kafka cluster for benchmarking on amazon web services (aws).

Be careful with costs caused by using the cloud providers - unfortunately we could not use free-tier vm-instances, as they do not offer enough resources to run the open-messaging benchmarking setup.

### Setup 

If you are setting up for the first time, follow the [intitial setup steps](#initial-setup-aws).

#### Machine deployment terraform 

You can execute the terraform configs via the corresponding make commands.

Enter the folder with the terraform files for amazon web services (aws). 
If you have your aws credentials in place you can plan and apply the terraform config with:

    cd aws
    make apply

To deprovision the deployed instances, after benchmarking, just run:

    make destroy

#### Machine deployment terraform with ansible

When the vm instances are deployed you can set up the kafka cluster with the confluent ansible playbooks. First, change to the ansible folder

    cd ansible

To apply the _kafka-confluent playbooks_ on the created vms using our automatically created inventory file `hosts.yml`, use:

    ansible-playbook -i hosts.yml confluent.platform.all

To deploy the _benchmark client_ from the openmessaging benchmarking tool run:

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

Install [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

Change to aws directory and initialize terraform:

    cd aws
    make init


#### Initial setup: ansible

The kafka deployment playbook from confluent can be installed with:

    ansible-galaxy collection install confluent.platform

The open-messaging client archive, required for the `client-deploy.yml` playbook, can be created via the docker file:

    cd ansible/open-messaging
    docker run --rm -v ./:/benchmark-target $(docker build -q .) "mv /benchmark /benchmark-target"

### Benchmarking

To run benchmarks, you can use the docker container:

    cd ansible/open-messaging
    docker run --rm -v ./benchmark:/benchmark $(docker build -q .) "bin/benchmark --drivers driver-kafka/kafka-exactly-once.yaml workloads/max-rate-1-topic-1-partition-1p-1c-1kb.yaml"

You can change the workload and driver config in the previous command to modifiy the benchmark. Available drivers and workloads can be found in the `ansible/open-messaging/benchmark` folder, once the docker command from the ansible initial setup section was executed.


### General Notes

Each vm is provisioned with a `ubuntu` user and the given ssh key.

For debugging it can be useful to check the services functionality on the vms is the following systemctl command:

    systemctl status confluent*



