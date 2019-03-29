Pod::Spec.new do |s|
  s.name          = "Insomnia"
  s.version       = "2.0.0"
  s.summary       = "Small class to disable sleep timeout in iOS."
  s.description   = "Sometimes you want your iPhone to stay awake a little bit longer."
  s.homepage      = "https://github.com/ochococo/insomnia/"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = "Oktawian Chojnacki"
  s.platform      = :ios, "10.0"
  s.source        = { :git => "https://github.com/ochococo/insomnia.git", :tag => "#{s.version}" }
  s.source_files  = "Insomnia/**/*.{swift}"
  s.swift_version = '5.0'
end
