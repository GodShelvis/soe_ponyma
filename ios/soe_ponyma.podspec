#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint soe_ponyma.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'soe_ponyma'
  s.version          = '0.0.1'
  s.summary          = '腾讯云智聆口语评测SDK.'
  s.description      = <<-DESC
腾讯云智聆口语评测SDK.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  # 引入资源
  s.ios.vendored_frameworks = 'Frameworks/lame.framework', 'Frameworks/TAISDK.framework'
  s.vendored_frameworks = 'lame.framework', 'TAISDK.framework'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
