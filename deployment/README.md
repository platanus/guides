# Setting Up a production machine

We are going to base our production/staging machine on Ubuntu Server 12.04 LTS. This is the base to be used with our deployment tool [negroku](https://github.com/platanus-repos/negroku) which is based on capistrano

## The basics for your system

Login to the server with the root user
```bash
ssh ubuntu@new-machine-host
sudo su root
```

Set the hostname for the machine, in this case szot
```bash
echo "szot" > /etc/hostname # change szot for any name for this particular machine
echo "szot 127.0.0.1" >> /etc/hosts
hostname -F /etc/hostname
```

Update and upgrade your packages
```bash
apt-get -y update && apt-get -y upgrade
```

Install essential dependencies
```bash
apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison libmysqlclient15-dev libpcre3 libpcre3-dev
```

### A new powerfull user

Create a new user
```bash
adduser yourname
```

Add user to the sudo group
```bash
usermod -a -G sudo yourname
```
Remember to create the `~/.ssh/authorized_keys` file with your public key

Now logout and login again with the sudoer. Remember remove `ubuntu` user.

### The deploy user

Create a user that will run all the deployment tasks
```bash
adduser deploy
echo "deploy ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
```

### Generate a key pair for this user in the `/home/deploy/.ssh` folder, create it if it doens't exist
```bash
cd ~/.ssh
ssh-keygen -t rsa -b 4096 -C "deploy@yourdomain"
```
Then you should add this public key as a deploy key in your github repos.

### The deploy access
Yoy need to add to the `/home/deploy/.ssh/authorized_keys` file all the public keys for the users that are authorized to deploy

Also add the following line to the `/etc/ssh/sshd_config`
```bash
AllowUsers deploy anotheruser
```
You can add more users

### Temp folder for socket files
```bash
su deploy
mkdir -p /home/deploy/tmp
```

## Install Nginx.

Install nginx from source
```bash
sudo add-apt-repository ppa:nginx/stable
sudo apt-get update
sudo apt-get -y install nginx
```

## Install rbenv and ruby

We are going to install rbenv for the deploy user

```bash
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
```

Add rbenv to your PATH. The second command adds shims and autocompletion:

```bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/deploy/.bashrc
echo 'export RBENV_ROOT="$HOME/.rbenv/"' >> /home/deploy/.bashrc
echo 'eval "$(rbenv init -)"' >> /home/deploy/.bashrc
```

Now install ruby-build and rbenv-vars plugins

```bash
mkdir -p ~/.rbenv/plugins
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone https://github.com/sstephenson/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars
```

Reload the profile, install one or more rubies and then rehash to refresh the shims

```bash
source ~/.bashrc
rbenv install 2.0.0-p0
rbenv rehash
```

Set your new rbenv ruby as the new system-wide default ruby for all users using rbenv

```bash
rbenv global 2.0.0-p0
```

## Install nodenv and nodejs

We are going to install nodenv for the deploy user

```bash
git clone git://github.com/OiNutter/nodenv.git ~/.nodenv
```

Add nodenv to your PATH. The second command adds shims and autocompletion:

```bash
echo 'export PATH="$HOME/.nodenv/bin:$PATH"' >> /home/deploy/.bashrc
echo 'export NODENV_ROOT="$HOME/.nodenv/"' >> /home/deploy/.bashrc
echo 'eval "$(nodenv init -)"' >> /home/deploy/.bashrc
```

Now install node-build plugin

```bash
mkdir -p ~/.nodenv/plugins
git clone git://github.com/OiNutter/node-build.git ~/.nodenv/plugins/node-build
```

Reload the profile, install one or more nodes and then rehash to refresh the shims

```bash
source ~/.bashrc
nodenv install 0.10.3
nodenv rehash
```

Set your new nodenv nodejs as the new system-wide default node for all users using nodenv

```bash
nodenv global 0.10.3
```

## Install bundler and Unicorn

Install bundler and the ruby racer
```bash
gem install bundler
gem install unicorn
rbenv rehash
```

## Install mysql server 5.5

```bash
sudo apt-get install mysql-server # it will ask you to choose a root password
```

Add a new user fo the deployments
```bash
mysql -u root -p  # it will ask for the root password
```

```mysql
mysql> create user 'pldbadmin'@'%' identified by '{password}';
mysql> grant all on *.* to 'pldbadmin'@'%' identified by '{password}';
mysql> create user 'pldbadmin'@'localhost' identified by '{password}';
mysql> grant all on *.* to 'pldbadmin'@'localhost' identified by '{password}';
mysql> flush privileges
```

In the `/etc/mysql/my.cfg` change the binding to `0.0.0.0`

## Your app

Adds unicorn as a production gem in the `GemFile`
```ruby
group :production do
  gem 'unicorn'
end
```

Also if your using the assets you need to add the therubyracer gem the the assets group
```ruby
group :assets do
  gem 'therubyracer', :platforms => :ruby
end
```
