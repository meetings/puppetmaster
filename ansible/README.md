
### Ansible

Using ansible, bootstrapping a server can be done with minimal effort.

#### Step 1

Add *fqdn* to `inventory`. For example:

    [bootstrap]
    savu.dicole.com

#### Step 2

**Prerequisites:**

First, you need Ansible 2 installed on your computer:

    pip install ansible

Then you have your server booted to rescue mode, and you have following info handy:

 * Rescue mode password
 * Public IP of the machine
 * Intended Internal IP (like 172.26.0.1)

Also if re-bootstrapping old dom0 (here "savu"), run the following commands:

    export OLDDOM=savu
    ssh yrtti sudo rm -f /etc/tinc/dicolerootnet/hosts/$OLDDOM
    ssh kivi sudo rm -f /etc/tinc/dicolerootnet/hosts/$OLDDOM
    ssh master sudo puppet cert clean $OLDDOM.dicole.com

**Action:**

    $ ansible-playbook bootstrap.yml -k -i inventory [-CD]

Options `-C` and `-D` are useful, if checkmode (i.e. dry-run) is wanted.
