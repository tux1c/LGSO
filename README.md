LGSO
====

### What is LGSO?

With the new arrival of Steam games to the GNU/Linux platform, came the unorganized Windows-ish file-structure of the games, which got scattered all around your hard drive without you having a clue what is actually going on.
The GNU/Linux community is not familiar with this behaviour.  
Although as users we can't do much about it, I have decided to write a simple Bash script to try to organize the game saves in a new folder - a standard I wish to set (if or when this script will get popular, GNU/Linux game developers will follow this standard and use **SRC_DIR/games** as their default game save files location).  
  
So essentially, LGSO takes all of your game saves and stores them in **SRC_DIR/games** under their names, and creates a symlink instead of the original game directories, which point to the new directory that was created in **SRC_DIR/games**.

##### What is SRC_DIR?
SRC_DIR is a variable that either follows your $XDG_DATA_HOME, or, in case that you haven't set your $XDG_DATA_HOME variable yet, uses $HOME/.local/share instead.  
SRC_DIR is the directory where your game saves will be saved and carefully organized by the games' names.  

##### Why $HOME/.local/share/games?
As **$HOME/.local/share** is a system-wide directory that appears on **every** GNU/Linux distribution, I have decided to use the said directory. Although, if for some reason you are **not** satisfied with my decision, you can easily edit the script and replace the location as it is set in the **SRC_DIR** variable.

### How to install
####Recommended way:  
Head to <https://github.com/Tux1c/LGSO/releases/latest>, download and unpack the latest release.  
  
####Alternative way (will download the latest version automatically, but there is no guarantee that this version is stable):
> git clone https://github.com/Tux1c/LGSO  

Then (on both cases) simply run:
> chmod +x lgso.sh  
> ./lgso.sh

If you want to be able to execute LGSO from any directory, you'll have to add it to your PATH, or move it to a directory already in PATH.
A good practise is to place the script in ~/.local/bin/ . If, for some reason, the specified directory is not in your PATH, or if after putting LGSO in that directory you're **STILL** unable to execute the script, you'll have to run the following command once:
> echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
And the following command in all of your open terminal sessions:
> source ~/.bashrc
Or else just close and reopen all of your currently open terminal sessions.
If you wish to be able to execute LGSO from any user account, you'll have to place it in /usr/local/bin/ , like so:
> chmod 755 lgso.sh
> sudo chown root:root lgso.sh
> sudo mv lgso.sh /usr/local/bin/lgso

Please refer to the wiki for extra flags you can use with LGSO.

### How to contribute?
If you have ideas regarding improvement of the code, please post a pull request.  
If you have a game save location to suggest, please use the "SAVE" tag and use the following structure:  
Name of the game:  
Platform (Steam, GOG, etc.):  
Full save location: (i.e. $HOME/game)  
For everything else, use the right tag.  
  
### Documentation
You can head to <https://github.com/Tux1c/LGSO/wiki/Documentation> to view LGSO documentation (although poorly written).
  
LGSO currently supports 313 games!
