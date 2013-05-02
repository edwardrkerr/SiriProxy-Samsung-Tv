SiriProxy Samsung Tv Plugin
===========================

About
-----
This plugin is developed to allow you to send commands to your samsung tv through siri, for a little bit of Jarvis home automation awesomeness!

Only a couple of functions at the moment but in time I will expand it to cover all of the keys.

At the moment, this intitiates a perl script via a system call (tv.pl). Open to suggestions on alternatives.

State Of Project
----------------
As with SiriProxy itself, this plugin is still in pre-alpha stage, although each function seems to be working correctly at the moment. Any questions or problems, get me on Twitter: @edwardrkerr

Set up instructions
-------------------
1. Create a plugins folder if you don't already have one:
	`mkdir ~/.siriproxy/plugins`

2. Pull the plugin from the repo:
	`git clone git@bitbucket.org:edwardrkerr/siriproxy-samsung-tv.git`

3. Add the example configuration to the master config.yml file:
	`cat siriproxy-samsung-tv/config-info.yml >> ~/.siriproxy/config.yml`

4. Edit the config.yml as required.     **Note: Make sure to line up the column spacing.**
	`vim ~/.siriproxy/config.yml`
