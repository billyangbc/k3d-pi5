# SSH to remote server with passwordless authentication

If you don't want to use password to access remote server, you can setup with following steps:

## step 1: Generating SSH keys

On the local host, create SSH keys by using the command
```sh
ssh-keygen
```

The command generates three files:
* authorized_keys: A file storing the public keys form other hosts (manually create it if not existing) 
* id_ed25519.pub: public key
* id_ed25519: private key

## step 2: Copy public key to remote host
We will copy the public key `id_ed25519.pub` to the remote host's `authorized_keys` file using the `ssh-copy-id` command.

On local host:
```sh
ssh-copy-id -i id_ed25519.pub user@hostname.example.com

#cd ~/.ssh
#cat id_ed25519.pub
#cat id_ed25519.pub | pbcopy
```

On the remote host:
```sh
vim ~/.ssh/authorized_keys
# paste copied content
```

## step 3: test with ssh

For testing:
```sh
ssh user@hostname.example.com
# note: no password is needed
```

## (Optional): remove public key from remote host
To remove the public key from remote server, use:
```sh
idssh=$(awk '{print $2}' ~/.ssh/id_ed25519.pub)
ssh user@hostname.example.com "sed -i '\#$idssh#d' .ssh/authorized_keys"
```