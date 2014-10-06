LGSO
====

### What is LGSO?

With the new arrival of Steam games to the GNU\Linux platform, came the unorganized Windows-ish file-structures that come with the games, and get scattered all around your hard drive without you having a clue what is actually going on.
GNU\Linux community is not familliar with this behaviour.  
Although as users we can't do much about it, I have decided to write a simple Bash script to try and organize the saves to a new folder, a standard I wish to set (maybe if/when this script gets popular, GNU\Linux game devs will follow this "standard" and use **/usr/share/games** as their default game saves location).  
  
So essentialy, LGSO takes all of your game saves and stores them in **/usr/share/games** under their names, and creates a symlink instead of the original game directories, which point to the new directory that was created in **/usr/share/games**.

##### Why /usr/share/games?
As **/usr/share** is a system-wide directory that appears on **every** GNU\Linux distribution, and **/usr** is meant to store user-made files, I have decided to use the said directory. Although, if for some reason you are **not** statisfied with the said location, you can easily edit the script, and replace the location as it is set in the variable **SRC_FOLDER**.

### How to run?
Simply clone that git, and run:
> ./lgso.sh
