# JTAG-Controlled LED Demo


This demonstrates LED control via the BSCANE2 primitive (and UrJtag) in a demo built with the
OpenXC7 toolchain.

## Requirements

- SQRL Acorn CLE215(+)
    - JTAG cable required
        - DigilentHS2 used in guide
- OpenXC7 toolchain for building demo
    - Nix package used in guide
- OpenOCD for programming to target
- UrJTAG for controlling FPGA
    - Patch required to support DigilentHS2 cable
        - See attachment in https://sourceforge.net/p/urjtag/mailman/message/35914143/

## Building and Programming Demo

Load OpenXC7 toolchain and build with `make`:

```bash
$ nix develop github:openxc7/toolchain-nix
[nix(openXC7)] cd jtag_led
[nix(openXC7)] make
```

Program board (via DigilentHS2 cable) with `make program`.

## Preparing FPGA BSDL File

1. Obtain BSDLs from Vivado installation
(`$XILINX_VIVADO/data/parts/xilinx/<family>/public/bsdl`)

```bash
cp /opt/Xilinx/Vivado/<version>/data/parts/xilinx/artix7/public/bsdl/xc7a200t_fbg484.bsd .
```

2. Apply a urjtag bsd-support patch for the part:

```bash
patch -u xc7a200t_fbg484.bsd ../jtag/xc7a200t_fbg484.bsd.patch
```

## Controlling LEDs

Connect to the FPGA with (patched) UrJTAG:

```
$ jtag
jtag> bsdl path .
jtag> cable DigilentHS2 VID=0x0403 PID=0x6014
Connected to libftdi driver.
jtag> detect
IR length: 6
Chain length: 1
Device Id: 00010011011000110110000010010011 (0x13636093)
  Filename:     ./xc7a200t_fbg484.bsd
```

Setup USER3 test register and load USER3 instruction:

```
jtag> register USER3_REG 4
jtag> instruction USER3 100010 USER3_REG
jtag> instruction USER3
jtag> shift ir
```

Shift data into 4-bit data register to enable/disable each of the 4 LEDs:

```
# All off
jtag> dr 0000
jtag> shift dr

# All on
jtag> dr 1111
jtag> shift dr

# 1st and 3rd on
jtag> dr 0101
jtag> shift dr
```

## License

This repo is licensed under the [CERN Open Hardware Licence Version 2 - Permissive License](./LICENSE).
