# ERS-7 Connectivity Session Log

Use this file to keep live connectivity sessions structured and comparable.

## Proven Reference Session

Verified in the successful hotspot session:

- SSID: `AIBONET`
- host Wi-Fi interface: `wlx200db02466d8`
- host Wi-Fi IPv4: `192.168.43.120/24`
- hotspot/router IP: `192.168.43.1`
- robot IP: `192.168.43.8`
- `ping` worked
- `http://192.168.43.8/` worked
- server banner: `AIBO HTTPD v1.14 (Aperios)`
- page identity: `AIBO MIND 2 | Top Page`

This reference session proves stock network reachability, not yet Tekkotsu
gateway reachability.

## Logged Session: Hotspot Reset And Re-Probe

Date: 2026-06-25

Operator: cartheur + Codex

Robot: ERS-7

Memory Stick image: current known-good AIBO MIND 2 stick

Workstation interface: `wlx200db02466d8`

Access point / router: mobile hotspot

Security mode: open

SSID: `AIBONET`

IP plan:

- hotspot/router IP: `192.168.43.1`
- host IP: `192.168.43.120`
- robot IP: `192.168.43.8`

Probe command:

```bash
./ers7-connectivity/probe-ers7.sh 192.168.43.8 all
```

Observed result:

- `ping 192.168.43.8` succeeded
- `http://192.168.43.8/` responded
- server banner was `AIBO HTTPD v1.14 (Aperios)`
- `59001` was closed or unreachable
- `59010` was closed or unreachable
- `59011` was closed or unreachable

Interpretation:

- host-to-robot transport is now proven on the hotspot path
- stock MIND 2 is definitely booted
- Tekkotsu/Open-R gateway services are not exposed by this stick

Operational conclusion:

- networking is no longer the blocker
- the next blocker is stick payload and boot image selection
- future tests should keep the same working `AIBONET` path and change the
  robot media, not the Wi-Fi assumptions

## Session Template

Date:

Operator:

Robot:

Memory Stick image:

Workstation interface:

Access point / router:

Security mode:

SSID:

IP plan:

## Current Baseline

- Host Wi-Fi interface: `wlx200db02466d8`
- Preferred test SSID: `AIBONET`
- Known-good host Wi-Fi IPv4: `192.168.43.120/24`
- Known-good robot IP: `192.168.43.8`

## Pre-flight

- USB Wi-Fi adapter attached and recognized
- dedicated network active
- correct Memory Stick inserted
- workstation ready to capture notes

## Bring-Up Notes

- power-on time:
- LED / audio / boot behavior:
- network association result:
- robot IP observed:
- host reachability result:
- port 80 result:
- port 59001 result:
- port 59010 result:
- port 59011 result:

## Problems Seen

- 

## Changes Made

- 

## Next Attempt

- 
