
This repository contains code used by FORJ (http://forj.io) to implement Diamond blueprint.

The current version implements the following development services:

|| |
|------------------------------------------|--------------------------------------------------------------|
| Source control management                | [git](http://git-scm.com/)                                   |
| Code Review.                             | [Gitlab](https://about.gitlab.com/)                          |
| build system & Continuous integration.   | [jenkins](http://jenkins-ci.org/)                            |
| ChatOps                                  | [openfire](http://www.igniterealtime.org/projects/openfire/) |
| Contribution statistics                  | [kibana](http://graphite.openstack.org)                      |


Diamond Blueprint definition:
--------------------------------------

The description of this blueprint is detailed in 'diamond-master.yaml' located in the <repo-root>/forj/ directory.

It describes the following:

- Collection of tools
   * GitLab        : https://about.gitlab.com/
   * jenkins       : http://ci.openstack.org/jenkins.html
   * Openfire      : http://www.igniterealtime.org/projects/openfire/
   * Hubot         : https://hubot.github.com/
   * redis         : http://redis.io/
   * Elasticsearch : http://www.elasticsearch.org/

- 'A la openstack' development flow
  
  This blueprint implements a complete development process, based on continuous integration, and code review.
  This process also manages projects in each tool.

- Blueprint Deployement automation

  Your Diamond infrastructure is going to be maintained by puppet modules and manifests.
  Most of this code is stored under <repo-root>/puppet directory
  
  Each tool is defined as a collections of puppet modules and manifest. The blueprint definition file (diamond-master.yaml) associates those modules to each tool.

- Blueprint data and management
  
  This blueprint introduces the notion of project.

- Documentation

  It contains a simple tutorial to learn on this blueprint by example, and a lot of references about tools installed.

Diamond deployement:
---------------------

When you want to deploy this blueprint, there is 2 choices:
* Create a new maestro and ask it to create your blueprint.
* Use an existing Maestro and configure it to create your blueprint. This functionnality is currently not ready. Documentation given is for information only, and may be updated as needed.

Create a new Maestro + Diamond:
--------------------------------

* Get forj cli tool - 
  Install forj cli thanks to instructions described in https://github.com/forj-oss/cli
* Setup hpcloud
  forj setup
* booting Maestro + diamond with
  forj boot diamond on hpcloud as <InstanceName>

Configure Maestro to instantiate Diamond:
------------------------------------------
**!!! Warning !!!** This section is still under development.


What 'diamond-layout.yaml' example will deploy:
=================================================

This example layout file was designed to deploy 1 box.
The current version of this repository configures your cloud with the following servers/services:

servers
-------

* util (size small)
   * elasticsearch : http://www.elasticsearch.org/
   * logstash      : http://logstash.net/
   * kibana        : http://www.elasticsearch.org/overview/kibana/


Repository hierarchy:
=====================

 - forj/           : blueprint description. Contains the blueprint definition(master) and a deployement example file (layout)
 - puppet/modules  : puppet modules
 - puppet/manifest : puppet manifest

Contributing to Forj
=====================
We welcome all types of contributions.  Checkout our website (http://docs.forj.io/en/latest/dev/contribute.html)
to start hacking on Forj.  Also join us in our community (https://www.forj.io/community/) to help grow and foster Forj for
your development today!

License
=====================
Diamond is licensed under the Apache License, Version 2.0.  See LICENSE for full license text.

