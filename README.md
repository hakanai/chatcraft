
Admittedly there isn't much here yet, but here's what we have:

* Skeleton client implementation for IRC on top of em-irc
* Skeleton client implementation for XMPP on top of blather
* Initialisation of clients from configuration

Getting started:

* Copy zing.config.example to zing.config and edit it.
* `ruby bin/zing`

Obvious TODOs:

* Command system
* Keyboard listener to execute commands at the console (equivalent to doing it via private chat but no need to authenticate)
* A way to recognise users so that we can make useful bot functions
* Groupchat/conference support for XMPP (inconvenient right now as Google Talk don't have a conference server)
* Removal of hard-coded set of supported clients

For use as a client rather than a bot:

* Abstraction on top of the message to allow things like highlighting.
* A proper curses interface

