Gem::Specification.new do |spec|
  spec.name        = 'jekyll-fontello'
  spec.version     = '0.1.1'
  spec.date        = '2018-02-08'
  spec.summary     = 'Fontello for jekyll'
  spec.description = 'Jekyll plugin that automatically downloads your webfont from Fontello.'
  spec.authors     = ['Eric Cornelissen']
  spec.email       = 'ericornelissen@gmail.com'
  spec.files       = ['lib/jekyll-fontello.rb']
  spec.homepage    = 'http://rubygems.org/gems/hola'
  spec.license     = 'MIT'
  spec.extra_rdoc_files = ['README.md', 'LICENSE']

  spec.add_runtime_dependency 'rubyzip'
  spec.add_development_dependency 'jekyll'
end
