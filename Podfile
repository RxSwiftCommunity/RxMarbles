# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'RxMarbles' do

pod 'RxSwift',    '~> 4.0'
pod 'RxCocoa',    '~> 4.0'
pod 'Device'
pod 'Fabric'
pod 'Crashlytics'
pod 'RazzleDazzle', :git => 'https://github.com/carlosypunto/RazzleDazzle.git', :tag => '0.2.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      configuration.build_settings['SWIFT_VERSION'] = "4.0"
    end
  end
end
