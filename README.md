# codama-tinker-driver
codama driver for Tinker Board S

## build and install
build, install driver
```
$ sudo make KERNEL_SRC=/lib/modules/$(uname -r)/build all ARCH=arm
$ sudo make KERNEL_SRC=/lib/modules/$(uname -r)/build install ARCH=arm
```
insert overlay driver setting
Add last line in /boot/hw_intf.conf
```
intf:dtoverlay=codama-soundcard
```

Change Alsa default card setting to "1" (/usr/share/alsa/alsa.conf)
```
defaults.ctl.card 1
defaults.pcm.card 1
```

Use alsa soft volume.
Add setting to "/etc/asound.conf"
```
pcm.i2s_16k {
	type hw
	card 1
	nonblock 1
	format S32_LE
	channels 2
	rate 16000
}

pcm.VocalFusion {
	type plug
	slave.pcm {
	type softvol
	slave.pcm {
		type dmix
		ipc_key 256
		ipc_perm 0666
		slave.pcm "i2s_16k"
	}
	control {
		name "Playback"
		card 1
	}
    }
}

pcm.VF_Channel0_(L) {
	type plug
	slave.pcm {
	type softvol
	slave.pcm {
		type dsnoop
		ipc_key 512
		ipc_perm 0666
		slave.pcm "i2s_16k"
		bindings [0]
	}
	control {
		name "Record"
		card 1
	}
    }
}

pcm.!default {
	type asym
	capture.pcm "VF_Channel0_(L)"
	playback.pcm "VocalFusion"
}
```
