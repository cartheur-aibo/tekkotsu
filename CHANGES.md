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

## What This Means

This repo has crossed an important threshold:

- it is no longer just a historical source dump
- it can now build its Aperios static framework against the repo-local Open-R SDK

That gives us a real base for AIBO-focused development instead of only documentation work.

## Next Steps For Real AIBO Work

Recommended order:

1. Build a concrete project target using the `project/` template for `TGT_ERS7`.
2. Confirm the generated binaries and stick layout are compatible with the `openr-debian` deployment flow.
3. Identify the first real robot behavior we care about and trim the project template down to only the required behaviors and motion modules.
4. Decide whether to keep using the legacy project Makefiles or start introducing a thinner modern wrapper around them.

The most useful immediate next validation is:

- build a project executable, not just `libtekkotsu.a`
- stage it in an Open-R Memory Stick layout
- compare that output with the conventions already used in `openr-debian`

## Notes

- Java monitor/training tools are still optional and are skipped when Java is unavailable.
- Licensing signals in this repo still need review before redistribution decisions.
- We have not yet finished the full local-host build path in this pass; the verified success here is the Aperios static framework build path.
