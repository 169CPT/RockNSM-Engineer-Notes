# EXTEND LVM DISK ON CENTOS

Become a root user
`sudo su`

Install GDisk (If not already installed)
`yum install gdisk`

Get an overview of disk and devices
`lsblk`
annotate the drive you want to extend

Now we need to get the logical volume group name and the volume name
`lvdisplay`   
annotate the volume group name and the logical volume name

Now to extend the drive
`gdisk /dev/"device"`
example: `gdisk /dev/sda`

## Move secondary GPT Header
We need to move the secondary GPT header (backup header) because we have to expand the physical DISK
* verify that we need to relocate the GPT header
`v`
* Enter expert menu
`x`
* Relocate the GPT header to the end of the disk
`e`
* Return to the previous menu
`m`
* Write changes (save)
`w`

## Now create a new partition
* Create a new partition
`n`
* Verify partition start
* Verify partition end
* Set the partition type to Linux LVM
`8E00`
* Write changes (save)
`w`

## Extending LVM
* Now we have created the new partition you need to make the kernel aware of the updated partition table otherwise you could be facing critical issues such as data loss or corruption. You can achieve this by either rebooting the server or issue the following command from the CLI:
`partprobe`

* First we need to find the name of the newly created partition, so go ahead and issue the ‘lsblk’ command
`lsblk`

* Find the device name of the new partition and make a note of it. Issue the ‘pvcreate’ command to create a physical volume.
`pvcreate /dev/<partitionDeviceName>`

* Extend the volume group. You can find the name of the volume group with the ‘vgs’ command.
`vgextend <volumeGroupName> /dev/<partitionDeviceName>`
`vgs`

* You can confirm that the new space have been added to the group with the ‘vgs’ command.
`lvextend -l +100%FREE /dev/<volumeGroupName>/<logicalVolumeName>`

#### The command is issued with the parameter ‘-l’ and ‘+100%FREE’ to instruct lvextend to increase the size of the logical volume with all available extends in the volume group.
Note that the ‘+’ in the command is very important as it tells lvextend to add space to the group.

## LAST STEP
resize the file system
`resize2fs /dev/<volumeGroupName>/<logicalVolumeName>`

#### If your filesystem is XFS (i.e. CentOS 7), you will receive the following error message:
```
Bad magic number in super-block while trying to open /dev/<volumeGroupName>/<logicalVolumeName>
Couldn't find valid filesystem superblock.
```
If you do get this error, use the following command
`xfs_growfs -d /dev/<volumeGroupName>/<logicalVolumeName>`

Now verify the logical volume has been extended
`df -h`
