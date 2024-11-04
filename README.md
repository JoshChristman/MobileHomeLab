<h1>Mobile Home Lab</h1>
 
 <h2>Languages and Utilities Used</h2>

- <b>Proxmox</b> 
- <b>OpenWRT</b>
- <b>Tailscale</b>
- <b>Ubuntu Server</b> 
- <b>Docker</b>

<h2>Description</h2>
This project documents a powerful, portable home lab setup using the N100 model as the hardware foundation. Designed for flexible, on-the-go network and server experimentation, the lab supports advanced routing, containerization, and secure remote access. Key components include OpenWRT as a virtualized router, Ubuntu Server with Docker, and a Tailscale VPN container, enabling a robust network testing and development environment.
<br />
<br />
<p align="center">
Overview: <br/>
<img src="https://i.imgur.com/6hCOKgo.jpeg" height="80%" width="80%" alt="Hardware Image 1"/>
<br />
 
<h2>Hardware</h2>
The mobile home lab is built on the versatile N100 model, optimized for networking and scalability. It features a quad Intel i226-V 2.5G LAN setup, providing four high-speed RJ45 ports that enable advanced networking configurations and multi-device connectivity. The device includes 2 USB 3.0 ports, 4 USB 2.0 ports, and an RJ45 COM console for flexible connectivity options. Memory and storage are robust, with a 32GB DDR5 SODIMM RAM slot running at 4800MHz and dual storage options—a Crucial P3 1TB NVMe M.2 SSD and a 4TB SATA SSD for significant performance and capacity. A MediaTek MT7921 Wi-Fi card, replacing the original Intel AX210, offers AP (Access Point) capabilities, expanding wireless options, while external Wi-Fi antennas boost signal strength for broader connectivity. This hardware configuration forms a powerful, compact lab environment ideal for advanced networking, virtualization, and portable testing applications.

<br />
<br />
<p align="center">
Front IO:  <br/>
<img src="https://i.imgur.com/kfeP5xF.jpeg" height="80%" width="80%" alt="Hardware Image 2"/>
<br />
<br />
Under the hood: <br/>
<img src="https://i.imgur.com/v5AMrhK.jpeg" height="80%" width="80%" alt="Hardware Image 3"/>
<br />
<br />
Rear IO:  <br/>
<img src="https://i.imgur.com/Y8ujKhB.jpeg" height="80%" width="80%" alt="Hardware Image 4"/>
<br />
<br />
 
 <h2>Proxmox</h2>
In this mobile home lab setup,Proxmox is used as the hypervisor to manage virtual machines and containers, providing a flexible and powerful virtualization platform. Proxmox allows for efficient resource allocation and centralized management, making it easy to deploy and maintain multiple VMs in a compact environment. In this setup, Proxmox hosts an OpenWRT VM that acts as the main router, managing network traffic, firewall rules, and DHCP settings. It also runs an Ubuntu Server VM with Docker, which serves as a container host for additional services, including a Tailscale container for secure remote access. This configuration allows for testing networking setups, running isolated applications in containers, and maintaining secure connectivity to the lab from remote locations. Proxmox’s web-based interface streamlines the process of creating, configuring, and monitoring these VMs, making it an ideal choice for a versatile and easily managed home lab environment.

<br />
<br />
<p align="center">
Proxmox PVE:  <br/>
<img src="https://i.imgur.com/GXnL70l.png" height="80%" width="80%" alt="Proxmox Image 1"/>
<br />
<br />
 
<h2>OpenWRT</h2>
In this mobile lab, OpenWRT serves as the primary router, providing advanced networking features and robust control over network traffic. Running as a virtual machine on Proxmox, OpenWRT leverages NIC passthrough to access two physical Intel i226-V network interfaces directly: one designated for WAN and the other for LAN. This setup enables high-speed wired connectivity and flexibility in managing network flows between local and external networks. Additionally, OpenWRT is configured to use two USB interfaces: one for a USB Wi-Fi dongle, allowing the lab to connect to external networks wirelessly, and the other for USB tethering from a mobile phone for WAN data access. This combination of direct NIC passthrough and USB-based network options makes it easy to switch between wired, wireless, or tethered WAN connections as needed, providing a versatile and highly adaptable network environment ideal for testing various scenarios and maintaining reliable internet access in the lab.

<br />
<br />
<p align="center">
OpenWRT :  <br/>
<img src="https://i.imgur.com/eZQGwPD.png" height="80%" width="80%" alt="OpenWRT Image 1"/>
<br />

<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
