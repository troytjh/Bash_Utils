# Task Management
```
# give running processes and their related file paths 
lsof
```

# git commands
```
# allows for multiple branches to be checkout at the same time
#    File_Path: path to store the branch
#    Branch_Name: name of the branch to add to workspace
git worktree add <File_Path> <Branch_Name>
```

# nextcloud maintenance mode
```
sudo -u http php occ maintenance:mode --on

# app maintenance commands
sudo -u http php occ app:update <app_name>
```

# package management
```
# list installed applications
#    -e: filter output to explicitly installed packages
#    -t: filter output to packages not required by other installed packages
pacman -Qet
```


# file management
```
# recursively sort folders by size
sudo du -chad 1 <dir> | sort -h

nnn -dHS

ncdu
```
