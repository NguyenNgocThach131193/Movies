platform :ios, '15.0'

def main_pods
  pod 'SwiftyJSON'
  pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxAlamofire'
  pod 'PKHUD'
  pod 'Swinject'
  pod 'SDWebImage'
end

target 'Movies' do
  use_frameworks!
  main_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
