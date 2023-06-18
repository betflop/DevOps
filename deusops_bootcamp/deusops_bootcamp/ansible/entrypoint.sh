#!/bin/ash

# setup ssh-key for runner access to host
echo ${SSH_KEY} | base64 -d > /sshkey
chmod 600 /sshkey

# add gitlab-ci-token to requirements.yml
find /builds -name requirements.yml | xargs sed 's#https://#https://gitlab-ci-token:${CI_JOB_TOKEN}@#g' -i 

exec "$@"
