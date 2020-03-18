#!/bin/bash
#
# A Bash script which automates the process of performing individual backups of each database in MariaDB. 
# The script will also report the size statistics on each database backup.
# Specify the interpreter pgrogram for the script.

# Set the variables.
DBUSER=root
FMTOPTIONS='--skip-column-names -E'
COMMAND='SHOW DATABASES'
BACKUPDIR=/dbbackup


# Initiate a for loop and loop through the list of databases to back up each one to the /dbbackup directory.
# Initiate the for loop by passing in a list of database names via command substitution.

# Backup non-system databases
for DBNAME in $(mysql $FMTOPTIONS -u $DBUSER -e "$COMMAND" | grep -v ^* | grep -v information_schema | grep -v performance_schema); do

	# Add the commands to be executed within each loop.
	echo "Backing up \"$DBNAME\""
	mysqldump -u $DBUSER $DBNAME > $BACKUPDIR/$DBNAME.dump

# Close the loop.
done

# Generate a report of each database's name, dump size, and the percentage of the total dump size it accounts for.

# Initiate a for loop to iterate through and total up the size of each database dump in the /dbbackup directory.
# Add up size of all database dumps

for DBDUMP in $BACKUPDIR/*; do

	# Add the commands to be executed within each loop.
	SIZE=$(stat --printf "%s\n" $DBDUMP)
	TOTAL=$(( $TOTAL + $SIZE ))

# Close the loop.
done

# Create a for loop to iterate through and report on each database dump.
# Report name, size, and percentage of total for each database dump

echo
for DBDUMP in $BACKUPDIR/*; do

	# Add the commands to be executed within each loop.
	SIZE=$(stat --printf "%s\n" $DBDUMP)
	echo "$DBDUMP,$SIZE,$(( 100 * $SIZE / $TOTAL ))%"
# Close the loop.
done
