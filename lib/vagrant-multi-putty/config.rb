
module VagrantMultiPutty
  class PuttyConfig < Vagrant::Config::Base
    attr_accessor :username
    attr_accessor :private_key_path
  end

  Vagrant.config_keys.register(:putty) { PuttyConfig }
end
