# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

target 'Roommate' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Roommate
	pod 'Alamofire', '~> 4.7.3'
	pod 'AlamofireObjectMapper', '~> 5.1.0'
	pod 'ObjectMapper', '~> 3.3.0'
	pod 'SDWebImage', '~> 4.4.2'
	pod 'TTRangeSlider', '~> 1.0.6'
	pod 'GooglePlaces', '~> 2.7.0'
  	pod 'GooglePlacePicker', '~> 2.7.0'
  	pod 'GoogleMaps', '~> 2.7.0'
	pod 'ObjectMapper+Realm', '~> 0.6'
	pod 'SkyFloatingLabelTextField', '~> 3.6.0'
	pod 'Firebase/Core'
	pod 'Firebase/Database'
	pod 'MBProgressHUD', '~> 1.1.0'
	pod 'SwiftyJSON', '~> 4.2.0'
	pod 'Cosmos', '~> 16.0'
	
end

# Workaround for Cocoapods issue #7606
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end