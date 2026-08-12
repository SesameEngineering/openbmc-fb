# Lightning bring-up experiment: the AST2400 SiP appears to hold DDR3 but the
# DRAM-type hardware trap reads DDR2, so stock u-boot runs ddr2_init and loops
# forever on DDR calibration ("CBR..."). Force the ddr3_init path.
# Remove this bbappend to revert to stock DRAM-type autodetection.
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-lightning-force-ddr3-init.patch"
