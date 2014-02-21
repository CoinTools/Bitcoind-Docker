# Docker Bitcoin Daemon
Comes with ssh, supervisor and bitcoin daemon.  Ready to plug and play with a digital ocean instance or any server running docker 0.8

### Sign into server
	ssh root@serverIP
	git clone https://github.com/CoinTools/Bitcoind-Docker.git

	cd ~/Bitcoind-Docker
	touch bitcoin.conf
	touch supervisord.conf


### Copy over our sensitive data from local
	cat bitcoin.conf | \
	ssh root@serverIP 'cat >> ~/Bitcoind-Docker/bitcoin.conf'

	cat supervisor.conf | \
	ssh root@serverIP 'cat >> ~/Bitcoind-Docker/supervisord.conf'

### Build docker from server
	sudo docker build  \
	--no-cache=false -t Bitcoind .


### Start up our container from server
	sudo docker run -d -name bitcoind \
	-p 8333:8333 -p 2222:22 -i -t Bitcoind

### Add ssh key to docker container from local or server
	cat ~/.ssh/id_rsa.pub | \
	ssh root@serverIP -p 2222 'cat >> ~/.ssh/authorized_keys'

### Change SSH password for docker container
	ssh root@serverIP -p 2222
	cd /var/run/sshd && \
	echo 'root:changeMe' | chpasswd