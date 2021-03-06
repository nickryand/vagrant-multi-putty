require File.expand_path("../lib/vagrant-multi-putty/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "vagrant-multi-putty"
  s.version     = VagrantMultiPutty::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nick Downs"]
  s.email       = ["nickryand@gmail.com"]
  s.licenses    = ["MIT"]
  s.homepage    = "https://github.com/nickryand/vagrant-multi-putty"
  s.summary     = "Vagrant plugin to allow VM ssh with PuTTY (multi-vm supported)"
  s.description = "Vagrant plugin to allow VM ssh with PuTTY (multi-vm supported)"

  s.required_ruby_version = ">= 2.1.0"
  s.required_rubygems_version = ">= 1.4.0"

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
  
  s.add_runtime_dependency "putty-key", "~> 1.0"
end
