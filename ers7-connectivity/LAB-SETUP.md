# ERS-7 Lab Setup

This is the first-pass connectivity setup for real ERS-7 work.

The goal is not to build the perfect network. The goal is to create the
smallest reliable environment where:

- the robot can associate
- this workstation can reach it
- stock services can be distinguished from Tekkotsu services
- monitoring traffic can eventually flow

## Best Current Topology

The best currently proven topology is:

```text
Debian workstation <-> compatible mobile hotspot named AIBONET <-> ERS-7
```

That path is already known to work for stock MIND 2 reachability.

## Still-Useful Alternate Topology

A dedicated legacy-friendly AP/router may still become useful later:

```text
Debian workstation
  |- primary NIC: normal internet / office / home LAN
  `- Wi-Fi NIC: dedicated ERS-7 lab network

Wi-Fi NIC <-> legacy-compatible AP/router <-> ERS-7
```

But it is no longer the only plausible first step.

## Current Validated Host Setup

The current workstation setup has been validated enough to continue:

- USB Wi-Fi adapter: `148f:7601` `Ralink/Mediatek MT7601U`
- kernel driver: `mt7601u`
- workstation Wi-Fi interface: `wlx200db02466d8`
- hotspot SSID used successfully: `AIBONET`
- host Wi-Fi IPv4 during the successful session: `192.168.43.120/24`
- hotspot/router IP: `192.168.43.1`
- robot IP observed: `192.168.43.8`

## Memory Stick Handling

For stick preparation, prefer the Sony-branded Memory Stick reader when
possible.

Reason:

- it keeps the media path closer to Sony-era hardware expectations
- for legacy robot bring-up, fewer adapter/media variables are better

## Current Robot Config Artifact

A concrete ERS-7 Wi-Fi config now lives at:

- [WLANCONF.TXT](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/WLANCONF.TXT)

It matches the proven hotspot pattern:

- `ESSID=AIBONET`
- `APMODE=1`
- `USE_DHCP=1`
- `WEPENABLE=0`

## Network Policy

For the first successful session, prefer simplicity over elegance:

- open network
- no roaming assumptions
- no band steering
- no mesh
- no WPA3

## Addressing Strategy

Recommendation:

- prefer DHCP first
- move to fixed IP only if DHCP proves unreliable

## First Success Criteria

The first lab setup is good enough when all of these are true:

1. the Wi-Fi adapter is recognized by Linux
2. the workstation joins the intended ERS-7 network
3. the ERS-7 associates with that network
4. the workstation can reach the robot IP
5. stock MIND 2 HTTP on port `80` responds

That is the first network milestone.

Tekkotsu gateway ports are a later milestone.

## Second Success Criteria

The second lab setup milestone is:

1. the intended Tekkotsu/Open-R payload is definitely on the robot
2. the workstation can still reach the robot IP
3. TCP `59001` responds
4. TCP `59010` responds
5. TCP `59011` responds

## Notes To Capture During Setup

When doing a live attempt, record:

- Wi-Fi adapter model and chipset
- hotspot or AP used
- security mode used
- subnet used
- workstation interface name
- robot IP
- whether `ping` worked
- whether port `80` worked
- whether `59001`, `59010`, and `59011` responded

## Verified This Round

The following has been verified on this Debian host:

1. the MT7601U adapter is physically present on USB
2. firmware allowed the `mt7601u` kernel driver to bind
3. the host exposes Wi-Fi interface `wlx200db02466d8`
4. the adapter can scan for nearby Wi-Fi networks
5. the adapter connected to hotspot SSID `AIBONET`
6. the host received IPv4 address `192.168.43.120/24`
7. the robot obtained IP `192.168.43.8`
8. `ping` to the robot succeeded
9. `http://192.168.43.8/` responded as AIBO MIND 2
