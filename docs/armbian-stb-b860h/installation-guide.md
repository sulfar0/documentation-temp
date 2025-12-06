# preparation
1. STB B860H 
2. Memory Card microSD minimal 8Gb
3. Adapter microSD
4. USB male to male

## link file

[Download tar](https://drive.google.com/drive/folders/1uyD5fPBxR7_VSwl4v7qxVa4UN1C50l3A?usp=sharing)

# reset bootloader stb b860h

download folder reset-bootloader-b860h

## step 1

- buka aplikasi BootcardMaker

- choose disk (sd card)

- centang bagian To partition and format

- choose your bin files: u-boot.bin

- klik tombol make

- lalu klik tombol start

- setelah selesai format sdcard

- pindah semua file yang ada pada folder Unlock_USB ke sdcard yang sudah diformat

## step 2

- buka aplikasi Amlogic USB Burning Tool v2.2.0

- lalu pastikan usb male to male sudah tercolok pada laptop dan adaptor set top box sudah tercolok pada stop kontak sebelum kita sambungkan ke set top box

- sdcard masukkan ke dalam set top box

- sambungkan usb male to male friend dan adaptor set top box

note: menyambungkan usb male to male friend dan adaptor set top box disambungkan atau dicolok secara bersamaan, dan ditekan tombol power set top box secara bersamaan

- lalu pastikan hasil pada aplikasi Amlogic USB Burning Tool v2.2.0 hasilnya success conected

## step 3

- klik import image pada pojok kiri atas

![alt text](asset/image-2.png)

- pilih image Pure-Khadas-VIM1.img pada folder reset-bootloader-b860h

![alt text](asset/image-3.png)

- setelah selesai import, hilangkan ceklis pada Erase flash sebelah kanan aplikasi

![alt text](asset/image-4.png)

- setelah itu klik tombol start

- jika sudah sampai error 1% dan tidak jalan lagi, klik tombol stop

![alt text](asset/image-5.png)

- lepaskan kabel male to male, dan adaptor power

## step 4

- sambungkan usb male to male friend dan adaptor set top box

note: menyambungkan usb male to male friend dan adaptor set top box disambungkan atau dicolok secara bersamaan, dan ditekan tombol power set top box secara bersamaan

-  setelah itu klik import image pada pojok kiri atas

![alt text](asset/image-2.png)

- pilih image Pure-Khadas-VIM1.img pada folder reset-bootloader-b860h

![alt text](asset/image-3.png)

- setelah selesai import, hilangkan ceklis pada Erase flash dan Erase Bootloader sebelah kanan aplikasi

![alt text](asset/image-6.png)

- setelah itu klik tombol start

- tunggu sampai finish seperti dibawah

![alt text](asset/image-7.png)

note: jika gagal ulangi dari step 1

- setelah finish, klik tombol stop

- sambungkan ulang usb male to male, dan adaptor power set top boxnya 

- sudah bisa langsung install android os

note: menyambungkan usb male to male friend dan adaptor set top box disambungkan atau dicolok secara bersamaan, dan ditekan tombol power set top box secara bersamaan

---

# installation base os

download folder installation-androidtv

## step 1

- masukkan sdcard ke laptop dengan adapter yang terunlock

![alt text](asset/microsd%20to%20adapter%20sdcard.jpg)

![alt text](asset/adapter-sdcard.jpg)

- buka aplikasi BootcardMaker

- choose disk (sd card)

- centang bagian To partition and format

- choose your bin files: u-boot.bin

- klik tombol make

![alt text](asset/image.png)

- lalu klik tombol start

- setelah selesai format sdcard

- pindah semua file yang ada pada folder Unlock_USB ke sdcard yang sudah diformat

![alt text](asset/image-1.png)

## step 2

- siapkan set top box, usb male to male, sdcard yang sudah disiapkan pada step 1 hingga step 2

- install Amlogic USB Burning Tool v2.2.0

- setelah di install

- buka aplikasi Amlogic USB Burning Tool v2.2.0

- lalu pastikan usb male to male sudah tercolok pada laptop dan adaptor set top box sudah tercolok pada stop kontak sebelum kita sambungkan ke set top box

![alt text](asset/male-to-male.jpg)

- sdcard masukkan ke dalam set top box

- sambungkan usb male to male friend dan adaptor set top box

![alt text](asset/connect-stb-male-to-male.jpg)
note: menyambungkan usb male to male friend dan adaptor set top box disambungkan atau dicolok secara bersamaan, dan ditekan tombol power set top box secara bersamaan

- lalu pastikan hasil pada aplikasi Amlogic USB Burning Tool v2.2.0 hasilnya success conected

![alt text](asset/image-8.png)

## step 3

- setelah sukses tersambung, buka folder FWAero_B860HV1&2_Android 6.0.0

- kemudian klik 2 kali pada file aeroflasher.bat

![alt text](asset/image-9.png)

- klik tombol run

- setelah itu ketik angka 2 kemudian enter

![alt text](asset/image-10.png)

- setelah itu cek pada bagian paling atas, apakah sudah ada device yang terscan

- kemudian jika sudah ada, klik spasi

- kemudian tunggu hingga selesai

- setelah selesai, ketik huruf e untuk keluar dari terminal

## step 4

- setelah selesai, hubungkan set top box ke monitor atau tv

- tunggu hingga selesai booting setelah selesai maka sudah berhasil menginstall android pada set top box

- keluarkan microsd dari set top box

---

# installation armbian-debian

download folder step 2

## step 1

- buat bootable microsd armbian menggunakan rufus dan pilih file Armbian_5.91_Aml-s905_Debian_buster_default5.1.0.img

- setelah selesai membuat bootable pada microsd

## step 2

- buka microsd

- kemudian buka folder extlinux

- buka file extlinux.conf, lalu pada line # FDT /dbt/meson-gxl-s905x-khadas-vim.dtb

- hapus # dan ganti menjadi FDT /dbt/meson-gxl-s905x-p212.dtb

## step 3

- lalu edit file uENV.ini

- lalu ganti menjadi dtb_name=/dtb/meson-gxl-s905x-p212.dtb

- kemudian file uboot_HG680P.bin dicopy dan dipaste ke dalam microsd

- kemudian rename file uboot_HG680P.bin menjadi bootloader.bin

- lalu eject microsd

## step 4

- kita ke android pada set top box, buka file manager

- lalu buka boot 

- klik tombol sebelah icon home untuk bisa memilih file

- kemudian cari file bootloader.bin

- setelah itu klik lagi 2 tombol dari icon home untuk bisa mengcopy file yang telah dipilih

- lalu pencet tombol icon home

## step 5

- buka folder localdisk

- kemudian buka folder Download

- paste file dengan mengklik 2 tombol dari icon home

## step 6

- setelah itu buka aplikasi emulator terminal

- kemudian masuk ke dalam root dengan menggunakan command 

```
su
```

- setelah itu masuk ke folder download pada localdisk

```
cd sdcard/download
```

- lalu cek apakah ada file bootloadet.bin

```
ls
```

- kemudian masukkan command berikut

```
dd if=bootloader.bin of=/dev/block/bootloader
```

- jika berhasil maka akan keluar records in dan records out

- setelah itu restart set top box 

```
reboot
```

## step 7

- setelah itu tunggu selesai booting

- setelah selesai masukan password root
note: password root = 1234

- setelah itu akan diminta untuk mengubah password root

- untuk mengubah password root akan diminta password yang awal

- kemudian masukkan password yang diinginkan, setelah itu masukkan kembali

## step 8

- setelah itu akan membuat user

- kemudian akan diminta untuk nama username yang diinginkan

- setelah itu masukkan password untuk user, setelah itu masukkan kembaki passwordnya

- lalu akan diminta informasi masukkan saja sesuai keinginan, bisa dikosongkan dengan cara langsung dienter saja

**selamat anda telah berhasil menginstall linux pada set top box**

# installation gui for armbian

## step 1

```
armbian-config
```

- ketik enter

- pilih Network

- pilih Wifi
note: untuk wifi harus menggunakan dongle wifi untuk armbian

- lalu pilih jaringan yang diketahui

## step 2

- setelah itu ke Personal

- Pilih Timezone

- Pilih Asia

- Pilih Jakarta

## step 3

- pilih Mirror

- pilih mirror.tuna.tsinghua.edu.cn/armbian/ China

## step 4 

- pilih system

- pilih Firmware

- pilih yes

- lalu ketika disuruh reboot pilih yes

## step 5

- kita akan mengupdate source untuk package dari armbian debian buster

```
sudo nano /etc/apt/source.list
```

- untuk isinya kita berikan # pada setiap line

- tambahkan di line berikutnya seperti dibawah

```
deb http://archive.debian.org/debian buster main contrib non-free
deb http://archive.debian.org/debian-security buster/updates main contrib non-free
deb http://archive.debian.org/debian buster-backports main contrib non-free
```

- lalu save menggunakan ctrl + x

- kemudian klik s, dan enter

## step 6

- setelah itu ketik

```
sudo apt update && apt upgrade
```

- setelah itu reboot

```
reboot
```

## step 7

- setelah login kembali install gui yang diinginkan dibawah

**xfce**
```
sudo apt install task-xfce-desktop
```

**lxde**
```
sudo apt install task-lxde-desktop
```

**lxqt**
```
sudo apt install task-lxqt-desktop
```

**mate**
```
sudo apt install task-mate-desktop
```

**gnome**
```
sudo apt install task-gnome-desktop
```

- setelah menjalankan salah satu gui diatas, ketik Y untuk mengkonfirmasi

## step 8

- setelah selesai install, lakukan update dan upgrade kembali

```
sudo apt update && apt upgrade
```

- setelah itu lakukan reboot

```
reboot
```

- jika berhasil akan langsung masuk ke dalam tampilan yang dipilih sebelumnya

---


**selamat anda telah mengembalikan bootloader b860h**

