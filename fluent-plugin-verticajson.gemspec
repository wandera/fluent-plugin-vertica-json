Gem::Specification.new do |spec|
  spec.name     = "fluent-plugin-verticajson"
  spec.version  = File.read("VERSION").strip
  spec.authors  = ["Josef Janda"]
  spec.email    = ["josef.janda@wandera.com"]
  spec.license  = "MIT"

  spec.summary = "Fluentd output plugin for Vertica using json parser."

  spec.required_ruby_version = '>= 1.9.1'

  spec.add_dependency 'fluentd', '~> 0.10.35'
  spec.add_dependency 'vertica'
  spec.add_dependency 'json'

  spec.files = Dir['LICENSE', 'README.md', '{lib, test}/**/*']
end
