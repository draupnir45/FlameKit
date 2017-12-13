Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '9.0'
s.name = "FlameKit"
s.summary = "iOS 11 style custom UI for 9.0+."
s.requires_arc = true

# 2
s.version = "0.1.0"

# 3
s.license = { :type => "Apache 2.0", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Jongchan Park" => "draupnir45@gmail.com" }

# For example,
# s.author = { "Joshua Greene" => "jrg.developer@gmail.com" }


# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/draupnir45/FlameKit"

# For example,
# s.homepage = "https://github.com/JRG-Developer/RWPickFlavor"


# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/draupnir45/FlameKit", :tag => "#{s.version}"}

# For example,
# s.source = { :git => "https://github.com/JRG-Developer/RWPickFlavor.git", :tag => "#{s.version}"}


# 7
s.framework = "UIKit"

# 8
s.source_files = "FlameKit/**/*.{swift}"

# 9
s.resources = "FlameKit/**/*.{png,jpeg,jpg,storyboard,xib}"
end
