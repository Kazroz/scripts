Install-WindowsFeature DHCP –IncludeManagementTools
Add-DhcpServerV4Scope -Name "DHCP testing Scope" -StartRange 192.168.202.100 -EndRange 192.168.202.200 -SubnetMask 255.255.255.0
Add-DhcpServerInDC -DnsName test01.test.local -IPAddress 192.168.202.10
Add-Dhcpserverv4ExclusionRange -ScopeId 192.168.202.0 -StartRange 192.168.202.150 -EndRange 192.168.202.170
Add-DhcpServerv4Reservation -ComputerName test01.test.local -ScopeId 192.168.202.0 -ClientId F0-DE-F1-7A-00-5E -IPAddress 192.168.202.200 -Description "Fourth Floor Printer" -Name printer.test.com
Set-DhcpServerv4OptionValue -ComputerName test01.test.local -DnsServer 192.168.202.10 -DnsDomain test.local -Router 192.168.201.1
Add-DhcpServerv4Class -Name "User Class for Lab Computers" -Type User -Data "LabComputers"
Set-DhcpServerv4Scope -Name "DHCP testing Scope" -ScopeId 192.168.202.0 –State Active
Add-DhcpServerv4Policy -Name "Labs" -Description "Policy for labs routers" -ScopeId 192.168.202.0 -Condition "AND" -UserClass "EQ", "User Class for Lab Computers"
Set-DhcpServerv4OptionValue -ScopeId 192.168.202.0 -UserClass "User Class for Lab Computers" -OptionId 3 -Value "192.168.202.2"
