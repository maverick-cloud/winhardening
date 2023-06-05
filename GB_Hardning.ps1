#Created By: Harendra Kumar
#version:V1.0
#Date:31-05-2023

#Set Local Security Policy
net accounts /uniquepw:24
net accounts /MAXPWAGE:60
net accounts /MINPWAGE:2
net accounts /MINPWLEN:12
secedit /export /cfg c:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 0", "PasswordComplexity = 1") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
rm -force c:\secpol.cfg -confirm:$false


#Set Account Lockout Policy
net accounts /lockoutduration:15
net accounts /lockoutthreshold:10
net accounts /lockoutwindow:15


#Create Central Folder
New-Item -Path C:\GBSetup -Type Directory -Force


#Disable-IE-ESC Policy Settings
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force

#Disable Windows Firewall         
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False


#Set Interactive Logon
Set-ItemProperty -Path “HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\” -Name legalnoticecaption -Value "Disclaimer Warning!! AUTHORIZEC ACCESS ONLY!!" -Force
Set-ItemProperty -Path “HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\” -Name legalnoticetext -Value "This Computer system is the property of Grupo Bimbo. It is for Authorized use only. By using this system, all users acknowledge notice of, and agree to comply with our Privacy Policy. Unauthorized of improper use of this system may result in administrative disciplinary action. LOG OFF IMMEDIATELY if you do not agree to the conditions started in this warning." -Force

#Rename Guest Account
Rename-LocalUser -Name "Guest" -NewName "ZZGuest"

gpupdate /force
