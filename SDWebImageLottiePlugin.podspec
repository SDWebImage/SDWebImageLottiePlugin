#
# Be sure to run `pod lib lint SDWebImageLottiePlugin.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SDWebImageLottiePlugin'
  s.version          = '1.0.0'
  s.summary          = 'SDWebImage integration with Lottie Animation using remote JSON files'

  s.description      = <<-DESC
SDWebImageLottiePlugin is a plugin for SDWebImage framework, which provide the Lottie animation loading from JSON file.
                       DESC

  s.homepage         = 'https://github.com/SDWebImage/SDWebImageLottiePlugin'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DreamPiggy' => 'lizhuoli1126@126.com' }
  s.source           = { :git => 'https://github.com/SDWebImage/SDWebImageLottiePlugin.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '11.0'

  s.source_files = 'SDWebImageLottiePlugin/Classes/**/*'

  s.pod_target_xcconfig = {
    'SUPPORTS_MACCATALYST' => 'YES',
    'DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER' => 'NO'
  }

  s.dependency 'SDWebImage', '~> 5.10'
  s.dependency 'lottie-ios', '~> 3.4'
end
