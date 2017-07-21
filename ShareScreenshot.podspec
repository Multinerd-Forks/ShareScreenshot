#
# Be sure to run `pod lib lint ShareScreenshot.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ShareScreenshot'
  s.version          = '0.1.6'
  s.summary          = 'Send screenshots with annotations and text with ease.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    ShareScreenshot is a library that can take screenshot in any place of your app by shaking your device.
    It's super usefull for QA teams for sharing UI bug reports with Dev teams by Mail, iMessage and etc.
    Also it's possible to define your own way to share, for example create bug in Jira or post to Slack channel.
                       DESC

  s.homepage         = 'https://github.com/adanilyak/ShareScreenshot'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'adanilyak' => 'adanilyak@gmail.com' }
  s.source           = { :git => 'https://github.com/adanilyak/ShareScreenshot.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/adanilyak'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ShareScreenshot/Classes/**/*'
  
  s.resource_bundles = {
    'ShareScreenshot' => ['ShareScreenshot/Assets/*.{lproj,storyboard,xib,xcassets}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Masonry', '~> 1.0.1'
end
