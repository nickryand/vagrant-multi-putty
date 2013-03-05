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

  s.required_rubygems_version = ">= 1.4.0"

  s.add_dependency "vagrant", "~> 1.0.5"

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
end
