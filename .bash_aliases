#Set up the prompt
SC="\e[0;33m" #start color code. Change code to change the color of the PWD.
EC="\e[0m"  #end color code
GRN='\e[0;32m'
PS1="\n$SC[\w]$EC$GRN[\h]$EC\n\u\$ "

####################################################################
# Make some custom functions
####################################################################

#This impliments the 'irm' which moves  files to the trashcan,
#rather than deleting them.
#Usage: irm -e to empty trash.
# irm [file1 file2 ... filen] to move file1-filen to the trash.
# Wildcards should work. eg: irm * to trash all the files in the directory, etc.

TRASH=".Trash"  #The trashcan directory within your home directory

irm()
{

  #Check to make sure there are arguments to operate on.
  if [ $# = 0 ]; then
    echo "No arguments provided."
    echo "Type irm -e to empty the trash."
    echo "Type irm [file1 file2 ...] to delete file1 file2 etc."
    return
  fi

  #Check to make sure the trashcan exists.
        if [ ! -e ~/$TRASH ];then
                echo "$HOME/$TRASH does not exist. Would you like to create it? Y/N"
                read INPUT

                if [[ $INPUT = "Y" || $INPUT = "y" ]]; then
                        mkdir ~/$TRASH
                        echo "Trashcan created."
                else
                        echo "Ok, no trashcan was created and no files were deleted."
                        return
                fi
        fi

  #Check for the -e flag, which empties the trash.
  if [ "$1" = "-e" ]; then
    echo "Are you sure you wish to empty the trash? Y/N"
    read VERIFY

    if [[ $VERIFY = "Y" || $VERIFY = "y" ]]; then
      rm -rf ~/$TRASH/*
      echo "Trash emptied."
    else
      echo "Ok, nothing has been deleted."
    fi

    return
  fi

  #Finally, move the specified files to the trash.
  for i in $*; do
    if [ -e "$i" ]; then #Make sure each file exists before moving.
      if [ -e ~/$TRASH/$i ]; then #Make sure we're not overwriting a trashed file.
        echo "A file named $i already exists in the trashcan. Overwrite? Y/N"
                                read INPUT
        if [[ $INPUT = "N" || $INPUT = "n" ]]; then
          echo "Ok, $i was not deleted. Continuing..."
          continue
        elif [[ $INPUT = "Y" || $INPUT = "y" ]]; then
          rm -rf ~/$TRASH/$i
        fi
      fi
      mv "$i" ~/$TRASH/
    else
      echo "File $i does not exist."
    fi
  done
}
