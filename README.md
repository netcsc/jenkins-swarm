# jenkins-swarm
a jenkins cluster running on docker swarm

- run ./build_base.sh to build base Vagrant box
- start swarm cluster using Vagrant with 1 manager and 2 workers
  ansible-playbook swarm.yml
- run ansible playbook to deploy jenkins cluster on docker swarm
  ansible-playbook jenkins.yml
