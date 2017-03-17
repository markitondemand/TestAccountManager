# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

source 'ssh://git@stash.mgmt.local/ioslib/markitpodspecs.git'
source 'https://github.com/CocoaPods/Specs.git'


workspace 'MDTestAccountManager.xcworkspace'

target 'Example' do
  project 'Example/Example.xcodeproj'
  use_frameworks!
  
  pod 'MDTestAccountManager', :path => './MDTestAccountManager.podspec'
end

target 'MDTestAccountManager' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MDTestAccountManager
  pod 'MDTestAccountManager', :path => './MDTestAccountManager.podspec'

  target 'MDTestAccountManagerTests' do
    inherit! :search_paths
    # Pods for testing
  end
end
