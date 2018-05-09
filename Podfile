source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
inhibit_all_warnings!

target 'HiShow' do

  use_frameworks!

    # Pods for HiShow
    pod 'Alamofire', '~> 4.7'
    pod 'Kingfisher', '~> 4.7'
    pod 'Navi', '~> 1.1'
#    pod 'MJRefresh', '~> 3.1.14'
    pod 'GDPerformanceView-Swift', '~> 1.3'
    pod 'SwiftyJSON'
    pod 'FaceAware'
    pod 'ESPullToRefresh'

  target 'HiShowTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HiShowUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
