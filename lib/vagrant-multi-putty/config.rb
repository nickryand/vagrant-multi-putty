module VagrantMultiPutty
  class PuttyConfig < Vagrant.plugin(2, :config)
	attr_accessor :username
	attr_accessor :private_key_path
	attr_accessor :after_modal_hook
	attr_accessor :modal
	attr_accessor :session
	attr_accessor :convert_key_file

	def after_modal &proc
	  @after_modal_hook = proc
	end

	def initialize
	  @username = UNSET_VALUE
	  @private_key_path = UNSET_VALUE
	  @after_modal_hook = UNSET_VALUE
	  @modal = UNSET_VALUE
	  @session = UNSET_VALUE
	  @convert_key_file = UNSET_VALUE
	end

	def finalize!
	  @username = nil if @username == UNSET_VALUE
	  @private_key_path = nil if @private_key_path == UNSET_VALUE
	  @after_modal_hook = Proc.new{  } if @after_modal_hook == UNSET_VALUE
	  @modal = false if @modal == UNSET_VALUE
	  @session = nil if @session == UNSET_VALUE
	  @convert_key_file = true if @convert_key_file == UNSET_VALUE
	end

	def validate(machine)
	  {}
	end
  end
end
