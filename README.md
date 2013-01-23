# vagrant-multi-putty

* Source: https://github.com/nickryand/vagrant-multi-putty

Vagrant ssh allows only one login at a time and is not currently supported on
Windows. This plugin allows you to use putty to login to VMs.
Vagrant-multi-putty supports multiple VMs.

## Installation
### Software
To install this plugin for the gem version of Vagrant:
    $ gem install vagrant-multi-putty

To install under the non-gem installed version of Vagrant:
    $ vagrant gem install vagrant-multi-putty

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

## Usage
Basic usage:
    vagrant putty

Login into a single vm in a multiple vm environment:
    vagrant putty <name of vm>

Pass putty options directly to the putty binary:
    vagrant putty -- -l testuser -i <path to private key>
