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

Download the putty executable for your platform and place it's location on your
PATH variable. Seek your operating system manual for instructions on how to
modify your PATH variable.

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

Note: If you do not explicity set the config.putty.private_key_path variable,
you need to convert the insecure_private_key and store it with the a ".ppk"
extension. The vagrant-multi-putty plugin appends this extension automatically.

## Configuration
Most of the ssh configuration options used to control vagrant ssh also
control vagrant-multi-putty. The following Vagrantfile options are NOT used by
vagrant-multi-putty:

*    config.ssh.max_tries
*    config.ssh.timeout
*    config.ssh.private_key_path
*    config.ssh.shell

All other config.ssh options should work for vagrant-multi-putty just like they
do for vagrant ssh.

There are currently two additional configuration parameters available:

*    config.putty.username: Overrides the username set with
     config.ssh.username.
*    config.putty.private_key_path: Used to explicity  set the path to the
     private key variable.
*    config.putty.modal: use putty like modal window mode. Execute putty and
     wait close putty. You want to get same effect on command line, set '-m' option.
*    config.putty.after_modal: Set hook block. Block called after window closed on modal window mode.

ex. your Vagrantfile ( $HOME/.vagrant.d/Vagrantfile )
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
