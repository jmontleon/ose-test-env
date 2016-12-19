#!/bin/bash
export git_dir=~
export use_ipa=true

if [ ! -d ${git_dir}/openshift-ansible ]; then
  git clone https://github.com/openshift/openshift-ansible ${git_dir}/openshift-ansible
fi

if ${use_ipa}; then
  #only really necessary if the hosts were rebuilt or tkt not pulled already
  kdestroy && kinit
  ipa dnsrecord-mod example.com *.ose --a-rec=$(host ose-master.example.com | cut -d " " -f 4)
fi

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ${git_dir}/openshift-ansible/playbooks/byo/config.yml
