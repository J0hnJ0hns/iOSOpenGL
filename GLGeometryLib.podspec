Pod::Spec.new do |s|

  s.name         = "GLGeometryLib"
  s.version      = "1.0"
  s.summary      = "The GLGeometryLib library is a tool designed for rendering geometric shapes efficiently."
  s.homepage     = "https://homepage.io"

  s.license      = "MIT"
  s.author       = "GLGeometryLib"

  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com//.git", :tag => "v#{s.version}" }
  s.swift_version = '5.0'

  s.ios.deployment_target = "11.0"
  s.osx.deployment_target = "11.0"

  s.source_files  = 'GLGeometryLib/Source/*{h, hpp}', 'GLGeometryLib/Source/*{mm,c,cpp}'
  s.module_map    = 'GLGeometryLib/GLGeometryLib.modulemap'

end
