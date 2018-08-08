Pod::Spec.new do |s|

  s.name         = 'LocalTimeZone'
  s.version      = '0.0.1'
  s.summary      = '夏令时，格式化时间出现nil的问题'
  s.homepage     = 'https://github.com/niuzai327/LocalTimeZone'
  s.license      = 'MIT'
  s.author             = { 'YXY' => '1064136787@qq.com' }
  s.platform     = :ios, '8.0'
  s.source_files = 'LocalTimeZoneFormatter/*'
  s.source       = { :git => "https://github.com/niuzai327/LocalTimeZone.git", :tag => s.version }
  s.requires_arc = true

end
