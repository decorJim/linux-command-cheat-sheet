## CHEATSHEET FOR COMMAND LINES ##

- ls -l filename # list out the file name, the option -l give details file permission, owner, owning user group, size in bytes, date of last modification, file name
- ls -ltr filename1 filename2 # -l give detail on permission, owner, size, timestamp, name -t sort by modified date -r reverse the order
- ls file* # list out anything that starts with file and ends something
- ls -d # list out all directories
- cd ~ # go to user home folder equivalent to cd home/ec2-user

## FILE PERMISSION ##
- chmod 400 filename # 4 -> owner can read 0 -> groups cannot do anything 0 -> others cannot do anything
- touch filename # creates the file or update the modification date
- rm filename # deletes the file
- mkdir foldername # creates the folder
- rmdir foldername # deletes the folder
- chmod u=rw,g=r,o=r filename # shortcut to give permission to owner, group and others

- sudo chown -R owner myfolder # chown changes the owner of myfolder to owner -R recursive all inside
- sudo chgrp -R newGRoup myfolder # chgrp change the folder's group -R recursive all inside


## UNAME PRINTS INFO ABOUT YOUR SYSTEM ##
- uname -m # shows the CPU architecture
- uname -a # shows 

## CHECK DOCUMENTATION FOR COMMAND LINE ##
- man command # show documentation of the command

## SHORTCUT ##
- Ctrl + q # opens a new terminal and discard the previous
- history # list out the 10 most recent command lines executed

## STATUS OF COMMAND LINE ##
- echo $?

## ENVIRONMENT VARIABLE ##
- echo $PATH # print out the value of the variable PATH

## FILTER INPUT ##
- cat file | grep all # take file as input to grep and finds all occurence of all

## CTRL + F ##
- /word # finds all occurence of word in the command line documentation
- Shift + n # go to previous occurrence
- n # go to next occurrence 

## DOWNLOAD FILE FROM SERVER ##
- sftp -i "key.pem" ec2-user@ec2-15-223-121-26.ca-central-1.compute.amazonaws.com # sign in 
- get filename # write the content of the remote server to a local copy
- man sftp # manual

- get -r folder # recursively download all the content within to local PC

## EMPTY A FILE ##
- shread filename # empty the content but put random bytes inside
- shread -z filename # empty the content with no random bytes

## EDIT A FILE ##
- vi filename # open file
- press i # edit mode 
- ESC # quit write mode
- :wq # save content and quit the file
- :q! # quit file without saving


## DELETE FILE AND FOLDER
- rm file # delete file
- rm -r # delete folder recursively
- rm -rf # force delete no confirmation needed

## TOP 10 or BOTTOM
- head file # top 10
- tail file # bottom 10
- tail -2 file # bottom 2
- head -5 file | tail -1 # takes top 5 save it then take the 5th

## FIND FILE THROUGH NAME ##
- find -name "*.txt" # list out all the routes to files ending with .txt
- find -iname "ans" # list out all routes to files not case sensitive


## REPLACE ALL OCCURENCES IN FILE BY SOMEHING ##
- sed 's/world/sed/g' file # all word world will be replaced by sed s: substitude g: global so the whole line
- sed 's2/world/sed' fil # replace all occurence only at line 2

- sed -i 's/ /,/g' data.txt # overwrite in place the file

## PROCESS ##
- ps aux --sort=-%mem | head -6 | awk '{print($2,$4,$11)}' # mem for memory all variable should be lower case, -% for descending order, head -6 includes header
- ps -eo pid,cmd,%mem --sort=%mem
- watch -n 5 'ps -eo user,pid,%mem,%cpu,nice --sort=-%cpu' # watch process in real time every 5 seconds


## Systemd ##
- systemctl list-units # shows all the services managed by systemd
- systemctl is-enabled myservice # shows if the service is enabled (will start when server boots)
- sudo systemctl enable myservice # enables the service

- sudo systemctl start myservice # starts the service
- sudo systemctl restart myservice # restart a service
- sudo systemctl stop myservice # stops a service

- systemctl status myservice # shows the status of the service

## JOURNALCTL ##
- journalctl -u myservice # -u unit shows the logs of a specific service managed by systemd


## NETWORK INTERFACES ##
- ip address # show all the network interfaces
- sudo ss -tlpn # -p shows all process -l listening to -t tcp connection -n ip and port 

## LINKS ##
- ln -s file soft-file # creates a soft link pointing to file
- ln file hard-file # creates a hard link that points to the content of file so even if file deleted it persist



















