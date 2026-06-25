# ERS-7 Wi-Fi Steps

This is the shortest practical checklist for getting the ERS-7 onto Wi-Fi and
separating "robot is reachable" from "Tekkotsu gateway is reachable."

## Goal

Get the robot onto a network it can actually join, verify that from the Debian
workstation, and then move to Tekkotsu-specific port checks.

## Important Constraint

The ERS-7 Wi-Fi configuration we found in the Sony/Open-R files documents:

- open Wi-Fi
- WEP Wi-Fi

It does not document WPA, WPA2, or WPA3.

## Strongest Proven Path So Far

The strongest known-working network path is:

- SSID: `AIBONET`
- security: open
- DHCP: enabled
- robot-side config: `APMODE=1`, `USE_DHCP=1`

That path worked using a mobile hotspot.

Do not assume a router guest network is equivalent just because it also uses
the ESSID `AIBONET`.

## What To Do

### 1. Start from the known-good WLAN config

Use:

- [WLANCONF.TXT](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/WLANCONF.TXT)

It should be copied to:

```text
OPEN-R/SYSTEM/CONF/WLANCONF.TXT
```

### 2. Prepare a compatible network first

Recommended first attempt:

- 2.4 GHz capable hotspot or AP
- open security
- DHCP enabled
- simple SSID name
- no client isolation

The current best first try is the known working hotspot pattern:

- `ESSID=AIBONET`
- `WEPENABLE=0`

### 3. Prepare the Memory Stick for the workflow you are actually testing

There are two very different cases:

- stock MIND 2 reachability
- Tekkotsu/Open-R monitoring reachability

Do not mix them up.

Stock MIND 2 success on port `80` is not proof that Tekkotsu gateway ports are
alive.

### 4. Install the Wi-Fi config file

Recommended physical handling sequence:

1. power the ERS-7 off before removing the stick
2. insert the stick into the Memory Stick reader
3. attach that reader to the Debian workstation
4. copy `WLANCONF.TXT` into place
5. safely unmount/eject the stick
6. return it to the ERS-7 before powering back on

### 5. Check the config values

Before booting the robot, confirm:

- `HOSTNAME=AIBO`
- `ESSID=AIBONET`
- `WEPENABLE=0`
- `APMODE=1`
- `USE_DHCP=1`
- `SSDP_ENABLE=1`

### 6. Boot the robot

1. Power the ERS-7 off.
2. Insert the intended Memory Stick.
3. Power the ERS-7 on.
4. Give it time to associate and obtain DHCP.

### 7. Verify from the network side

From the hotspot or AP:

- check the DHCP lease/client list
- look for the robot IP

Known-good observed robot IP from the successful hotspot session:

- `192.168.43.8`

### 8. Verify from the Debian host

Once you know the robot IP, test:

```bash
ping ROBOT_IP
```

If you are verifying stock MIND 2 reachability, test:

```bash
curl -I http://ROBOT_IP/
```

Known-good observed result:

- `Server: AIBO HTTPD v1.14 (Aperios)`

If you are verifying Tekkotsu/Open-R gateway reachability, later checks may
include:

- TCP `59001`
- TCP `59010`
- TCP `59011`

### 9. If it does not join

Check these first:

- SSID exactly matches `ESSID`
- network is compatible enough for old 2.4 GHz behavior
- security is open or WEP, not WPA2/WPA3
- `APMODE=1`
- DHCP is enabled
- the hotspot or AP is actually the one being tested

### 10. If it joins but the expected service is missing

Use the symptom to decide what failed:

- `ping` works and port `80` works:
  stock MIND 2 reachability is proven
- `ping` works and port `80` is closed:
  you may not be booting the expected stock MIND 2 stack
- `ping` works and `59001` is closed:
  robot reachability is proven, Tekkotsu gateway is not

## Best First Success Path

If you want the highest chance of success:

1. use the open hotspot pattern already proven with `AIBONET`
2. use the known-good `WLANCONF.TXT`
3. prove `ping`
4. prove stock MIND 2 on port `80`
5. only then move to Tekkotsu gateway ports
