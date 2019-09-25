#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'li_webview'
  s.version          = '0.0.1'
  s.summary          = 'Yet another web view plugin'
  s.description      = 'Yet another web view plugin'
  s.homepage         = 'http://luckyintelliegence.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Lucky Intelligence' => 'developer@luckyintelligence.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
  s.static_framework = true
  s.swift_version = '4.0'
end