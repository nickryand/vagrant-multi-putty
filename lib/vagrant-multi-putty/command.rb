# Pieces of this plugin were taken from the bundled vagrant ssh plugin.
require 'rubygems'
require 'optparse'

module VagrantMultiPutty
  class Command < Vagrant.plugin(2, :command)
    def execute
      
      # config_global is deprecated from v1.5
      if Gem::Version.new(::Vagrant::VERSION) >= Gem::Version.new('1.5')
        @config = @env.vagrantfile.config
      else
        @config = @env.config_global
      end
      
      options = {:modal => @config.putty.modal,
                 :plain_auth => false }
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: vagrant putty [vm-name...] [-- extra putty args]"

        opts.on("-p", "--plain", "Plain auth mode which will require the user to provide a password.") do |p|
          options[:plain_auth] = p
        end

        opts.on("-m", "--modal", "Block until all spawned putty processes have exited") do |m|
          options[:modal] = m
        end

        opts.separator ""
      end

      argv = parse_options(opts)
      return -1 if !argv

      # This is borrowed from the ssh base command that ships with vagrant.
      # It is used to parse out arguments meant for the putty program.
      putty_args = ARGV.drop_while { |i| i != "--" }
      putty_args = putty_args[1..-1] if !putty_args.empty?
      @logger.debug("Putty args: #{putty_args}")

      # argv needs to be purged of the extra putty arguments. The remaining arguments
      # (if any) will be the VM names to log into.
      argv = argv - putty_args

      # Since putty is a program with a GUI window, we can perform a spawn and
      # detach the process from vagrant.
      with_target_vms(argv) do |vm|
        @logger.info("Launching putty session to: #{vm.name}")
        putty_connect(vm, putty_args, options)
      end

      if options[:modal]
        Process.waitall
        @config.putty.after_modal_hook.call
      end

      return 0
    end

    def putty_connect(vm, args, options={})
      # This isn't called by vagrant automatically.
      vm.config.putty.finalize!

      ssh_info = vm.ssh_info
      # If ssh_info is nil, the machine is not ready for ssh.
      raise Vagrant::Errors::SSHNotReady if ssh_info.nil?

      ssh_options = []

      # Load a saved putty session if provided. Putty (v0.63 at least) appears
      # to have a weird bug where a hostname specified on the command line will
      # not override the hostname in a session unless the hostname comes after
      # the -load option. This doesn't appear to affect any other command line
      # options aside from hostname.
      ssh_options += ["-load", vm.config.putty.session] if
        vm.config.putty.session

      # Load options from machine ssh_info.
      ssh_options += [ssh_info[:host]]
      # config.putty.username overrides the machines ssh_info username.
      ssh_options += ["-l", vm.config.putty.username || ssh_info[:username]]
      ssh_options += ["-P", ssh_info[:port].to_s]
      ssh_options += ["-X"] if ssh_info[:forward_x11]
      ssh_options += ["-A"] if ssh_info[:forward_agent]

      # Putty only allows one ssh key to be passed with the -i option
      # so we default to choosing the first default key if it is not
      # explicitly set.
      private_key = vm.config.putty.private_key_path ||
        ssh_info[:private_key_path][0] + ".ppk"
      @logger.debug("Putty Private Keys: #{private_key.to_s}")
      ssh_options += ["-i", private_key] unless options[:plain_auth]

      # Add in additional args from the command line.
      ssh_options.concat(args) if !args.nil?

      # Spawn putty and detach it so we can move on.
      @logger.debug("Putty cmd line options: #{ssh_options.to_s}")
      pid = spawn("putty", *ssh_options)
      @logger.debug("Putty Child Pid: #{pid}")
      Process.detach(pid)
    end
  end
end
