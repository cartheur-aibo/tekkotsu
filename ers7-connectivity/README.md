# ERS-7 Connectivity

This folder is for the real-robot connectivity and monitoring track.

It is intentionally separate from Tekkotsu framework internals. The goal here
is to solve the practical problem of reaching, monitoring, and iterating on a
live ERS-7 before piling on new robot behaviors.

## Scope

This workspace covers:

- Wi-Fi bring-up for the Sony AIBO ERS-7
- workstation-side network setup for this Debian machine
- Tekkotsu/Open-R monitoring connectivity
- repeatable operator checklists
- the handoff between known-good stock MIND 2 networking and Tekkotsu-specific
  gateway testing

This workspace does not try to redesign the whole build system.

## Working Files

- [ERS7-WIFI-STEPS.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/ERS7-WIFI-STEPS.md)
- [LAB-SETUP.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/LAB-SETUP.md)
- [HOST-PREFLIGHT.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/HOST-PREFLIGHT.md)
- [SESSION-LOG.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/SESSION-LOG.md)
- [WLANCONF.TXT](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/WLANCONF.TXT)
- [probe-ers7.sh](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/probe-ers7.sh)
- [TEKKOTSU-STICK-PLAN.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/TEKKOTSU-STICK-PLAN.md)

## What Is Already Proven

These are no longer guesses:

- the real ERS-7 joined a compatible mobile hotspot named `AIBONET`
- the robot obtained IP `192.168.43.8`
- this Debian machine, after joining the same hotspot, reached the robot
- `ping 192.168.43.8` succeeded
- `http://192.168.43.8/` responded with `AIBO HTTPD v1.14 (Aperios)`
- the web UI identified itself as `AIBO MIND 2 | Top Page`

This is an important boundary:

- stock MIND 2 HTTP on port `80` is proven
- Tekkotsu/Open-R gateway connectivity is not yet proven

That means this folder should now focus on moving from proven stock network
reachability to proven Tekkotsu gateway reachability without confusing the two.

## Strongest Current Assumption

The strongest known-working network path is currently:

```text
ERS-7 <-> compatible mobile hotspot named AIBONET <-> this workstation
```

We may still want a dedicated legacy-friendly AP/router later, but that is no
longer a prerequisite for first reachability.

## Repo Signals We Already Have

The checked-in `project/ms/` tree already shows the expected Open-R network
path:

- `project/ms/open-r/system/objs/TCPGW.BIN` via `/MS/OPEN-R/SYSTEM/OBJS/TCPGW.BIN`
- `project/ms/open-r/mw/conf/robotgw.cfg`
- `project/ms/open-r/mw/conf/connect.cfg`
- `project/ms/open-r/mw/conf/object.cfg`

Relevant observations:

- `robotgw.cfg` exposes the TCP gateway on port `59001`
- string send/receive ports are configured on `59010` and `59011`
- `object.cfg` loads `MAINOBJ.BIN`, `MOTOOBJ.BIN`, `TINYFTPD.BIN`,
  `SNDPLAY.BIN`, and `TCPGW.BIN`
- `connect.cfg` wires sensor, motion, sound, and profiling channels among
  those objects

## Immediate Goal

Reach a milestone where:

1. the ERS-7 joins a known Wi-Fi network
2. this workstation can reach the robot over that network
3. the intended Tekkotsu/Open-R gateway payload is definitely the one booted
4. gateway ports respond as expected
5. the monitor/control workflow becomes testable

## Practical Bring-Up Order

### 1. Prove stock network reachability first

- use the known-good `AIBONET` WLAN baseline
- verify the robot joins Wi-Fi
- verify `ping`
- verify HTTP on port `80`

### 2. Only then move to Tekkotsu-specific media

- prepare the intended Tekkotsu/Open-R Memory Stick
- boot that media
- verify basic network reachability again
- only after that test ports `59001`, `59010`, and `59011`

### 3. Keep the workflows separate

- stock MIND 2 success is not proof of Tekkotsu gateway success
- a closed `59001` does not negate a successful stock MIND 2 Wi-Fi test
- a reachable robot with no HTTP on port `80` may indicate a non-MIND 2 boot
  path

## Open Questions

- Which Tekkotsu payload will be the first one tested after stock MIND 2?
- Does the current Tekkotsu Memory Stick layout boot cleanly on the ERS-7?
- Once booted, do `59001`, `59010`, and `59011` actually respond?
- Will we stay with the hotspot path for first Tekkotsu tests, or move to a
  dedicated legacy AP?

## Recommended Next Moves

1. Use the known-good `AIBONET` WLAN config in [WLANCONF.TXT](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/WLANCONF.TXT).
2. Follow [ERS7-WIFI-STEPS.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/ERS7-WIFI-STEPS.md) to separate stock MIND 2 reachability from Tekkotsu gateway tests.
3. Walk through [HOST-PREFLIGHT.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/HOST-PREFLIGHT.md) on this Debian machine before the next live robot session.
4. Use [probe-ers7.sh](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/probe-ers7.sh) after each power-on to capture the exact network boundary that is alive.
5. Use [SESSION-LOG.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/SESSION-LOG.md) during each power-on so stock and Tekkotsu outcomes do not get mixed together.
6. Use [TEKKOTSU-STICK-PLAN.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/TEKKOTSU-STICK-PLAN.md) as the payload-side plan once larger sticks are available.
