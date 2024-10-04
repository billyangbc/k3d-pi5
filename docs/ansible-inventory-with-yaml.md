# Writing Ansible Inventory Files in YAML Format

## Main Objectives:
1. Familiarize with the features of Ansible inventory files and understand the basic configuration of Ansible host lists.
2. Understand the format of Ansible inventory YAML files.

## YAML Static Inventory Files
Ansible host lists are essential for using Ansible. Generally, the host list is written in a file named `inventory`, which by default uses the INI format. We usually create a new `inventory` file without a file extension and configure the host list location in `ansible.cfg`.

```ini
[default]
servera.example.com ansible_user=debian
[web_servers]
serverb.example.com
serverc.example.com
[db_servers]
server[d:f].example.com
```

The inventory file can also be in YAML format, which is easier to understand and write, and also easier for software to parse. For the above file, you can use the following YAML format file.

```yaml
default:
  hosts:
    servera.example.com:
    vars:
      ansible_user: debian
web_servers:
  hosts:
    serverb.example.com:
    serverc.example.com:
db_servers:
  hosts:
    server[d:f].example.com:
```

You can use the following command to check the inventory file:

```sh
ansible-inventory -i inventory.yaml --graph
```

YAML inventory uses blocks to organize related configuration items. Each block starts with the name of the inventory group followed by a colon (:). Everything indented under the group name belongs to that group. If indented under the group name, the hostname block starts with the keyword `hosts`. All server names indented under `hosts` hosts belong to this group. These servers themselves form their own group, so they must end with a colon (:). You can also use the keyword `children` in the group block. The list of groups that belong to this group starts with this keyword. These member groups can have their own `hosts` and `children` blocks. YAML syntax has an advantage over INI syntax in that it organizes the server list and nested group list in the same place in the static inventory file.

The `all` group is implicitly all group implicitly exists at the top level and contains the rest of the inventory as its subset. It can also be explicitly listed in the YAML inventory but is not required:

```yaml
all:
  children:
    front_servers: 
      hosts: 
        servera.example.com: 
    web_servers: 
      hosts: 
        serverb.example.com:
```
Equivalent to:
```yaml
lb_servers: 
  hosts: 
    servera.1ab.example.com: 
web_servers: 
  hosts: 
    serverb.1ab.example.com:
```

Some INI-based inventories contain hosts that are not members of any group. In a YAML-based static inventory, you can explicitly assign hosts to the `ungrouped` group:

```ini
notinagroup.example.com
[mailserver]
mai1.example.com
```

in yaml：
```yaml
ungrouped: 
  hosts: 
    notinagroup.example.com: 
mailserver: 
  hosts: 
    mai1.example.com:
```

Test the servers in the inventory file:
```sh
ansible -i inventory.yaml all -m ping
```

## Setting Vars in Ansible Inventory Files
n the INI format, we can set inventory variables. In the YAML-based inventory file, we can also set inventory variables. In many cases, it is best practice to avoid storing variables in static inventory files. Many experienced Ansible developers prefer to use static inventory files to simply store information about the identity of managed hosts and which groups they belong to. Variables and their values are stored in the `host_vars` or `group_vars` files of the inventory. In some cases, you may want to keep variables such as `ansible_port` or `ansible_user` in the ansible_connection in the same file as the inventory itself, keeping this information in one place. If variables are set in too many different places, it becomes harder to remember where to set specific variables. In the YAML block of the group, you can use the vars keyword to set group variables directly in the YAML inventory file. Let’s look at the variable definitions in INI and YAML inventory files:

Group variables in INI format:
```ini
[monitoring]
watcher.example.com

[monitoring:vars]
smtp_relay=smtp.example.com
```

Group variables in YAML format:
```yaml
monitoring:
  hosts:
    watcher.example.com:
  vars:
    smtp_relay: smtp.example.com
```

Host variables in INI format:
```ini
[servers]
servera.example.com
localhost ansible_connection=local
serverb.example.com
```

Host variables in YAML format:
```yaml
servers:
  hosts:
    servera.example.com:
    localhost:
      ansible_connection: local
    serverb.example.com:
```

## Converting from INI Format to YAML Format

You can use the `ansible-inventory` command to convert an INI-based inventory to YAML format. This tool is designed to display the entire configured inventory as seen by Ansible, and the result may differ from the original inventory file. The `ansible-inventory` command parses and tests the format of the inventory file but does not attempt to verify whether the hostnames in the inventory actually exist. Suppose there is an INI format inventory:

```ini
[lb_servers]
servera.example.com

[web_servers]
serverb.example.com
serverc.example.com

[web_servers:vars]
alternate_server=serverd.example.com

[backend_server_pool]
server[b:f].example.com
```

Running the `ansible-inventory` command will output a YAML format inventory file:

```sh
ansible-inventory  --yaml -i inventory --list --output dest_inventory.yaml
```

If the conversion result is not satisfactory, you can manually modify the content.
