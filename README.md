
Admittedly there isn't much here yet, but here's what we have:

* Skeleton client implementation for IRC on top of em-irc.
* Skeleton client implementation for XMPP on top of blather.
* Initialisation of clients from configuration. The bot can connect to multiple services at once.
* Initialisation of plugins from configuration. Currently it uses 'require' with the name of the plugin to load it.

Getting started:

* Copy chatcraft.config.example to chatcraft.config and edit it.
* `ruby bin/chatcraft`

Obvious TODOs:

* The config hash is currently string indexed but I would rather use symbols. I would also rather not have to handle missing parameters for every single mandatory parameter I introduce.
* Plugins currently load from a file on the load path with the same name as the plugin you requested, but people might want to namespace their plugins and at the moment, that won't work unless the name has the full path (maybe that's OK... I'm thinking about it.)
* Ability to load and unload plugins at run-time would be nice.
* Command system for the admin console
* Keyboard listener to execute commands at the console (equivalent to doing it via private chat but no need to authenticate)
* A way to recognise users so that we can make useful bot functions
* Groupchat/conference support for XMPP (inconvenient right now as Google Talk don't have a conference server)
* Removal of hard-coded set of supported clients (client plugin API, I guess.)

For use as a client rather than a bot:

* Ability to add to message to allow things like highlighting.
* A proper curses interface

