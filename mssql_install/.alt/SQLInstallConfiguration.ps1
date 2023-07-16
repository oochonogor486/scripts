Configuration SQLInstall
{
     Import-DscResource -ModuleName SqlServerDsc
     #Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

     Node localhost
     {
          WindowsFeature 'NetFramework45'
          {
               Name   = 'NET-Framework-45-Core'
               Ensure = 'Present'
          }

          SqlSetup 'InstallDefaultInstance'
          {
               InstanceName        = 'MSSQLSERVER'
               Features            = 'SQLENGINE'
               SourcePath          = 'C:\Program Files\Microsoft SQL Server\150\Setup Bootstrap\SQL2019\'
               SQLSysAdminAccounts = @('Administrators')
               DependsOn           = '[WindowsFeature]NetFramework45'
          }
     }
}