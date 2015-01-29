Pod::Spec.new do |s|
  s.name     = 'MPBSignatureViewController'
  s.version  = '1.4.0'
  s.platform = :ios, '8.0'
  s.license  = {:type => 'MIT'}
  s.summary  = 'Signature Field'
  s.homepage = 'http://www.payworksmobile.com'
  s.author   = { 'payworks GmbH' => 'info@payworksmobile.com' }
  s.source   = { :git => 'https://bitbucket.org/payworks/mpos.ios.blocks.signatureview.git', :tag => s.version.to_s }
  s.description = 'A ViewController to capture a user\'s signature on screen and access it as an UIImage'
  s.source_files = 'MPBSignatureViewController/*.{h,m}', 'External/**/*.{h,m}'
  s.resource_bundle  = { 'MPBSignatureViewResources' => ['Resources/*.png', 'Resources/*.lproj'] }
  s.requires_arc =  true
  s.frameworks = 'GLKit', 'OpenGLES'
  s.private_header_files  = 'MPBSignatureViewController/*Private.h'
end
