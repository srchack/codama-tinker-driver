obj-m += snd-soc-codama-soundcard.o snd-soc-codama-codec.o i2c-gpio.o
SRC := $(shell pwd)

all: devicetree
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC) modules

install: devicetree
	cp snd-soc-codama-codec.ko /lib/modules/$(shell uname -r)/kernel/sound/drivers/
	cp snd-soc-codama-soundcard.ko /lib/modules/$(shell uname -r)/kernel/sound/drivers/
	cp i2c-gpio.ko /lib/modules/$(shell uname -r)/kernel/drivers/i2c/
	cp codama-soundcard.dtbo /boot/overlays/
	depmod -a

clean: clean-local
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC) clean

clean-local:
	rm codama-soundcard.dtbo || true

codama-soundcard.dtbo:
	dtc -@ -I dts -O dtb -o codama-soundcard.dtbo codama-soundcard-overlay.dts

devicetree: codama-soundcard.dtbo

