# kafka-cluster-benchmarking

This repo contains terraform configs to setup a kafka cluster for benchmarking on gcp and aws.

Currently only aws is fully functional.

You can execute the terraform configs via the corresponding make file.

    make init
    make apply
    make destroy


### Tips / Notes

Useful to check the services functionality on the vms is the following systemctl command

```
systemctl status confluent*
```


