#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'li_webview'
  s.version          = '0.0.3'
  s.summary          = 'Personalized plugin to obtain extended javascript features and support WKWebView sensor permission alertDialogs.'
  s.description      = <<-DESC
                        Personalized plugin to obtain extended javascript features and support WKWebView sensor permission alertDialogs.
                        DESC
  s.homepage         = 'http://luckyintelliegence.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Lucky Intelligence' => 'developer@luckyintelligence.com' }
  s.source           = { :git => 'https://github.com/lucky-intelligence/li_webview.git', :branch => 'master' }

  s.swift_version    = '4.0'
  s.static_framework = true

  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.exclude_files    = "Constrictor/Constrictor/*.plist"

  s.platform       = :ios,'8.0'
  s.framework      = 'SystemConfiguration'
  s.ios.frameworks = 'Foundation', 'UIKit', 'WebKit'

  s.dependency 'Flutter'
end

