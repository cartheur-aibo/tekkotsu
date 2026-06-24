# Tekkotsu

Tekkotsu is a robotics framework with strong historical support for Sony AIBO and related research platforms. This checkout contains the framework sources, build system, behaviors, motion code, vision code, and host-side tools.

This repo is currently being revived for active AIBO work. The most important practical detail is that the Aperios/Open-R SDK is expected to come from the sibling [`openr-debian`](../openr-debian/README.md) repo instead of a system-wide `/usr/local/OPEN_R_SDK` install.

Recent repo-local revival work is tracked in [CHANGES.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/CHANGES.md).

## Easy Start

If you want the shortest path to a real AIBO build, do this:

1. Make sure the workspace looks like `cartheur-aibo/openr-debian` next to `cartheur-aibo/tekkotsu`.
2. Verify the local Open-R SDK.
3. Build the template ERS-7 payload from `project/`.

```bash
cd ../openr-debian
export OPENRSDK_ROOT="$PWD/sdk/local/OPEN_R_SDK"
./scripts/check-openr.sh

cd ../tekkotsu/project
make \
  TEKKOTSU_ROOT="$(cd .. && pwd)" \
  TEKKOTSU_TARGET_PLATFORM=PLATFORM_APERIOS \
  TEKKOTSU_LOGVIEW=cat \
  compile
```

If that succeeds, your staged AIBO payload will be in:

```text
project/ms/open-r/mw/objs/
```

## Current Setup

Expected workspace layout:

```text
cartheur-aibo/
├── openr-debian/
└── tekkotsu/
```

Tekkotsu now prefers this SDK location automatically:

```text
../openr-debian/sdk/local/OPEN_R_SDK
```

If you want to set it explicitly:

```bash
export OPENRSDK_ROOT="$PWD/../openr-debian/sdk/local/OPEN_R_SDK"
```

## Quick Start

Verify the sibling SDK first:

```bash
cd ../openr-debian
export OPENRSDK_ROOT="$PWD/sdk/local/OPEN_R_SDK"
./scripts/check-openr.sh
```

Build Tekkotsu from this repo:

```bash
cd ../tekkotsu
make TEKKOTSU_LOGVIEW=cat
```

Notes:

- `TEKKOTSU_LOGVIEW=cat` avoids paging through compiler output with `more`.
- A full root build will try both the Aperios and local targets for ERS models.
- Some Java-based tools are optional and will be skipped if Java is not installed.

## Build Modes

Build the framework for Aperios/AIBO:

```bash
make TEKKOTSU_TARGET_PLATFORM=PLATFORM_APERIOS compile static TEKKOTSU_LOGVIEW=cat
```

Build the template project into a Memory Stick payload for ERS-7:

```bash
cd project
make \
  TEKKOTSU_ROOT="$(cd .. && pwd)" \
  TEKKOTSU_TARGET_PLATFORM=PLATFORM_APERIOS \
  TEKKOTSU_LOGVIEW=cat \
  compile
```

That verified build produces:

- `project/build/PLATFORM_APERIOS/TGT_ERS7/aperios/*.bin`
- `project/ms/open-r/mw/objs/*.bin`

Build the framework for the local host side only:

```bash
make TEKKOTSU_TARGET_PLATFORM=PLATFORM_LOCAL compile static shared TEKKOTSU_LOGVIEW=cat
```

Use the project template as the starting point for your own executable builds:

```text
project/
```

That directory contains the template `Environment.conf`, project `Makefile`, defaults, and platform-specific project scaffolding.

## Repository Map

Main framework areas:

- `Behaviors` - behavior base classes, demos, monitor behaviors, services, FSM nodes and transitions
- `DualCoding` - higher-level vision and spatial reasoning code
- `Events` - event types, routing, translation, timers
- `IPC` - shared-memory, locking, and process communication support
- `Motion` - motion commands, motion manager, kinematics, posture and walking code
- `Shared` - utility code, config/plist support, robot info, world state
- `Sound` - sound mixing and pitch/audio processing
- `Vision` - image pipeline and filter-bank based vision code
- `Wireless` - networking support

Platform/runtime areas:

- `aperios` - AIBO/Open-R specific runtime and build support
- `local` - host/simulation support and desktop-side drivers
- `project` - template project for user code

Supporting areas:

- `ers7-connectivity` - workspace for live robot Wi-Fi, monitoring, and operator bring-up
- `tools` - helper utilities, monitor tools, conversion tools, training tools
- `docs` - doxygen config, quick references, benchmarks, and generated docs assets
- `learning` - workshop slides and supporting material

## Practical Notes For Revival Work

- The top-level build system is legacy but still usable.
- The most relevant modern integration point for AIBO work is the sibling `openr-debian` SDK/toolchain repo.
- The project template build expects legacy Aperios-side archives such as `libxml2`, `libz`, `libjpeg`, `libpng`, and `libregex` under `aperios/lib`.
- Aperios builds are now less noisy than before, but the legacy Open-R GCC 3.3 headers can still emit substantial warnings.
- If you are modernizing code, start by preserving behavior, event, motion, and kinematics semantics before replacing infrastructure.

## References

- Old Tekkotsu project page: http://www.Tekkotsu.org/
- Archived online docs: https://www.cs.cmu.edu/~dst/Tekkotsu/Tutorial/docs.shtml
- Vision intro: http://www.cs.cmu.edu/~dst/Tekkotsu/Tutorial/vr-intro.shtml
- Workshop slides: [learning/sigcse07-workshop-slides.pdf](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/tekkotsu/learning/sigcse07-workshop-slides.pdf)
- Open-R Debian workspace: [../openr-debian/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/README.md)

## License Note

The checked-in licensing signals are mixed. The top-level `LICENSE` file, README history, and some imported subcomponents do not all agree exactly. Treat licensing as something to verify before redistribution or commercial reuse.
