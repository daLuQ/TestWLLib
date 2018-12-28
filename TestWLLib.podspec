Pod::Spec.new do |spec|
  spec.name         = "TestWLLib"
  spec.version      = "0.0.4"
  spec.summary      = "TestWLLib"
  spec.description  = <<-DESC
TestWLLib测试仓库
                   DESC

  spec.homepage     = "https://github.com/daLuQ/TestWLLib"
  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author             = { "LiuZiStrugle" => "15850581247@163.com" }
   spec.platform     = :ios
   spec.platform     = :ios, "9.0"

  #  When using multiple platforms
   spec.ios.deployment_target = "9.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"
  spec.source       = { :git => "https://github.com/daLuQ/TestWLLib.git", :tag => spec.version }

spec.framework = 'ImageIO'

spec.default_subspec = 'WLLogan'
spec.subspec 'WLLogan' do |wLLogan|
    wLLogan.source_files = 'Classes/WLMapUtils.{h,m}'
#wLLogan.source_files = 'Classes/WLWLMapUtils.*'
end

spec.subspec 'Person' do |person|
    person.source_files = 'Classes/WLTestModel.*'
end
#spec.source_files  = "Classes", "Classes/**/*.{h,m}"
#spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
spec.dependency 'JSONModel', '~> 1.8.0'

end
