
# Source required definitions
BASHRC_DIR=~/bashrc-files
source $CS161_BASHRC_DIR/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_DESCRIBE_STYLE="branch"

# PROMPT COLORS!!!
# Reset
Color_Off='\[\e[0m\]'       # Text Reset

# Regular Colors
Black='\[\e[0;30m\]'        # Black
Red='\[\e[0;31m\]'          # Red
Green='\[\e[0;32m\]'        # Green
Yellow='\[\e[0;33m\]'       # Yellow
Blue='\[\e[0;34m\]'         # Blue
Purple='\[\e[0;35m\]'       # Purple
Cyan='\[\e[0;36m\]'         # Cyan
White='\[\e[0;37m\]'        # White

# Background
On_Black='\[\e[40m\]'       # Black
On_Red='\[\e[41m\]'         # Red
On_Green='\[\e[42m\]'       # Green
On_Yellow='\[\e[43m\]'      # Yellow
On_Blue='\[\e[44m\]'        # Blue
On_Purple='\[\e[45m\]'      # Purple
On_Cyan='\[\e[46m\]'        # Cyan
On_White='\[\e[47m\]'       # White

# High Intensty
IBlack='\[\e[0;90m\]'       # Black
IRed='\[\e[0;91m\]'         # Red
IGreen='\[\e[0;92m\]'       # Green
IYellow='\[\e[0;93m\]'      # Yellow
IBlue='\[\e[0;94m\]'        # Blue
IPurple='\[\e[0;95m\]'      # Purple
ICyan='\[\e[0;96m\]'        # Cyan
IWhite='\[\e[0;97m\]'       # White

# High Intensty backgrounds
On_IBlack='\[\e[0;100m\]'   # Black
On_IRed='\[\e[0;101m\]'     # Red
On_IGreen='\[\e[0;102m\]'   # Green
On_IYellow='\[\e[0;103m\]'  # Yellow
On_IBlue='\[\e[0;104m\]'    # Blue
On_IPurple='\[\e[10;95m\]'  # Purple
On_ICyan='\[\e[0;106m\]'    # Cyan
On_IWhite='\[\e[0;107m\]'   # White

# Keep working directory description to a reasonable length.
abbrev_pwd() {
  # Recreate '\w' home dir replacement
  local dir=`pwd`
  local end='/'
  local in_home=0
  if [ $dir = "/" ]; then
    end=''
  fi
  if [[ $dir =~ ^$HOME($|\/) ]]; then
    dir="~${dir#$HOME}"
    in_home=1
  fi

  local slashes=${dir//[^\/]}
  local depth=$((1 + ${#slashes}))

  # Choose max length based on terminal width
  local ncols=`tput cols`
  local max_dir_chars=$(($ncols / 2))

  # Abbreviate until short enough
  local beginning=
  local middle=
  local end=
  local i=2
  while [[ $i -lt $depth && ${#dir} -gt $max_dir_chars ]]; do
    beginning=`echo $dir | cut -d / -f 1-$(($i - 1))`
    middle=`echo $dir | cut -d / -f $i`
    end=`echo $dir | cut -d / -f $(($i + 1))-$depth`
    dir=$beginning'/'${middle:0:2}'/'$end
    i=$(($i+1))
  done
  
  echo $dir
}

# Main function for the prompt.
prompt() {
  local sep_color=$White

  local status=`echo $?`
  local status_code=''
  if [ $status -ne 0 ]; then
    status_code=$Red'#'$IYellow$status
  fi

  local working_dir=$sep_color'['$IBlue`abbrev_pwd`

  # __git_ps1 is defined in git-prompt.sh
  local git_info=`__git_ps1 $sep_color'|'$IBlack'%s'`

  local prompt_char=$ICyan'\$'
  if [ `id -u` = 0 ]; then
    prompt_char=$Red'#'
  fi
  local prompt_end=$sep_color']'$prompt_char' '$Color_Off

  PS1=$status_code$working_dir$git_info$prompt_end
}

PROMPT_COMMAND=prompt
# Set cursor color
echo -ne '\e]12;DarkOrange\a'

