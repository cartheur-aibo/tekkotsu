# Changes

This file tracks repository-local revival work for the current AIBO/Open-R effort.

It is intentionally practical: what changed, why it changed, what has been verified, and what we should do next for real robot work.

## Current Goal

Bring this historical Tekkotsu checkout back into active use with Sony AIBO by:

- using the sibling `openr-debian` repo as the local Open-R SDK/toolchain source
- making the legacy build behave on a modern Debian workstation
- preserving the robotics logic while reducing build friction

## Changes Made

### 1. Repo-local Open-R SDK integration

Updated [project/Environment.conf](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/project/Environment.conf:27) so Tekkotsu prefers:

```text
../openr-debian/sdk/local/OPEN_R_SDK
```

before falling back to the historical `/usr/local/OPEN_R_SDK` path.

Why:

- keeps the SDK inside the shared workspace
- matches the documented `openr-debian` flow
- avoids depending on a root-installed SDK

### 2. Non-interactive build output cleanup

Updated:

- [Makefile](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/Makefile:20)
- [project/Makefile](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/project/Makefile:24)
- [Motion/roboop/Makefile](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/Motion/roboop/Makefile:24)

to write status messages to stderr instead of `/dev/tty`.

Why:

- modern terminal and CI-style runs often do not expose a usable tty device
- this removes noisy setup errors unrelated to real compilation failures

### 3. Modern C++ compatibility for `binstrswap`

Updated [tools/binstrswap/binstrswap.cc](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/tools/binstrswap/binstrswap.cc:7) to avoid a collision with `std::byte` in newer libstdc++.

Why:

- the original `byte` typedef became ambiguous on modern toolchains
- this blocked all further framework compilation because `tools/` builds first

### 4. Legacy build mode for `mipaltools`

Updated [tools/mipaltools/src/Makefile](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/tools/mipaltools/src/Makefile:1) to compile with `-std=gnu++03`.

Why:

- that utility still uses pre-C++11 dynamic exception specifications
- using an older language mode was the smallest safe fix for now

### 5. Reduced Aperios warning noise

Updated:

- [Makefile](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/Makefile:48)
- [project/Makefile](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/project/Makefile:54)

to split warning policy by platform:

- `PLATFORM_APERIOS` now uses a smaller warning set
- `PLATFORM_LOCAL` keeps the stricter warning set

Why:

- the old Open-R GCC 3.3 headers produce extremely noisy warnings under the original flags
- quieter output makes real errors visible again

### 6. Top-level documentation rewrite

Replaced the old minimal README with a more practical one in [README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/README.md:1).

It now includes:

- expected workspace layout
- sibling `openr-debian` SDK usage
- build commands
- repo map
- revival notes

### 7. Project template path stability

Updated:

- [project/Environment.conf](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/project/Environment.conf:10)
- [aperios/bin/xml2-config](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/aperios/bin/xml2-config:1)

What changed:

- `TEKKOTSU_ROOT` is normalized with `abspath` inside the project template
- `xml2-config` now resolves its own prefix from the script location instead of assuming a relative `aperios/` directory

Why:

- project builds were inheriting relative paths that broke when the framework build was invoked from `project/`
- legacy `xml2-config` output only worked accidentally when run from the repo root

### 8. Generated-project noise cleanup

Updated [.gitignore](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/.gitignore:24) to ignore:

- `project/build/`
- `project/ms/bld_info.txt`
- generated `project/ms/open-r/mw/objs/*.bin`

Why:

- a successful project build should not immediately dirty the worktree with deployment payloads
- this keeps source changes easy to review while still allowing real AIBO artifacts to be built locally

### 9. README onboarding and make-warning cleanup

Updated:

- [README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/README.md:1)
- [project/Makefile](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/project/Makefile:139)

What changed:

- added a short "Easy Start" section at the top of the main README
- replaced a deprecated mixed normal/pattern target rule in the project Makefile

Why:

- new users should be able to reach the first verified AIBO build without reading the full repo map first
- modern GNU make warns about the old rule syntax even though the build still works

### 10. Dedicated ERS-7 connectivity workspace

Added:

- [ers7-connectivity/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/README.md)
- [ers7-connectivity/SESSION-LOG.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/ers7-connectivity/SESSION-LOG.md)

Why:

- Wi-Fi and monitoring bring-up is now a first-class part of the real robot effort
- this work needs its own checklist and notes area instead of being buried in framework docs

## Verified Status

The following has been verified in this checkout:

### Open-R SDK

The sibling `openr-debian` SDK is present and usable at:

```text
../openr-debian/sdk/local/OPEN_R_SDK
```

Verified components include:

- `bin/mipsel-linux-g++`
- `bin/mipsel-linux-strip`
- `OPEN_R/bin/mkbin`
- `OPEN_R/bin/stubgen2`
- `OPEN_R/include`
- `OPEN_R/lib`

### Aperios framework build

This command completed successfully:

```bash
make TEKKOTSU_LOGVIEW=cat TEKKOTSU_TARGET_PLATFORM=PLATFORM_APERIOS compile static
```

That build:

- built the prerequisite tools
- built `Shared/newmat`
- built `Motion/roboop`
- compiled and linked the main Aperios Tekkotsu library
- compiled the Aperios object programs such as `MMCombo`, `TinyFTPD`, and `SndPlay`

Verified library artifact:

- [build/PLATFORM_APERIOS/TGT_ERS7/libtekkotsu.a](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/build/PLATFORM_APERIOS/TGT_ERS7/libtekkotsu.a)

### Project template build

This command completed successfully:

```bash
cd project
make \
  TEKKOTSU_ROOT="$(cd .. && pwd)" \
  TEKKOTSU_LOGVIEW=cat \
  TEKKOTSU_TARGET_PLATFORM=PLATFORM_APERIOS \
  compile
```

That build:

- rebuilt and reused the framework as needed
- linked `MMCombo.bin`, `SndPlay.bin`, and `TinyFTPD.bin`
- compressed the resulting binaries into the project Memory Stick payload
- copied system files into the `project/ms/` staging tree

Verified project artifacts:

- [project/ms/open-r/mw/objs/mainobj.bin](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/project/ms/open-r/mw/objs/mainobj.bin)
- [project/ms/open-r/mw/objs/motoobj.bin](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/project/ms/open-r/mw/objs/motoobj.bin)
- [project/ms/open-r/mw/objs/sndplay.bin](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/project/ms/open-r/mw/objs/sndplay.bin)
- [project/ms/open-r/mw/objs/tinyftpd.bin](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/project/ms/open-r/mw/objs/tinyftpd.bin)

### Legacy Aperios library bridge

For this checkout, the project link step was satisfied by repo-local compatibility symlinks in [aperios/lib](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/aperios/lib:1) for:

- `libxml2.a`
- `libz.a`
- `libjpeg.a`
- `libpng.a`
- `libregex.a`

These currently point to the older sibling tree:

```text
../aiventure-aibo/Tekkotsu_4.0.1/aperios/lib
```

This is a practical bridge, not a final packaging story. A cleaner next step is to either:

1. rebuild those libraries into this repo's `aperios/lib`, or
2. source them from a dedicated Open-R compatibility package in the workspace

## What This Means

This repo has crossed an important threshold:

- it is no longer just a historical source dump
- it can now build its Aperios static framework against the repo-local Open-R SDK

That gives us a real base for AIBO-focused development instead of only documentation work.

## Next Steps For Real AIBO Work

Recommended order:

1. Replace the temporary `aperios/lib` symlink bridge with checked-in build instructions or reproducible library artifacts.
2. Confirm the generated `project/ms/` layout against the `openr-debian` deployment flow on real hardware.
3. Identify the first real robot behavior we care about and trim the project template down to only the required behaviors and motion modules.
4. Decide whether to keep using the legacy project Makefiles or start introducing a thinner modern wrapper around them.

The most useful immediate next validation is:

- validate the built `project/ms/` payload on the actual deployment path
- lock down where the required Aperios-side support libraries should live long term
- start replacing placeholder project behavior with our first real AIBO behavior module

## Notes

- Java monitor/training tools are still optional and are skipped when Java is unavailable.
- Licensing signals in this repo still need review before redistribution decisions.
- We have not yet finished the full local-host build path in this pass; the verified success here is the repo-local Aperios framework and project build path.
