$VMname = "zmerrick1"
$VMtemplate = "E:\VHDs\TMPLG2-2019.vhdx"
$VMdiskpath = "F:\Virtual Disks\"
$VMvmpath = "F:\Virtual Machines\"
$VMunattend = "E:\SourceFiles\unattend.xml"
$VMgen = 2
[int64]$VMram = 3GB
$CPUCount = 2
$VMswitch = "Production"

$VMname
$VMtemplate
$VMdiskpath
$VMvmpath
$VMunattend
$VMgen
$VMram
$VMswitch

# Copy the VM template to the destination
Copy-Item -Path "$VMtemplate" -Destination "$VMdiskpath$VMname.vhdx" -Force

# Mount the VHD and copy the unattend.xml file
Mount-VHD -Path "$VMdiskpath$VMname.vhdx"
Copy-Item -Path "$VMunattend" -Destination "G:\Windows\Panther\"
Dismount-VHD "$VMdiskpath$VMname.vhdx"

# Create the VM
New-VM -Name $VMname -Path "$VMvmpath" -NoVHD -Generation "$VMgen" -MemoryStartupBytes "$VMram" -SwitchName $VMswitch
Set-VMProcessor -VMName $VMName -Count $CPUCount

# Attach the VHD to the VM
Add-VMHardDiskDrive -VMName $VMname -Path "$VMdiskpath$VMname.vhdx"

Start-VM -Name $VMname

# Configure the VM (setup automation, rename computer, install features)
$VMLocalUser = "Administrator"
$VMLocalPWord = ConvertTo-SecureString -String "Password1" -AsPlainText -Force
$VMLocalCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $VMLocalUser, $VMLocalPWord

Start-Sleep -Seconds 180
Invoke-Command -VMName $VMname -Credential $VMLocalCredential -ScriptBlock {Rename-Computer -NewName "zmerrick1" -Restart} -ArgumentList $VMname

Start-Sleep -Seconds 180
Invoke-Command -VMName $VMname -Credential $VMLocalCredential -ScriptBlock {Install-WindowsFeature -Name "Net-Framework-Features" -Restart} -ArgumentList $VMname
