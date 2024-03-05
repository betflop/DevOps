Автоматическое создание PV: Когда PVC создается в Kubernetes, NFS Subdir External Provisioner автоматически создает соответствующий PV на NFS сервере. Это упрощает процесс управления хранилищем, поскольку вам не нужно вручную создавать PV для каждого PVC

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

helm install -n nfs-provisioning --create-namespace nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --set nfs.server=192.168.0.241 --set nfs.path=/var/nfs_share