ansible-galaxy install -r requirements.yaml

ansible-playbook playbook.yaml -i hosts.ini

ansible-playbook playbook.yaml -i hosts.ini --tags "backup"
