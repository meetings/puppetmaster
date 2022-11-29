
puppetmaster
============

Central configuration for Meetin.gs machinery.

layout
------

 - **cgi**:

   CGI scripts for Webhooks. See *doc/puppetmaster-howto.md* for details.

 - **doc**:

   General documentation and notes. In theory, with this information, one
   should be able to bootstrap the whole Meetin.gs infrastructure. In reality,
   not all documents are perfectly up to date all the time.

 - **doc/errata.md**:

   Miscellaneous unsorted list of issues and problems, which have graced us
   with their presence. Usually with some solutions or workarounds.

   This document will probably be the most useful resource to anyone, who
   will update Meetin.gs to post-Precise world.

 - **files**:

   Misc files, which do not fit into Puppet modules or may not be in active
   use, but might be useful sometime somewhere.

 - **files/meetings_reroute_failover_ips.sh**:

   A script to change the routing of the failover IP addresses.

 - **files/packages.asc**:

   Public key for packages in Meetin.gs repository.

 - **files/selfsigned.pem**:

   Insecure self-signed ssl certificate.

 - **manifests/site.pp**:

   Node definition list i.e. list of all the machines and their configuration
   profiles.

 - **modules**:

   Puppet modules a.k.a. configuration definitions. This is *the* shit.

 - **autosign.conf**:

   List of hosts which bypass manual certificate signing phase before
   configuration is granted.

   Wildcard '\*' means that all requests are autosigned.

 - **puppet.conf**:

   Puppets main configuration.
