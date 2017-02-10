Pod::Spec.new do |s|
  s.name = 'MDTestAccountManager'
  s.version = '0.1'
  s.license = 'Proprietary'
  s.summary = 'Manage test accounts for application logins.'
  s.description = "Manage test accounts for application logins. Also includes multiple environment support and broadcasts a notification when an account is selected'"
  s.homepage = 'https://stash.mgmt.local/projects/IOSLIB/repos/mdtestaccountmanager'
  s.authors = { 'Michael Leber' => 'michael.leber@ihsmarkit.com'}
  s.source = { :git => 'ssh://git@stash.mgmt.local/ioslib/mdtestaccountmanager.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/*.swift'
  
  s.dependency 'CSV.swift', '~> 1.0'
end