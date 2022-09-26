#
# Be sure to run `pod lib lint FormGenerator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FormGenerator'
  s.version          = '1.0.0'
  s.summary          = 'Form Generator is a tool for building forms easily in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Form Generator is a tool for building forms easily in Swift with variety of custom components.
                       DESC

  s.homepage         = 'https://github.com/baianat/FormGenerator-iOS.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Baianat' => 'development@baianat.com' }
  s.source           = { :git => 'https://github.com/baianat/FormGenerator-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.1'
  s.swift_version = '5.0'

  s.source_files = 'FormGenerator/Classes/**/*'
  s.resources = 'FormGenerator/Assets/**/*'
  
  s.dependency 'Navajo-Swift', '~> 2.1.0'
  s.dependency 'M13Checkbox', '~> 3.4.0'
  s.dependency 'PSMeter', '~> 0.1.3'
  s.dependency 'RxSwift', '~> 6.1.0'
  s.dependency 'YPImagePicker', '~> 4.4.0'
  s.dependency 'Nuke', '~> 9.3.0'
  s.dependency 'FlagPhoneNumber', '~> 0.8.0'
  s.dependency 'Vanguard'
  s.dependency 'MediaViewer'
  s.dependency 'R.swift'
  s.dependency 'BetterSegmentedControl', '~> 2.0'
  
end
