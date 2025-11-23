#!/usr/bin/env bash
set -euo pipefail

echo "== Vérifs Système + Libvirt =="

echo "-- Groupes --"
for g in ops-read ops-maint ops-admin; do
  if getent group "$g" >/dev/null; then
    echo "OK groupe: $g"
  else
    echo "KO groupe: $g"
  fi
done

echo "-- Comptes & clés --"
USERS="alice bruno chloe"
for u in $USERS; do
  if id "$u" >/dev/null 2>&1; then
    echo "OK user: $u"
    if [ -s "/home/$u/.ssh/authorized_keys" ]; then
      echo "  OK authorized_keys"
    else
      echo "  KO authorized_keys"
    fi
  else
    echo "KO user: $u"
  fi
done

echo "-- Sudoers --"
for f in /etc/sudoers.d/99-ops-*; do
  [ -f "$f" ] && echo "OK sudoers: $f"
done
if visudo -c >/dev/null 2>&1; then
  echo "OK visudo -c"
else
  echo "KO sudo syntax"; exit 1
fi

echo "-- Polkit rule --"
if [ -f /etc/polkit-1/rules.d/49-org.libvirt.rules ]; then
  echo "OK polkit rule présente"
else
  echo "KO polkit rule manquante"; exit 1
fi

echo "-- Libvirt service --"
if systemctl is-active --quiet libvirtd; then
  echo "OK libvirtd actif"
else
  echo "KO libvirtd"; exit 1
fi

echo "-- Virsh qemu:///system --"
if virsh -c qemu:///system capabilities >/dev/null 2>&1; then
  echo "OK virsh (root)"
else
  echo "KO virsh sous root (vérifier libvirt/qemu et appartenance au groupe libvirt/libvirt-qemu)"
fi

echo "== Tests lecture/maintenance/admin (manuel) =="
echo "sudo -u alice  -H sh -c 'virsh -c qemu:///system list --all'   # lecture"
echo "sudo -u bruno  -H sh -c 'virsh -c qemu:///system list --all'   # lecture (ou + si activé)"
echo "sudo -u chloe  -H sh -c 'virsh -c qemu:///system list --all'   # admin"
echo "== FIN =="
