#Set up the prompt
SC="\e[0;33m" #start color code. Change code to change the color of the PWD.
EC="\e[0m"  #end color code
GRN='\e[0;32m'
PS1="\n$SC[\w]$EC$GRN[\h]$EC\n\u\$ "
