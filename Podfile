# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

target 'BlueButtonKit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BlueButtonKit
  pod 'FHIR', :git => 'https://github.com/nickrobison-usds/Swift-FHIR.git', :branch => 'swift5-stu3'
  pod 'SwiftIcons', '~> 2.3.2'


  target 'BlueButtonKitTests' do
    # Pods for testing
  end

end

target 'DPCExplorer' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DPCExplorer
  pod 'FHIR', :git => 'https://github.com/nickrobison-usds/Swift-FHIR.git', :branch => 'swift5-stu3'

  target 'DPCExplorerTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'BlueRSA'
  end

  target 'DPCExplorerUITests' do
    # Pods for testing
  end

end

target 'DPCKit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire', '~> 5.0.0-rc.3'
  pod 'FHIR', :git => 'https://github.com/nickrobison-usds/Swift-FHIR.git', :branch => 'swift5-stu3'

  # Pods for DPCKit

  target 'DPCKitTests' do
    # Pods for testing
  end

end
