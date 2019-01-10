Pod::Spec.new do |s|
  s.name = 'SwiftCrypto'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'A simple Cryptography Implementation in Swift for the PHANTOM Blockchain'
  s.homepage = 'https://github.com/PhantomChain/swift-crypto'
  s.authors = { 'PhantomChain' => 'info@phantom.org' }
  s.source = { :git => 'https://github.com/PhantomChain/swift-crypto.git', :tag => s.version }

  s.ios.deployment_target = '10.0'

  s.dependency 'BitcoinKit', '1.0.2'

  s.source_files = 'Crypto/Crypto/**/*.swift'
end