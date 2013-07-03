# -*- encoding: utf-8 -*-

require File.expand_path('../lib/ffi-geoip/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "ffi-geoip"
  s.version = GeoIP::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["J Smith"]
  s.description = "An ffi wrapper for GeoIP"
  s.summary = s.description
  s.email = "dark.panda@gmail.com"
  s.license = "MIT"
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = `git ls-files`.split($\)
  s.executables = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.homepage = "http://github.com/dark-panda/ffi-geoip"
  s.require_paths = ["lib"]

  s.add_dependency("ffi", [">= 1.0.0"])
end

