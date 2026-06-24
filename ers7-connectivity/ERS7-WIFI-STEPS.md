# ERS-7 Wi-Fi Steps

This is the shortest practical checklist for getting the ERS-7 onto Wi-Fi and ready for monitoring.

## Goal

Get the robot onto a network it can actually join, then verify that from the Debian workstation.

## Important Constraint

The ERS-7 Wi-Fi configuration we found in the Sony/Open-R files supports:

- open Wi-Fi
- WEP Wi-Fi

It does not document WPA, WPA2, or WPA3.

That means the current `white` network will only work for ERS-7 if you reconfigure it to:

- open security, or
- WEP

on 2.4 GHz.

## What To Do

### 1. Prepare a dedicated ERS-7 network

Use a dedicated SSID for the robot if possible.

Recommended settings:

- 2.4 GHz only
- open security first
- fixed channel
- DHCP enabled
- no client isolation
- simple SSID name

If you must keep the existing SSID, change `white` to an ERS-7-compatible mode:

- open, or
- WEP

Do not rely on WPA2 for the ERS-7.

### 2. Prepare the programmable Memory Stick

Use a wireless-capable OPEN-R base layout, preferably `WCONSOLE`.

Use the Sony-branded Memory Stick reader for stick preparation if you have it.

Why:

- old Memory Stick media can be picky
- the Sony-branded reader is the most trustworthy first choice for reading and writing AIBO media
- it reduces one more variable during bring-up

Good source tree:

```text
../openr-debian/sdk/local/OPEN_R_SDK/OPEN_R/MS_ERS7/WCONSOLE/memprot/OPEN-R
```

Copy that `OPEN-R` tree to the root of the programmable Memory Stick.

### 3. Install the Wi-Fi config file

Put the ERS-7 Wi-Fi config on the stick here:

```text
/OPEN-R/SYSTEM/CONF/WLANCONF.TXT
```

For the current lab naming, start from:

- [WLANCONF.white.TXT](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/WLANCONF.white.TXT)

Copy it onto the stick as:

```text
OPEN-R/SYSTEM/CONF/WLANCONF.TXT
```

Recommended physical handling sequence:

1. power the ERS-7 off before removing the stick
2. insert the stick into the Sony-branded Memory Stick reader
3. attach that reader to the Debian workstation
4. copy `WLANCONF.TXT` into place
5. safely unmount/eject the stick
6. return it to the ERS-7 before powering back on

### 4. Check the config values

Before booting the robot, make sure these values match the actual lab network:

- `ESSID`
- `WEPENABLE`
- `WEPKEY` if used
- `APMODE=1`
- `USE_DHCP=1`

Recommended first try:

```txt
HOSTNAME=AIBO
ESSID=YOUR_WIFI_NAME
WEPENABLE=0
APMODE=1
USE_DHCP=1
```

### 5. Boot the robot

1. Power the ERS-7 off.
2. Insert the programmable Memory Stick.
3. Power the ERS-7 on.
4. Give it time to associate and obtain DHCP.

### 6. Verify from the network side

From the Wi-Fi router or AP:

- check the DHCP lease/client list
- look for a new AIBO/unknown client
- note the assigned IP address

This is usually the fastest way to confirm the robot joined.

### 7. Verify from the Debian host

Once you know the robot IP, test:

```bash
ping ROBOT_IP
```

If you used `WCONSOLE`, also test:

```bash
telnet ROBOT_IP 59000
```

If the Tekkotsu/Open-R stack is on the stick, later checks may include:

- TCP `59001`
- TCP `59010`
- TCP `59011`

### 8. If it does not join

Check these first:

- SSID exactly matches `ESSID`
- network is 2.4 GHz
- security is open or WEP, not WPA2/WPA3
- `APMODE=1`
- DHCP is enabled on the AP
- router is not blocking old 802.11b clients

If DHCP still fails, try a static IP configuration later.

## Best First Success Path

If you want the highest chance of success:

1. create a dedicated open 2.4 GHz SSID
2. use `WCONSOLE`
3. use `APMODE=1`
4. use `USE_DHCP=1`
5. boot the ERS-7
6. check the router lease table
7. telnet to port `59000`
