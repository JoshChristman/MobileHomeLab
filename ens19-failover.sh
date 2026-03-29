#!/bin/bash
# =============================================================================
# ens19 Failover Monitor Script
# =============================================================================
# Description:
#   Monitors network connectivity by pinging the OpenWRT gateway through
#   ens18. If the gateway stops responding (OpenWRT is down or ens18 loses
#   its IP), ens18 is brought down to avoid IP conflicts and ens19 is
#   automatically brought up as a fallback admin port.
#   When the gateway recovers, ens19 is automatically brought back down,
#   ens18 is brought back up and renews its DHCP lease from OpenWRT
#   without needing a reboot.
#
# Use Case:
#   If the OpenWRT VM crashes or goes down, this script detects it via a
#   failed ping and brings up ens19 with a static IP so you can still
#   access the Ubuntu VM directly by plugging your PC into the physical
#   admin port and setting your PC to a static IP on the same subnet.
#
# Emergency Access Procedure:
#   1. Wait up to 5 minutes after OpenWRT goes down
#   2. Plug your PC into the physical ens19 port
#   3. Set your PC to a static IP e.g. 172.25.1.50
#   4. Set your PC gateway to 172.25.1.1
#   5. SSH to 172.25.1.10
#
# Recovery (no reboot needed):
#   1. Restore OpenWRT functionality
#   2. Script detects gateway is back within 5 minutes
#   3. ens19 automatically goes down
#   4. ens18 automatically comes back up and renews its DHCP lease
#   5. Everything back to normal through ens18
# -----------------------------------------------------------------------------
# Configuration Variables
# Change these if your network settings change
# -----------------------------------------------------------------------------

# The static IP and subnet to assign to ens19 when it becomes the fallback
# /24 means subnet mask 255.255.255.0 - covers 172.25.1.1 to 172.25.1.254
STATIC_IP="172.25.1.10/24"

# The default gateway - this is your OpenWRT router IP
# Used to both ping check connectivity AND route traffic through ens19
GATEWAY="172.25.1.1"

# How often (in seconds) to check if the gateway is reachable
# 300 seconds (5 minutes) - low CPU impact for home lab use
# Admin port will come up within 5 minutes of OpenWRT going down
CHECK_INTERVAL=300

# Tracks whether ens19 is currently up or down
# Prevents the script from repeatedly trying to bring it up or down
# false = ens19 is down (normal operation)
# true  = ens19 is up (failover is active)
ENS19_UP=false

# -----------------------------------------------------------------------------
# Main Monitoring Loop
# Runs forever checking every 5 minutes
# -----------------------------------------------------------------------------

# 'while true' creates an infinite loop - runs until the service is stopped
while true; do

    # -------------------------------------------------------------------------
    # Ping the gateway through ens18 to verify OpenWRT is reachable
    # This catches two failure scenarios:
    #   1. ens18 lost its IP (no route to ping through)
    #   2. OpenWRT crashed but ens18 still holds its static IP
    # -------------------------------------------------------------------------
    # ping -c 1    = send just 1 ping packet
    # -W 2         = wait max 2 seconds for a response
    # -I ens18     = force the ping through ens18 specifically
    # &>/dev/null  = discard all output we only care if it succeeds or fails
    # $?           = stores the exit code - 0 means success, 1 means failure
    ping -c 1 -W 2 -I ens18 $GATEWAY &>/dev/null
    GATEWAY_UP=$?

    # -------------------------------------------------------------------------
    # If ping FAILED (exit code is not 0) - OpenWRT is unreachable
    # -------------------------------------------------------------------------
    if [ "$GATEWAY_UP" != "0" ]; then

        # Only bring up ens19 if it is not already up
        # Prevents duplicate IP errors on repeated loop iterations
        if [ "$ENS19_UP" = false ]; then
            echo "$(date): Gateway $GATEWAY unreachable - OpenWRT may be down"

            # Bring down ens18 first to prevent duplicate IP conflict
            # when ens19 comes up with the same IP 172.25.1.10
            # dhclient -r  = release the DHCP lease cleanly
            # ip link set down = bring the interface down at hardware level
            echo "$(date): Bringing down ens18 to avoid IP conflict"
            dhclient -r ens18 2>/dev/null
            ip link set ens18 down

            echo "$(date): Bringing up ens19 as fallback at $STATIC_IP"

            # Bring ens19 up at hardware level then assign IP and route
            ip link set ens19 up
            ip addr add $STATIC_IP dev ens19 2>/dev/null
            ip route add default via $GATEWAY dev ens19 2>/dev/null
	    ip route add 172.25.1.6 dev ens19 2>/dev/null

            # Mark ens19 as active so we dont try to bring it up again
            ENS19_UP=true
            echo "$(date): ens19 is up - connect to 172.25.1.10 via admin port"
        fi

    # -------------------------------------------------------------------------
    # If ping SUCCEEDED - OpenWRT is up and running normally
    # -------------------------------------------------------------------------
    else

        # Only bring down ens19 if it was previously brought up as a fallback
        if [ "$ENS19_UP" = true ]; then
            echo "$(date): Gateway $GATEWAY restored - OpenWRT is back up"

            # Bring down ens19 and remove its IP and route
            echo "$(date): Bringing down ens19"
            ip route del default via $GATEWAY dev ens19 2>/dev/null
	    ip route del 172.25.1.6 dev ens19 2>/dev/null
            ip addr del $STATIC_IP dev ens19 2>/dev/null
            ip link set ens19 down

            # Reset tracking variable ready for next failover
            ENS19_UP=false
            echo "$(date): ens19 is down"

            # -------------------------------------------------------------
            # Bring ens18 back up and renew DHCP lease from OpenWRT
            # ip link set up  = bring the interface back up at hardware level
            # dhclient        = request a fresh lease from OpenWRT
            # -------------------------------------------------------------
            echo "$(date): Bringing ens18 back up and renewing DHCP lease"
            ip link set ens18 up
            dhclient ens18 2>/dev/null
            echo "$(date): ens18 renewed - running normally through ens18"
        fi

    # fi closes the if/else block
    fi

    # Wait 5 minutes before checking again
    # 300 seconds = only 288 pings per day - near zero CPU impact
    sleep $CHECK_INTERVAL

# done closes the while loop and jumps back to the top
done
