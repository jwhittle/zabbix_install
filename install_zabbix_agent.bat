@echo off
rem pull the Hostname from the system
set HOSTNAME=%1
rem pull the ip address from the config file
set IP=%2
rem set path to zabbix install and .conf file
set CONF_FILE=c:\zabbix\zabbix_agentd.conf

ren C:\zabbix_agents_3.2.0.win zabbix

rem create .conf file
echo Server=%IP% > c:\zabbix\zabbix_agentd.conf
echo ServerActive=%IP%:10051 > c:\zabbix\zabbix_agentd.conf
echo Hostname=%HOSTNAME% >> c:\zabbix\zabbix_agentd.conf
echo StartAgents=5 >> c:\zabbix\zabbix_agentd.conf
echo DebugLevel=3 >> c:\zabbix\zabbix_agentd.conf
echo LogFile=c:\zabbix\zabbix_agentd.log >> c:\zabbix\zabbix_agentd.conf
echo Timeout=3 >> c:\zabbix\zabbix_agentd.conf
call C:\zabbix\bin\win32\zabbix_agentd.exe --config c:\zabbix\zabbix_agentd.conf --install


rem update firewall
set "fcmd=netsh advfirewall firewall add rule name="Zabbix Agent" dir=in action=allow program="C:\MyApp.exe" enable=yes profile="
for %a in (domain public private) do (
    echo %fcmd%%a

netsh advfirewall firewall add rule name="MyApp" dir=in action=allow program="C:\MyApp.exe" enable=yes profile=domain

netsh advfirewall firewall add rule name="MyApp" dir=in action=allow program="C:\MyApp.exe" enable=yes profile=public

netsh advfirewall firewall add rule name="MyApp" dir=in action=allow program="C:\MyApp.exe" enable=yes profile=private
pause

rem start the service

rem verify all is well.