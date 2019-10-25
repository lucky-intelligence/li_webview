#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'li_webview'
  s.version          = '0.0.2'
  s.summary          = 'Yet another web view plugin'
  s.description      = <<-DESC
                          Yet another web view plugin
                        DESC
  s.homepage         = 'http://luckyintelliegence.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Lucky Intelligence' => 'developer@luckyintelligence.com' }
  s.source           = { :git => 'https://github.com/lucky-intelligence/li_webview.git', :branch => 'master' }

  s.swift_version = '4.0'
  s.static_framework = true

  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.exclude_files = "Constrictor/Constrictor/*.plist"

  s.platform = :ios
  s.ios.deployment_target  = '8.0'
  s.framework      = 'SystemConfiguration'
  s.ios.framework  = 'UIKit'

  s.dependency 'Flutter'
end

