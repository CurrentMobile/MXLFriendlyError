#
# Be sure to run `pod lib lint MXLFriendlyError.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MXLFriendlyError"
  s.version          = "0.1.9"
  s.summary          = "A library to replace nasty HTTP errors with friendly ones."
  s.description          = "This library provides a category on NSError that supplies localized custom error descriptions for HTTP status codes."
  s.homepage         = "https://github.com/mobilexlabs/MXLFriendlyError"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "John Welch" => "john@mobilexlabs.com" }
  s.source           = { :git => "https://github.com/mobilexlabs/MXLFriendlyError.git", :tag => "0.1.9" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Category'
  s.resource = 'Resource/error.plist'

  # s.public_header_files = 'Category/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
