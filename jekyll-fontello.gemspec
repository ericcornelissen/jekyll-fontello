Gem::Specification.new do |spec|
  spec.name        = 'jekyll-fontello'
  spec.version     = '0.1.4'
  spec.date        = '2018-05-18'
  spec.summary     = 'Fontello for jekyll'
  spec.description = 'Jekyll plugin that automatically downloads your webfont from Fontello.'
  spec.authors     = ['Eric Cornelissen']
  spec.email       = 'ericornelissen@gmail.com'
  spec.files       = ['lib/jekyll-fontello.rb']
  spec.homepage    = 'https://rubygems.org/gems/jekyll-fontello'
  spec.license     = 'MIT'
  spec.extra_rdoc_files = ['README.md', 'LICENSE']

  spec.add_runtime_dependency 'rubyzip', '~> 1.2'
  spec.add_development_dependency 'codecov', '~> 0.1'
  spec.add_development_dependency 'jekyll', '~> 3.5'
  spec.add_development_dependency 'simplecov', '~> 0.15'
end
