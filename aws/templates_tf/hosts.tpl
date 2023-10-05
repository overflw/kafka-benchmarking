all:
  vars:
    ansible_connection: ssh
    ansible_user: ubuntu
    ansible_become: true
    ansible_ssh_private_key_file: ~/.ssh/tf
    confluent_server_enabled: false

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

anoniks:
  hosts:
  %{ for entry in anoniks ~}
  ${ entry }:
  %{ endfor ~}