# ERS-7 Tekkotsu Stick Plan

This document defines the next media-side milestone for Tekkotsu on the ERS-7.

It is written from the current proven baseline:

- the robot can join the `AIBONET` hotspot
- the host can reach the robot on that network
- stock AIBO MIND 2 responds on port `80`
- the stock MIND 2 stick does not expose Tekkotsu/Open-R gateway ports

That means the next blocker is no longer Wi-Fi.
The next blocker is the stick payload.

## Current Boundary

What is already proven with the current known-good MIND 2 stick:

- `ping 192.168.43.8` works
- `http://192.168.43.8/` works
- server banner is `AIBO HTTPD v1.14 (Aperios)`

What is not exposed by that stick:

- `59001`
- `59010`
- `59011`

Operational meaning:

- the current MIND 2 stick is a network baseline
- it is not the Tekkotsu gateway stick

## Tekkotsu Payload Already Present In This Repo

The repo already contains a candidate ERS-7 Tekkotsu/Open-R payload under:

- `project/ms/open-r/`

Important pieces already present:

- `project/ms/open-r/mw/conf/object.cfg`
- `project/ms/open-r/mw/conf/connect.cfg`
- `project/ms/open-r/mw/conf/robotgw.cfg`
- `project/ms/open-r/system/conf/wlandflt.txt`

Important object references:

- `/MS/OPEN-R/MW/OBJS/MAINOBJ.BIN`
- `/MS/OPEN-R/MW/OBJS/MOTOOBJ.BIN`
- `/MS/OPEN-R/MW/OBJS/TINYFTPD.BIN`
- `/MS/OPEN-R/MW/OBJS/SNDPLAY.BIN`
- `/MS/OPEN-R/SYSTEM/OBJS/TCPGW.BIN`

Important gateway ports from `robotgw.cfg`:

- `59001` for `TCPGateway.Proxy.AperiosMessage.P`
- `59010` for `TCPGateway.RPOPENRSendString.char.O`
- `59011` for `TCPGateway.RPOPENRReceiveString.char.S`

## Working WLAN Baseline To Reuse

The Tekkotsu test stick should keep the same proven network assumptions:

- `ESSID=AIBONET`
- `WEPENABLE=0`
- `APMODE=1`
- `USE_DHCP=1`

The local Tekkotsu copy of that baseline is:

- [WLANCONF.TXT](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/WLANCONF.TXT)

## What We Should Not Do

- Do not keep changing Wi-Fi assumptions while testing new payload media.
- Do not use stock MIND 2 HTTP success as evidence that Tekkotsu is running.
- Do not try to coax `59001` out of the stock MIND 2 stick with config-only edits.

## First Goal When 64 MB Sticks Arrive

Prepare one larger Sony stick whose purpose is only this:

1. boot the Tekkotsu/Open-R payload from `project/ms/open-r`
2. join the same proven `AIBONET` hotspot
3. answer on `59001`, `59010`, and `59011`

That is the next meaningful milestone for this repo.

## Phase 1: Audit Before Writing The New Stick

Before copying anything to the new stick:

1. confirm which ERS-7 system base is required around `project/ms/open-r`
2. confirm whether `TCPGW.BIN` must come from an SDK/system base rather than
   only from this repo
3. confirm whether any expected `SYSTEM/CONF/WLANCONF.TXT` file must be
   injected in addition to `wlandflt.txt`
4. confirm whether the Memory Stick root should contain only `OPEN-R/` or any
   additional files such as `MEMSTICK.IND`

## Phase 2: Build Or Stage The Tekkotsu Stick Tree

When the media is available, create a dedicated staged tree under a new
workflow folder, for example:

- `ers7-tekkotsu-gateway/`

The staged tree should:

- preserve the exact `project/ms/open-r` payload
- inject the proven `AIBONET` WLAN config
- document exactly what gets copied to the stick root

## Phase 3: First Robot Test

Use the same already-proven hotspot path:

- robot on `AIBONET`
- host on `AIBONET`

Then test:

```bash
./ers7-connectivity/probe-ers7.sh ROBOT_IP tekkotsu
```

Expected success pattern:

- `ping` works
- `59001` responds
- `59010` responds
- `59011` responds

## Interpretation Rules

- If `ping` fails:
  this is still a network problem
- If `ping` works and `80` works but `59001` is closed:
  stock MIND 2 is still likely what is booted
- If `ping` works and `59001/59010/59011` respond:
  the Tekkotsu gateway stick milestone is achieved

## Recommended Immediate Next Task

Since the 64 MB sticks are not here yet, the best immediate repo task is:

1. keep the session log updated
2. keep the hotspot baseline fixed
3. preserve this plan
4. when the media arrives, create the actual `ers7-tekkotsu-gateway`
   workflow from `project/ms/open-r`

