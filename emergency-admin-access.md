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

### 📜 Script Setup

The `ens19-failover.sh` script must be placed in `/usr/local/bin/` and registered 
as a systemd service so it runs automatically on boot.

**1. Copy the script to the correct location:**
```bash
cp ens19-failover.sh /usr/local/bin/ens19-failover.sh
chmod +x /usr/local/bin/ens19-failover.sh
```

**2. Create the systemd service file:**
```bash
nano /etc/systemd/system/ens19-failover.service
```

Paste the following:
```ini
[Unit]
Description=ens19 Failover Monitor
After=network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/ens19-failover.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**3. Enable and start the service:**
```bash
systemctl daemon-reload
systemctl enable ens19-failover
systemctl start ens19-failover
```

**4. Verify it is running:**
```bash
systemctl status ens19-failover
```

**5. Monitor the logs:**
```bash
journalctl -f -u ens19-failover
```

---

### ⚠️ Gotchas

- **Interface naming** – Your NICs may not be named `enp1s0` through `enp4s0`. 
  Always verify your actual interface names with `ip link show` before editing 
  `/etc/network/interfaces`. If you put the wrong interface name in the bridge config 
  the bridge will show as `NO-CARRIER` and `state DOWN` with no obvious error. The 
  bridge will appear to be configured correctly but will silently pass no traffic. 
  Run `lspci | grep -i ethernet` to see all NICs and cross reference with 
  `ip link show` to confirm the correct names.

- **Asymmetric routing** – When two bridges share the same subnet (`172.25.1.x`) Proxmox may send 
  replies out the wrong interface causing pings and web requests to fail. This happens because the reply packet goes 
  out `vmbr0` instead of back through `vmbr3` to your PC. The fix is to add a policy 
  routing table in `/etc/iproute2/rt_tables` and add `post-up` rules in `nanno /etc/network/interfaces` to the bottom of vmbr3 section.
```bash
echo "200 vmbr3-table" >> /etc/iproute2/rt_tables
```  
```bash
post-up ip rule add from 172.25.1.6 table vmbr3-table
post-up ip route add default via 172.25.1.6 dev vmbr3 table vmbr3-table
post-up ip route add 172.25.1.0/24 dev vmbr3 table vmbr3-table
post-down ip rule del from 172.25.1.6 table vmbr3-table
```

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

📖 [Full setup guide and gotchas](docs/emergency-admin-access.md)
