AlessioBot
==========

[AlessioBot](https://it.wikipedia.org/wiki/Utente:AlessioBot) is a Wikipedia bot running on [WMF Tool Labs](https://tools.wmflabs.org/). As a tireless bot it does some recurring jobs for the italian Wikipedia.

How it works
------------

### Architecture

The main script is `launcher.sh` that read as parameter an instruction set coming from `set` folder. In this way it knows which kind of tasks has to shoot. At every launch it calls to other script. First `lists.sh` that generate through a query call the list of articles to examinate. Then comes the turn of python: according to the set file it executes a pyWikipedia script for the folder `script`.

It use `data` folder as the main file system for lists and `log` folder to store every kind of log that we want.

According to this architecture the bot can run every kind of job that requires a list generation followed by an editing through a python script.

### Execution

For example to run a set called `delightfull_example.set` in folder `set` write:

```bash
$ ./launcher.sh set/delightfull_example.set
```

Tasks running
-------------

### Avvisi

- Find & mark articles and templates without category
- Find & mark dead-end articles
- Find & mark orphan articles

### Immagini orfane

- Find orphan images & mark them by their license

### Future

- Coming soon!