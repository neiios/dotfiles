# Collection of Various Linux Desktop Tweaks

## Fedora

```
# https://pagure.io/fedora-workstation/issue/228
sudo grubby --update-kernel=ALL --args="preempt=full"
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
# revert with: sudo grubby --remove-args="preempt=full" --update-kernel=ALL 
```
