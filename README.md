# vagrant-multi-putty

* Source: https://github.com/nickryand/vagrant-multi-putty

This plugin allows you to use putty to ssh into VMs. It has been tested on
Windows and should also work on Linux. Multi-vm environments are supported.

## Installation
### Vagrant Version Support
Vagrant > 1.1.X
### Software
To install for Vagrant versions > 1.1
```
$ vagrant plugin install vagrant-multi-putty
```

### Putty Binary
Download: http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html

Download the putty executable for your platform and add it's location to your
PATH environment variable. Seek your operating system manual for instructions
on how to modify your PATH variable.

### SSH Private Key conversion
SSH keys will be automatically converted to the ppk format used by putty.

As of Vagrant 1.4.0, the `config.ssh.private_key_path` variable is converted into
an array. This allows multiple SSH keys to be passed to ssh. PuTTY does not
allow for a list of ssh keys via the command line. Therefore, if the
`config.putty.private_key_path` variable is not set, we attempt to use the first
key in the `config.ssh.private_key_path` list.

## Configuration
Most of the ssh configuration options used to control vagrant ssh also
control vagrant-multi-putty. The following Vagrantfile options are NOT used by
vagrant-multi-putty:

*    `config.ssh.max_tries`
*    `config.ssh.timeout`
*    `config.ssh.shell`

All other config.ssh options should work for vagrant-multi-putty just like they
do for vagrant ssh.

There are currently a few additional configuration parameters available:

*    `config.putty.username`: Overrides the username set with
    ` config.ssh.username`.
*    `config.putty.private_key_path`: Used to explicity set the path to the
     private key variable. When set to `:agent`, no private key file is supplied
     and PuTTY will try private keys loaded by Pageant.
*    `config.putty.modal`: change vagrant-multi-putty to use modal window mode.
     Execute putty and block the terminal until all putty processes have exited.
     Can be set on the command line with `-m` or `--modal`. This is false by default.
*    `config.putty.after_modal`: Configure a post hook block that will be called
     once all child putty processes have exited and modal mode is enabled. The
     default block is empty.
*    `config.putty.session`: Load settings from a saved putty session.
*    `config.putty.ssh_client`: Allow end users to control the path to the putty
     or putty like (kitty for example) binary.
     Use slashes (not backslashes) for full path under Windows, for example:
     `config.putty.ssh_client = "C:/Program Files (x86)/PuTTY/putty.exe"`
*    `config.putty.ssh_options`: Allow end users define the Connection type or
     any other arguments. Multiple options separaed by comma. Default is `-ssh`.

#### Example usage of after_modal post hook
This is an example which uses the the win32-activate gem written by nazoking. This
only works on windows since win32-activate uses the win32 API.

Github Page: https://github.com/nazoking/win32-activate

After all putty windows are closed, the terminal window used to run the 'vagrant putty'
command will be brought into focus and placed on top of all open windows.
```
Vagrant.configure("2") do |config|
  # always modal mode
  config.putty.modal = true
  # set hook.
  config.putty.after_modal do
    require 'win32/activate'
    Win32::Activate.active
  end
end
```

#### Example multiple tunnels
This example sets the path to your PuTTY installation.
The ssh_options are used to enable a tunnel from host port 8008 to port 80 on guest.
The second tunnel is a reverse tunnel from guest port 6000 back to the host port 6000,
so you can use Xming as Xserver on your host as output for X11, for example
`DISPLAY=localhost:0.0 xclock`.
```
Vagrant.configure("2") do |config|
  # Set PATH for PuTTY
  config.putty.ssh_client = "C:/Program Files (x86)/PuTTY/putty.exe"
  # Overwrite default options with SSH as protocol,
  # enable tunnel from host port 8008 to guest port 80, and set
  # reverse tunnel from guest port 6000 to host port 6000.
  config.putty.ssh_options = "-ssh", "-L", "8008:localhost:80", "-R", "6000:localhost:6000"
  #
end
```

## Usage
Basic usage:
```
vagrant putty
```

Login into a single vm in a multiple vm environment:
```
vagrant putty <name of vm>
```

Pass putty options directly to the putty binary:
```
vagrant putty -- -l testuser -i <path to private key>
```
