all:
  vars:
    ansible_connection: ssh
    ansible_user: ubuntu
    ansible_become: true
    ansible_ssh_private_key_file: ~/.ssh/tf
    confluent_server_enabled: false
    #kafka_broker_custom_java_args: "-Xmx 1536M -Xms 1536M"

zookeeper:
  hosts:
  %{ for entry in zookeeper ~}
  ${ entry }:
  %{ endfor ~}

kafka_broker:
  hosts:
  %{ for entry in broker ~}
  ${ entry }:
  %{ endfor ~}

kafka_controller:
  hosts:
  %{ for entry in controller ~}
  ${ entry }:
  %{ endfor ~}

client:
  hosts:
  %{ for entry in client ~}
  ${ entry }:
  %{ endfor ~}