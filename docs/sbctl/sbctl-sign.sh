path=$(pwd)
linux=($(ls /boot/efi/linux/))
kernel=($(ls /boot/kernel | grep vmlinuz))

function gen_secboot {
        sbctl create-keys &&
        sbctl sign --save /boot/efi/EFI/Boot/bootx64.efi &&
        sbctl sign --save /boot/efi/EFI/systemd/systemd-bootx64.efi &&
        for efi in "${linux[@]}"; do
                sbctl sign --save /boot/efi/EFI/linux/$efi
        done
        for vmlinuz in "${kernel[@]}"; do
                sbctl sign --save /boot/kernel/$vmlinuz
        done
        
        sbctl enroll-keys -m -i &&
        sbctl verify | sed -E 's|^.* (/.+) is not signed$|sbctl sign -s "\1"|e'
}
gen_secboot
