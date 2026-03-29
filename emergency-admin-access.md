## 🔧 Emergency Admin Access & Network Failover

In this mobile home lab setup, emergency admin access is provided through dedicated 
physical ports on the N100 that bypass the OpenWRT VM entirely. A monitoring script 
runs continuously on the Ubuntu Server VM, pinging the OpenWRT gateway every 5 minutes 
through the main network interface. If the gateway stops responding, the script 
automatically switches to a dedicated admin port so the server remains accessible 
without a reboot. When OpenWRT recovers, the main interface is automatically restored 
and the admin port goes back down. This setup ensures that both the Ubuntu Server VM 
and Proxmox host are always reachable for maintenance even in a worst case scenario.

---

### ⚠️ Gotchas

- **NIC passthrough conflict** – If a NIC is passed through directly to a VM via PCI 
  passthrough it will not be available for Proxmox bridges. Verify with 
  `qm config <vmid> | grep hostpci` before setting up your admin bridge.

- **Interface naming** – Always verify your actual interface names with `ip link show` 
  before editing `/etc/network/interfaces`. A mismatch will cause the bridge to have 
  no carrier and silently fail.

- **Asymmetric routing** – When two bridges share the same subnet, Linux may send 
  replies out the wrong interface, causing pings and web requests to silently fail. 
  Fix this with policy routing rules so traffic received on the admin bridge always 
  replies back through the same bridge.

- **Script autostart** – Run `systemctl enable ens19-failover` or the script will 
  not survive a reboot. `systemctl start` only runs it for the current session.

- **Duplicate IP conflict** – Both interfaces will briefly share the same IP if 
  `ens18` is not brought down before `ens19` comes up. The script handles this 
  automatically but manual testing should account for it.

---

### 🔌 Emergency Access

Set your PC to any `172.25.1.x` address with subnet `255.255.255.0` before plugging in.

| Plugged Into | Resource | Address |
|-------------|----------|---------|
| Ubuntu admin port | Ubuntu SSH | `ssh user@172.25.1.10` |
| Ubuntu admin port | Proxmox Web GUI | `https://172.25.1.6:8006` |
| Ubuntu admin port | Proxmox SSH | `ssh root@172.25.1.6` |
| Proxmox admin port | Proxmox Web GUI | `https://172.25.1.5:8006` |
| Proxmox admin port | Ubuntu SSH | `ssh user@172.25.1.10` |
