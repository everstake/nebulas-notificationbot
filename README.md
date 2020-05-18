# NEBULAS Notification Bot

This script monitors the status of the Nebulas node and notifies the Telegram Bot if the node stops syncing or goes down.

### Prerequisites

* curl
* jq
```
sudo apt-get install curl jq
```
### Installing

```sh
git clone https://github.com/everstake/nebulas-notificationbot.git
cd nebulas-notificationbot
chmod +x notifier.sh
```
### Configuration

Edit configuration file `config.ini`.

### Node Configuration

The Mainnet configuration file are in folder `mainnet/conf/config.conf`.
```
rpc {
    rpc_listen: ["0.0.0.0:8684"]
    http_listen: ["0.0.0.0:8685"]
    http_module: ["api","admin"]
}
```
## Running
Run a command
```sh
./notifier.sh
```
