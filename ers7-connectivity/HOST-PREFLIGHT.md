# ERS-7 Host Preflight

Use this checklist on the Debian workstation before powering on the robot.

## Goal

Make sure this machine is ready to participate in the same network as the
robot without mixing up stock MIND 2 success with Tekkotsu gateway success.

## 1. Hardware

- Wi-Fi adapter connected and usable
- adapter has a Linux-supported chipset
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

Decide which component controls the adapter:

- `NetworkManager`
- manual `ip` / `iw` flow

Pick one approach and keep it stable for the session.

## 4. Network values to record before boot

Write down:

- SSID
- security mode
- subnet
- hotspot/router IP
- expected workstation IP
- expected robot IP or DHCP range

## 5. Current strongest known-good values

These values were actually observed during the successful hotspot session:

- Wi-Fi interface: `wlx200db02466d8`
- SSID: `AIBONET`
- host Wi-Fi address: `192.168.43.120/24`
- hotspot/router IP: `192.168.43.1`
- robot IP: `192.168.43.8`

This is the best baseline to reuse first.

## 6. Basic workstation checks

Verify:

- the host is on the intended ERS-7 network, not some other remembered SSID
- the adapter is up
- the robot-side network is active

## 7. Robot-facing checks

Once the ERS-7 is on the network, test in this order:

1. workstation can reach the robot IP
2. stock HTTP on port `80` if testing MIND 2 reachability
3. TCP `59001` if testing Tekkotsu gateway reachability
4. TCP `59010`
5. TCP `59011`

Suggested manual checks:

```bash
ping ROBOT_IP
curl -I http://ROBOT_IP/
nc -vz ROBOT_IP 59001
nc -vz ROBOT_IP 59010
nc -vz ROBOT_IP 59011
```

Or use:

```bash
./ers7-connectivity/probe-ers7.sh ROBOT_IP all
```

## 8. Interpretation

- `ping` works and HTTP on `80` works:
  stock MIND 2 reachability is proven
- `ping` works and `59001` is closed:
  Tekkotsu gateway is not yet proven
- no `ping`:
  do not jump ahead to Tekkotsu port debugging

## 9. If It Fails

Capture the failure mode precisely:

- adapter not detected
- workstation cannot join the network
- robot does not associate
- robot associates but has no IP
- IP exists but stock HTTP is closed
- IP exists but Tekkotsu ports are closed

That distinction saves a lot of time later.
