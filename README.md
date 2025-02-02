# 🏠 Mobile Home Lab

## ⚙️ Languages and Utilities Used

- **Proxmox** 
- **OpenWRT**
- **Tailscale**
- **Ubuntu Server** 
- **Docker**

## 📄 Description
This project documents a powerful, portable home lab setup using the N100 model as the hardware foundation. Designed for flexible, on-the-go network and server experimentation, the lab supports advanced routing, containerization, and secure remote access. Key components include OpenWRT as a virtualized router, Ubuntu Server with Docker, and a Tailscale VPN container, enabling a robust network testing and development environment.

---

## 🛠️ Hardware
The mobile home lab is built on the versatile N100 model, optimized for networking and scalability. It features:
- **4x Intel i226-V 2.5G LAN ports** – High-speed RJ45 ports for advanced networking configurations.
- **Memory** – 32GB DDR5 SODIMM RAM slot, 4800MHz for robust multitasking.
- **Storage** – Dual storage options with a 1TB NVMe SSD and a 4TB SATA SSD.
- **Wi-Fi** – MediaTek MT7921 Wi-Fi card with AP capabilities and external antennas for better connectivity.

### Hardware Images:
<table>
  <tr>
    <td align="center"><b>Overview</b></td>
    <td align="center"><b>Front IO</b></td>
  </tr>
  <tr>
    <td><img src="https://i.imgur.com/6hCOKgo.jpeg" height="100%" width="100%" alt="Hardware Image 1"/></td>
    <td><img src="https://i.imgur.com/kfeP5xF.jpeg" height="100%" width="100%" alt="Hardware Image 2"/></td>
  </tr>
  <tr>
    <td align="center"><b>Under the Hood</b></td>
    <td align="center"><b>Rear IO</b></td>
  </tr>
  <tr>
    <td><img src="https://i.imgur.com/v5AMrhK.jpeg" height="100%" width="100%" alt="Hardware Image 3"/></td>
    <td><img src="https://i.imgur.com/Y8ujKhB.jpeg" height="100%" width="100%" alt="Hardware Image 4"/></td>
  </tr>
</table>

---

## 🔧 Proxmox
In this mobile home lab setup,Proxmox is used as the hypervisor to manage virtual machines and containers, providing a flexible and powerful virtualization platform. Proxmox allows for efficient resource allocation and centralized management, making it easy to deploy and maintain multiple VMs in a compact environment. In this setup, Proxmox hosts an OpenWRT VM that acts as the main router, managing network traffic, firewall rules, and DHCP settings. It also runs an Ubuntu Server VM with Docker, which serves as a container host for additional services, including a Tailscale container for secure remote access. This configuration allows for testing networking setups, running isolated applications in containers, and maintaining secure connectivity to the lab from remote locations. Proxmox’s web-based interface streamlines the process of creating, configuring, and monitoring these VMs, making it an ideal choice for a versatile and easily managed home lab environment.

### Proxmox Interface:
![Proxmox PVE](https://i.imgur.com/GXnL70l.png)

---

## 🌐 OpenWRT
In this mobile lab, OpenWRT serves as the primary router, providing advanced networking features and robust control over network traffic. Running as a virtual machine on Proxmox, OpenWRT leverages NIC passthrough to access two physical Intel i226-V network interfaces directly: one designated for WAN and the other for LAN. This setup enables high-speed wired connectivity and flexibility in managing network flows between local and external networks. Additionally, OpenWRT is configured to use two USB interfaces: one for a USB Wi-Fi dongle, allowing the lab to connect to external networks wirelessly, and the other for USB tethering from a mobile phone for WAN data access. This combination of direct NIC passthrough and USB-based network options makes it easy to switch between wired, wireless, or tethered WAN connections as needed, providing a versatile and highly adaptable network environment ideal for testing various scenarios and maintaining reliable internet access in the lab.

### OpenWRT Interface:
![OpenWRT Interface](https://i.imgur.com/W9hoXpS.png)

---

## 🖥️ Ubuntu Linux Server
In this lab, Ubuntu Server plays a central role, hosting key services and applications for testing and development. Running as a virtual machine on Proxmox, Ubuntu Server is configured with Cockpit, an intuitive web-based GUI that simplifies server management tasks such as monitoring, updating, and configuring the system directly from a browser. To ensure dedicated access and control, a single NIC is passed through as an admin interface, providing a backup connection specifically for administrative tasks. Additionally, the 4TB SATA SSD is passed through to the Ubuntu VM, creating a substantial storage pool ideal for data backup, application storage, and Docker containers. With this setup, Docker containers have direct access to the large storage pool, allowing for efficient use of space and performance when running multiple services. This configuration combines powerful local storage and easy web-based management, making Ubuntu Server a reliable and scalable solution for home lab projects.

### Cockpit GUI:
![Cockpit GUI](https://i.imgur.com/P5Hr9ZB.png)

---

## 🐳 Docker
In this home lab setup, Docker serves as a flexible and lightweight platform for managing and running containers. To streamline container management, Portainer is installed, providing a user-friendly web GUI for deploying, monitoring, and maintaining containers. With Portainer, you can easily manage containerized applications, networks, and volumes from a single interface. One core application in this lab is Dashy, a customizable home lab dashboard that centralizes access to all lab services, links, and tools, making it easy to monitor and navigate the environment. Another key container is Syncthing, which is configured to sync specific folders between my home NAS and the lab environment. This setup ensures that important files are always up to date across devices, with changes automatically mirrored between systems. Together, Docker, Portainer, Dashy, and Syncthing create a powerful ecosystem for efficient management, access, and data synchronization, ideal for keeping lab resources organized and readily available.

### Docker Applications:
<table>
  <tr>
    <td align="center"><b>Portainer</b></td>
    <td align="center"><b>Dashy</b></td>
    <td align="center"><b>Syncthing</b></td>
  </tr>
  <tr>
    <td><img src="https://i.imgur.com/rGdCI5a.png" height="100%" width="100%" alt="Portainer Image"/></td>
    <td><img src="https://i.imgur.com/1gnL5oa.png" height="100%" width="100%" alt="Dashy Image"/></td>
    <td><img src="https://i.imgur.com/awiaLmi.png" height="100%" width="100%" alt="Syncthing Image"/></td>
  </tr>
</table>

---

👉 **GitHub Profile:** [github.com/JoshChristman](https://github.com/JoshChristman)  
👉 **LinkedIn:** [linkedin.com/in/Josh-Christman](https://www.linkedin.com/in/Josh-Christman)
