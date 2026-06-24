# ERS-7 Connectivity

This folder is for the real robot connectivity and monitoring track.

It is intentionally separate from the Tekkotsu framework internals. The goal here is to solve the practical problem of reaching, monitoring, and iterating on a live ERS-7 before we pile on new robot behaviors.

## Scope

This workspace covers:

- Wi-Fi bring-up for the Sony AIBO ERS-7
- workstation-side network setup for this Debian machine
- Tekkotsu/Open-R monitoring connectivity
- repeatable operator checklists

This workspace does not try to redesign the whole build system.

## Working Files

- [LAB-SETUP.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/LAB-SETUP.md)
- [HOST-PREFLIGHT.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/HOST-PREFLIGHT.md)
- [SESSION-LOG.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/SESSION-LOG.md)

## Current Assumption

We will likely need a dedicated legacy-friendly network for the robot:

```text
ERS-7 <-> legacy-compatible AP/router <-> this workstation
                                 ^
                                 |
                         USB Wi-Fi adapter
```

That keeps the robot off the main network and gives us a predictable environment for `802.11b`.

## Repo Signals We Already Have

The checked-in `project/ms/` tree already shows the expected Open-R network path:

- `project/ms/open-r/system/objs/TCPGW.BIN` via `/MS/OPEN-R/SYSTEM/OBJS/TCPGW.BIN`
- `project/ms/open-r/mw/conf/robotgw.cfg`
- `project/ms/open-r/mw/conf/connect.cfg`
- `project/ms/open-r/mw/conf/object.cfg`

Relevant observations:

- `robotgw.cfg` exposes the TCP gateway on port `59001`
- string send/receive ports are configured on `59010` and `59011`
- `object.cfg` loads `MAINOBJ.BIN`, `MOTOOBJ.BIN`, `TINYFTPD.BIN`, `SNDPLAY.BIN`, and `TCPGW.BIN`
- `connect.cfg` wires sensor, motion, sound, and profiling channels among those objects

## Immediate Goal

Reach a milestone where:

1. the ERS-7 joins a known Wi-Fi network
2. this workstation can reach the robot over that network
3. the Open-R/Tekkotsu gateway ports respond as expected
4. the monitor/control workflow becomes testable

## Bring-Up Checklist

### 1. Hardware and network

- Identify the exact Wi-Fi method for this workstation:
  - USB Wi-Fi dongle
  - old router or dedicated AP
  - direct legacy bridge if available
- Keep the network isolated from the main office/home Wi-Fi
- Prefer simple, deterministic addressing

### 2. ERS-7 media and config

- Confirm which Memory Stick will be used for networking tests
- Preserve a known-good backup of the current stick contents before edits
- Audit `project/ms/open-r/mw/conf/` before changing network values

### 3. Workstation readiness

- Confirm Linux sees the chosen USB Wi-Fi adapter
- Decide whether NetworkManager or manual interface control will own that adapter
- Record the workstation IP, subnet, and interface name used for AIBO work

### 4. Robot reachability

- Power on the ERS-7 with the chosen Memory Stick
- Verify association with the dedicated network
- Confirm the robot gets or uses the expected IP
- Test basic reachability from this workstation

### 5. Monitoring path

- Test whether TCP port `59001` is reachable
- Test whether string channels `59010` and `59011` are reachable
- Bring up the Tekkotsu monitor tooling only after the network path is stable

## Open Questions

- What AP/security modes does this specific ERS-7 setup support in practice?
- Do we want DHCP or a fixed addressing plan?
- Which workstation adapter has the best Linux support for this job?
- Will we use the current `project/ms/` payload as-is for first connectivity tests, or a more conservative known-good stick image?

## Recommended Next Moves

1. Choose the actual USB Wi-Fi adapter and AP/router for the dedicated lab network.
2. Fill in [LAB-SETUP.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/LAB-SETUP.md) with the real subnet and security plan.
3. Walk through [HOST-PREFLIGHT.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/HOST-PREFLIGHT.md) on this Debian machine before the first live robot session.
4. Use [SESSION-LOG.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/SESSION-LOG.md) during the first power-on and monitor attempt.
