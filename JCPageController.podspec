Pod::Spec.new do |s|

s.name         = "JCPageController"
s.version      = "1.0.2"
s.summary      = "JCPageController"

s.homepage     = "https://github.com/JiachengZheng/JCPageController"

s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "zhengjiacheng" => "jiacheng_zheng@163.com" }
s.platform     = :ios, "7.0"
s.ios.deployment_target = "7.0"
s.source       = { :git => 'https://github.com/JiachengZheng/JCPageController.git', :tag => s.version }
s.source_files  = 'JCPageController/**/*.{h,m}'

# s.resource  = "icon.png"
# s.resources = "Resources/**/.png"
s.public_header_files = 'JCPageController/**/*.h'
s.requires_arc = true

# s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

end
