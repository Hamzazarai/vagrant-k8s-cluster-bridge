#  Kubernetes Cluster with Vagrant (Bridge Networking, Multi-PC)

This project creates a **Kubernetes cluster using Vagrant + VirtualBox + kubeadm** across **two physical machines**.

---

##  Architecture

| Machine | Role | VMs | IPs |
|----------|------|-----|-----|
| **PC1** | Master + Workers | master, worker1, worker2 | 192.168.1.10–12 |
| **PC2** | Extra Workers | worker3, worker4 | 192.168.1.13–14 |

All VMs are connected via a **bridge interface** (LAN).

---

##  Requirements

- 2 physical PCs connected to the same LAN
- VirtualBox ≥ 7.0
- Vagrant ≥ 2.4
- Ubuntu 22.04 (recommended)
- Internet connection

---

##  Setup Instructions

## Déploiement du Cluster

### Sur PC1
```bash
cd pc1-master-workers
vagrant up
vagrant ssh master
kubeadm token create --print-join-command
```

Copiez la commande de join affichée.

### Sur PC2
```bash
cd pc2-workers
vagrant up
vagrant ssh worker-pc2-1
sudo <coller_la_commande_join>
```

Répétez pour worker-pc2-2.

### Vérification du Cluster

Sur le master node :
```bash
kubectl get nodes -o wide
```

Vous devriez voir tous les 5 nodes (1 master + 4 workers).

## Notes Importantes

- Assurez-vous que les 2 PCs utilisent le même réseau bridge
- Remplacez `"enp3s0"` dans chaque Vagrantfile par le nom de votre interface réseau réelle (utilisez `ip a` pour vérifier)
- Vous pouvez ajuster CPU/RAM dans les Vagrantfiles
- La synchronisation temporelle n'est pas imposée (NTP optionnel)