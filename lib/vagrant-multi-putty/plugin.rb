require 'vagrant'

module VagrantMultiPutty
  class Plugin < Vagrant.plugin("2")
    name "vagrant-multi-putty"
    description <<-DESC
      Vagrant-multi-putty allows you to ssh into your virtual machines using the putty
      program (or other compatible ssh clients like kitty). This plugin also supports
      opening putty sessions into multi-vm environments.
    DESC

    command "putty" do
      require_relative "command"
      Command
    end

    config "putty" do
      require_relative "config"
      PuttyConfig
    end
  end
end
