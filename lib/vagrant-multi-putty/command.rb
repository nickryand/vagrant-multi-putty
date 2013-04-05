# Pieces of this plugin were taken from the bundled vagrant ssh plugin.
require 'rubygems'
require 'optparse'

module VagrantMultiPutty
  class Command < Vagrant.plugin(2, :command)
    def execute
      options = {}
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: vagrant putty [vm-name...] [-- extra putty args]"

        opts.on("-p", "--plain", "Plain auth mode which will require the user to provide a password.") do |p|
          options[:plain_auth] = p
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
        # Also borrowed from the base ssh.rb code.
        # Basic checks needed for a putty connection
        raise Vagrant::Errors::VMNotCreatedError if !vm.state.id == :not_created
        raise Vagrant::Errors::VMInaccessible if !vm.state.id == :inaccessible
        raise Vagrant::Errors::VMNotRunningError if vm.state.id != :running

        @logger.info("Launching putty session to: #{vm.name}")
        putty_connect(vm, putty_args, plain_auth=options[:plain_auth])
      end
      return 0
    end

    def putty_connect(vm, args, plain_auth=False)
      # Get the path to the private key for VM.
      private_key = vm.config.putty.private_key_path || "#{vm.env.default_private_key_path}.ppk"
      pk_path = File.expand_path("#{private_key}", vm.env.root_path)
      @logger.debug("Putty Private Key: #{pk_path}")

      # Load options set in the Vagrantfile
      ssh_port = vm.config.ssh.port
      options = [vm.config.ssh.host]
      options += ["-l", vm.config.putty.username || vm.config.ssh.username]
      options += ["-P", ssh_port.to_s]
      options += ["-i", pk_path] if !plain_auth
      options += ["-X"] if vm.config.ssh.forward_x11
      options += ["-A"] if vm.config.ssh.forward_agent

      # Add in additional args from the command line.
      options.concat(args) if !args.nil?

      # Spawn putty and detach it so we can move on.
      @logger.debug("Putty cmd line options: #{options.to_s}")
      pid = spawn("putty", *options)
      @logger.debug("Putty Child Pid: #{pid}")
      Process.detach(pid)
    end
  end
end
