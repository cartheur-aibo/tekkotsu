# ERS-7 Host Preflight

Use this checklist on the Debian workstation before powering on the robot.

## Goal

Make sure this machine is ready to participate in a dedicated ERS-7 network without disturbing the normal workstation connection.

## 1. Hardware

- USB Wi-Fi adapter connected
- adapter has a known Linux-friendly chipset
- any required external antenna attached

## 2. Linux detection

Record:

- interface name
- driver in use
- MAC address

Suggested checks:

```bash
ip link
iw dev
nmcli device status
lsusb
```

## 3. Network ownership

Decide which component controls the USB adapter:

- `NetworkManager`
- manual `ip` / `iw` flow

Pick one approach and stick to it for the session.

## 4. Dedicated network values

Before the robot comes up, write down:

- SSID
- security mode
- subnet
- router/AP IP
- expected workstation IP
- expected robot IP or DHCP range

## 5. Basic workstation checks

Verify:

- the USB adapter is not accidentally connected to the normal network
- the primary workstation network still works independently
- the dedicated adapter is up and ready

## 6. Robot-facing checks

Once the ERS-7 is on the network, test in this order:

1. link association visible on the AP
2. workstation can reach the robot IP
3. TCP `59001`
4. TCP `59010`
5. TCP `59011`

Suggested manual checks:

```bash
ping ROBOT_IP
nc -vz ROBOT_IP 59001
nc -vz ROBOT_IP 59010
nc -vz ROBOT_IP 59011
```

## 7. If It Fails

Capture the failure mode precisely:

- adapter not detected
- workstation cannot join the AP
- robot does not associate
- robot associates but has no IP
- IP exists but ports are closed

That distinction will save a lot of time later.
