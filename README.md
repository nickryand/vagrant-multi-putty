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

### SSH Private Key conversion using PuTTYgen
Download: http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html

Putty uses a custom format for SSH keys. It does not support openssl keys
directly. Using PuTTYgen, you can convert the private key shipped with vagrant
or convert a private key of your own.

#### Steps for converting the shipped insecure private key
 1. Open puttygen and click the Conversions -> Import Key menu option.
 2. Select the insecure_private_key located at ~/.vagrant.d/insecure_private_key
 3. Click the "Save private key" button and store the key right along side the
    insecure key.
 4. Answer yes when prompted to save without a password.
 5. Save the key using the filename of "insecure_private_key.ppk".

If you do not explicity set the `config.putty.private_key_path`
variable, you need to convert the insecure_private_key and store it
with a ".ppk" extension. The vagrant-multi-putty plugin appends this
extension automatically.

As of Vagrant 1.4.0, the `config.ssh.private_key_path` variable is converted into
an array. This allows multiple SSH keys to be passed to ssh. PuTTY does not
allow for a list of ssh keys via the command line. Therefore, if the
`config.putty.private_key_path` variable is not set, we attempt to use the first
key in the `config.ssh.private_key_path` list and append the '.ppk' extension
to it.

## Configuration
Most of the ssh configuration options used to control vagrant ssh also
control vagrant-multi-putty. The following Vagrantfile options are NOT used by
vagrant-multi-putty:

*    `config.ssh.max_tries`
*    `config.ssh.timeout`
*    `config.ssh.private_key_path`
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
