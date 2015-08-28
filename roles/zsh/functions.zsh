# credit: http://nparikh.org/notes/zshrc.txt
# Usage: extract <file>
# Description: extracts archived files / mounts disk images
# Note: .dmg/hdiutil is Mac OS X-specific.
extract () {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)  tar -jxvf $1                        ;;
            *.tar.gz)   tar -zxvf $1                        ;;
            *.bz2)      bunzip2 $1                          ;;
            *.dmg)      hdiutil mount $1                    ;;
            *.gz)       gunzip $1                           ;;
            *.tar)      tar -xvf $1                         ;;
            *.tbz2)     tar -jxvf $1                        ;;
            *.tgz)      tar -zxvf $1                        ;;
            *.zip)      unzip $1                            ;;
            *.ZIP)      unzip $1                            ;;
            *.pax)      cat $1 | pax -r                     ;;
            *.pax.Z)    uncompress $1 --stdout | pax -r     ;;
            *.Z)        uncompress $1                       ;;
            *)          echo "'$1' cannot be extracted/mounted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# credit: http://ku1ik.com/2012/05/04/scratch-dir.html
# Creates a new scratch directory and cds to it
function scratch {
  cur_dir="$HOME/scratch"
  new_dir="$HOME/tmp/scratch-`date +'%s'`"
  mkdir -p $new_dir
  ln -nfs $new_dir $cur_dir
  cd $cur_dir
  echo "New scratch dir ready for grinding ;>"
}

function exp {
    sensible-browser "http://explainshell.com/explain?cmd=`echo $* | sed 's/\s/\+/g'`"
}

function mkcd { mkdir -p $1 && cd $1 }

function t {
    TASKFILE='./t.sh'
    if [ -e $TASKFILE ]; then
        $TASKFILE $*
    else
        echo "No $TASKFILE found"
    fi
}

# via garybernhardt
# By default, ^S freezes terminal output and ^Q resumes it. Disable that so
# that those keys can be used for other things.
unsetopt flowcontrol
# Run Selecta in the current working directory, appending the selected path, if
# any, to the current command, followed by a space.
function insert-selecta-path-in-command-line() {
    local selected_path
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    selected_path=$(find * -type f ! -name '*.pyc' | selecta) || return
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_path "'
    # Redraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
# Create the zle widget
zle -N insert-selecta-path-in-command-line
# Bind the key to the newly created widget
bindkey "^S" "insert-selecta-path-in-command-line"

function wrk() {
  wo cstar_te
  cd ~/cstar_src
  while getopts s opt ; do
    case $opt in
      s) ssh-add ;;
    esac
  done
  shift $OPTIND-1
  if [ -n "$1" ] ; then
    cd $1
  fi
}
alias wrks='wrk -s'

function wcd() {
  cd $(find . -maxdepth 3 -type d | selecta)
}

function touchpad() {
  touchpad_query="`synclient | grep TouchpadOff | sed 's/[^0-9]*//g'`"
  case "$touchpad_query" in
    0) set_touchpadoff=1 ;;
    1) set_touchpadoff=0 ;;
    *) echo got invalid value "$touchpad_query" from synclient ; exit 1 ;;
  esac
  synclient TouchpadOff="$set_touchpadoff"
}
