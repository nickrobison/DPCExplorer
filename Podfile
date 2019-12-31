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
  pod "SwiftJWT", :git => 'https://github.com/nickrobison/Swift-JWT.git', :branch => 'public-signers'
  pod "BlueRSA"

  # Pods for DPCKit

  target 'DPCKitTests' do
    # Pods for testing
  end

end

# Temporary workaround until: https://github.com/CocoaPods/CocoaPods/issues/9275 is merged with 1.9.0
# This fixes the issue with Previews not loading due to missing FHIR dependency in BBKit
class Pod::Target::BuildSettings::AggregateTargetSettings
    BUILT_PRODUCTS_DIR_VARIABLE = "${BUILT_PRODUCTS_DIR}"

    alias_method :ld_runpath_search_paths_original, :ld_runpath_search_paths

    def ld_runpath_search_paths
        ld_runpath_search_paths_original + custom_ld_paths + [BUILT_PRODUCTS_DIR_VARIABLE]
    end

    def custom_ld_paths
        return [] unless configuration_name == "Debug"
        target.pod_targets.map do |pod|
            BUILT_PRODUCTS_DIR_VARIABLE + "/" + pod.product_basename
        end
    end
end
