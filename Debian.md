## Steps

- Setup correct nameserver in /etc/resolve.conf
- Run `./setup.sh base` to install softwares
- Reboot 
- 
```cat > ~/.ssh/config 
Host github.com
   IdentityFile ~/.ssh/id_github
```
- Run `./setup.sh dotfiles` to install dotfiles
- Run `./setup.sh golang` to install golang


### Remove password for root user

```
passwd -d root
```

### Mount virtiofs 

```
share /root/shared virtiofs rw,nofail 0 0
```

### /etc/ssh/sshd_config

```
PermitRootLogin yes
StrictModes no
PubkeyAuthentication yes
PasswordAuthentication no
```

### Install docker: required? or use podman without daemon?

### Install bw binary

```
apt install npm

npm install -g @bitwarden/cli
```

### Install tldr

```
npm install -g tldr
```

### Add locales

```
dpkg-reconfigure locales # select all to add all locales
```

### Install ansible

```
$ UBUNTU_CODENAME=jammy
$ wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg
$ echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list
$ sudo apt update && sudo apt install ansible
```

### Packages

- gnupg
- curl
- make
- expect
- fzf
- bc
- zip
- unzip
- tree
- tcpdump
- jq
- npm
- avahi-daemon

### Static IP

>MacOS already does that with mDNS (Bonjour) - you can access them as HOST.local name (where HOST is the name of your VM in System Settings -> General -> Sharing -> Hostname)
on Linux you need to install sudo apt install avahi-daemon which will advertise HOST.local where HOST is set with sudo hostnamectl

### DNS servers

Change the `/etc/dhcp/dhcp.conf` add `supersede domain-name-servers 1.1.1.1;` this should overwrite the dns nameservers. 

### Make shared/ix-dev as root

Change `/etc/passwd` file directory modify the home directory from `/root` to `/root/shared/test`

