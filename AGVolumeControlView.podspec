#
# Be sure to run `pod lib lint AGVolumeControlView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AGVolumeControlView'
  s.version          = '0.1.0'
  s.summary          = 'A short description of AGVolumeControlView.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/agilie/AGVolumeControlView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Agilie' => 'info@agilie.com' }
  s.source           = { :git => 'https://github.com/agilie/AGVolumeControlView.git', :tag => '0.1.0' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AGVolumeControlView/Classes/**/*.{swift}'
  
    s.frameworks = 'UIKit'
end
