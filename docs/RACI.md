# RACI Sécurité

| Domaine | R (Responsible) | A (Accountable) | C (Consulted) | I (Informed) |
|--------|------------------|-----------------|---------------|--------------|
| Hyperviseur (Ubuntu/KVM/libvirt/Cockpit) | Owner Hyperviseur | Chef de projet | Ingé K8s | Équipe |
| Cluster K8s (PSA, NP, Kyverno, RBAC)     | Owner K8s        | Chef de projet | Ingé CI/CD | Équipe |
| CI/CD & Supply Chain (SBOM/Scan/Sign)    | Owner CI/CD      | Chef de projet | Ingé K8s | Équipe |
| Données & PRA (MinIO/Velero/Postgres)    | Data Owner       | Chef de projet | Ingé K8s | Équipe |

**Règles :**
- Toute modif sécurité critique requiert 2 reviewers (CODEOWNERS).
- Aucun secret en clair : Vault/CSI obligatoires.
- Preuve de restauration Velero mensuelle (rapport + captures).
