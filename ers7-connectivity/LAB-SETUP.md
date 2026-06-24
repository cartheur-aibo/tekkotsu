# ERS-7 Lab Setup

This is the first-pass connectivity setup for real ERS-7 work.

The goal is not to build the perfect network. The goal is to create the smallest reliable environment where:

- the robot can associate
- this workstation can reach it
- monitoring traffic can flow

## Recommended Topology

Use a dedicated AIBO network that is separate from the machine's normal internet connection.

```text
Debian workstation
  |- primary NIC: normal internet / office / home LAN
  `- USB Wi-Fi NIC: dedicated ERS-7 lab network

USB Wi-Fi NIC <-> legacy-compatible AP/router <-> ERS-7
```

This keeps AIBO experiments isolated and makes troubleshooting much easier.

## Preferred First Attempt

Start with:

- one USB Wi-Fi adapter on this workstation
- one dedicated router or access point for AIBO use only
- a simple private subnet such as `192.168.7.0/24`
- a predictable workstation address such as `192.168.7.1` or `192.168.7.10`

## Network Policy

For the first successful session, prefer simplicity over elegance:

- isolated SSID
- no roaming assumptions
- fixed channel
- no band steering
- no mesh
- no WPA3

## Addressing Strategy

The safest operational plan is to decide up front whether the robot should use:

1. DHCP from the dedicated router
2. a fixed IP in the dedicated subnet

Recommendation:

- prefer DHCP if the ERS-7 setup supports it cleanly
- switch to fixed IP only if DHCP proves unreliable or unavailable

## Router / AP Checklist

The dedicated AP/router should be configured as conservatively as possible:

- 2.4 GHz only
- legacy-friendly mode enabled if available
- fixed channel
- simple SSID name
- simple passphrase if security is supported by the robot

If the robot is sensitive to modern security modes, be ready to test:

- open network on an isolated lab AP
- WEP only if absolutely required and only on the isolated lab network

Do not put legacy security on the normal household or office network.

## Workstation Policy

This machine should keep two network roles separate:

- primary network stays untouched for internet and normal work
- USB Wi-Fi adapter is reserved for ERS-7 experiments

That avoids breaking the rest of the machine while we debug legacy wireless.

## First Success Criteria

The first lab setup is good enough when all of these are true:

1. the USB Wi-Fi adapter is recognized by Linux
2. the workstation joins or hosts the intended dedicated network
3. the ERS-7 associates with that network
4. the workstation can reach the robot IP
5. TCP port `59001` responds

## Notes To Capture During Setup

When we do the first live attempt, record:

- USB Wi-Fi adapter model and chipset
- AP/router model
- security mode used
- subnet used
- workstation interface name
- robot IP
- whether `59001`, `59010`, and `59011` respond
