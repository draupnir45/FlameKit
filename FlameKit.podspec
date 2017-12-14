#
# Be sure to run `pod lib lint FlameKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlameKit'
  s.version          = '0.1.5'
  s.summary          = 'iOS 11 style NavigationBar, combination with VerticalStack-ScrollView'

  s.description      = <<-DESC
FlameKit is collection of simple custom UIs. For version 0.1.0, it offers FlameNavigationBar, FlameScrollView & FlameButton. 

FlameNavigationBar is UIView-based customizable NavigationBar. FlameNavigationBar supports iOS 11 style LargeTitle and collapsing. It's compatible with scrollview. (FlameNavigationBar will be a delegate of scrollView... It will be fixed in future update.)

FlameScrollView is subclass of UIScrollView which has UIStackView(vertical) as a built-in subview. It's seats somewhere between UIScrollView and UITableView. If you want to add vertical stack simply call addArrangedSubview(_:animated:horizontalInset:height:) to the instance of FlameScrollView. FlameScrollView also automatically listen to the keyboard show/hide notification.

DESC

  s.homepage         = 'https://github.com/draupnir45/FlameKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jongchan Park' => 'draupnir45@gmail.com' }
  s.source           = { :git => 'https://github.com/draupnir45/FlameKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'FlameKit/**/*'
  
  # s.resource_bundles = {
  #   'FlameKit' => ['FlameKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
# s.dependency 'SnapKit'
end
