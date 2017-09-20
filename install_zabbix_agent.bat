@echo off
set HOSTNAME=%COMPUTERNAME%
rem set /p IP=<zabbix_host.txt
set IP=127.0.0.1
echo %HOSTNAME%
echo %IP%


:MAIN
if not exist "C:\zabbix_agents_3.4.0.win.zip" GOTO DL
echo unzip
if not exist "C:\zabbix\" GOTO UNZIP

echo CONFIG
if not exist "C:\zabbix\zabbix_agentd.conf" GOTO CONFIG

echo firewall
GOTO FIREWALL
:FIREWALLDONE
echo SERVICE
if exist "C:\zabbix\bin\win32\zabbix_agentd.exe" GOTO SERVICE
SC QUERY "Zabbix Agent" > NUL
IF ERRORLEVEL 1060 GOTO END
ECHO Zabbix Agent service is up and running
GOTO END

:END
echo Thank you and Have a Nice day
pause
exit



:DL
echo *******Download agent files
if not exist "C:\zabbix_agents_3.4.0.win.zip" bitsadmin.exe /transfer "Download Agent files" https://www.zabbix.com/downloads/3.4.0/zabbix_agents_3.4.0.win.zip C:\zabbix_agents_3.4.0.win.zip
echo *******Agent Downloaded
GOTO MAIN

:UNZIP
%SystemRoot%\explorer.exe "c:\"
set /p DUMMY=Please extract the .zip file and rename the folder so that it is C:\zabbix
GOTO MAIN

:CONFIG
echo *******create .conf file
echo Server=%IP% > c:\zabbix\zabbix_agentd.conf
echo ServerActive=%IP%:10051 > c:\zabbix\zabbix_agentd.conf
echo Hostname=%HOSTNAME% >> c:\zabbix\zabbix_agentd.conf
echo StartAgents=5 >> c:\zabbix\zabbix_agentd.conf
echo DebugLevel=3 >> c:\zabbix\zabbix_agentd.conf
echo LogFile=c:\zabbix\zabbix_agentd.log >> c:\zabbix\zabbix_agentd.conf
echo Timeout=3 >> c:\zabbix\zabbix_agentd.conf
echo *******CONF file created*******
GOTO MAIN

:SERVICE
echo *******Start Service!!
call C:\zabbix\bin\win32\zabbix_agentd.exe --config c:\zabbix\zabbix_agentd.conf --install
echo *******Started Service!!
GOTO MAIN

:FIREWALL
echo *******update firewall
netsh advfirewall firewall add rule name="Zabbix Agent" dir=in action=allow program="C:\zabbix\bin\win32\zabbix_agentd.exe" enable=yes profile=domain
netsh advfirewall firewall add rule name="Zabbix Agent" dir=in action=allow program="C:\zabbix\bin\win32\zabbix_agentd.exe" enable=yes profile=public
netsh advfirewall firewall add rule name="Zabbix Agent" dir=in action=allow program="C:\zabbix\bin\win32\zabbix_agentd.exe" enable=yes profile=private
pause

rem start the service

rem verify all is well.
GOTO FIREWALLDONE

