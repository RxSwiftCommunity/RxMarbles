platform :ios, '9.2'
use_frameworks!
inhibit_all_warnings!

target 'RxMarbles' do

pod 'RxSwift',    '~> 4.0'
pod 'RxCocoa',    '~> 4.0'
pod 'Device'
pod 'RazzleDazzle', :git => 'https://github.com/carlosypunto/RazzleDazzle.git', :tag => '0.2.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      configuration.build_settings['SWIFT_VERSION'] = "4.0"
    end
  end
end
