#! /bin/bash -v

pushd /etc/yum.repos.d/
sudo wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
sudo sed -i "s/\$releasever/20/" virtualbox.repo
popd

sudo yum install VirtualBox-4.3
sudo yum install https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.5_x86_64.rpm

pushd ~/Projects
rm -fr backend
git clone git@github.com:HackOregon/backend
cd backend
vagrant box add ubuntu14 https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box
vagrant init ubuntu14
vagrant up
popd
