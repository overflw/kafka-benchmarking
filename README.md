# Kafka benchmarking

This repo contains terraform configs to setup a kafka cluster for benchmarking on google cloud platform (gcp) and amazon web services (aws).

Be careful with costs caused by using the cloud providers - unfortunately we could not use free-tier vm-instances, as they do not offer enough RAM to run Kafka.

You can execute the terraform configs via the corresponding make commands.

To initialize terraform execute:

    make init


If you have your gcp or aws credentials in place you can now plan and apply the terraform config with:

    make apply


When the vm instances are deployed you can set up the kafka cluster with the confluent ansible playbooks.  
They can be installed with:

    ansible-galaxy collection install confluent.platform


and applied on the created vms using our automatically created inventory file `hosts.yml` via:

    ansible-playbook -i hosts.yml confluent.platform.all


To deprovision the deployed instances just run:

    make destroy


### Tips / Notes

Each vm is provisioned with a `ubuntu` user and the given ssh key.

Useful to check the services functionality on the vms is the following systemctl command:

    systemctl status confluent*



