# Conda environments
alias mkenv="conda create python=3 ipython pip -n "
alias mkenv2="conda create python=2 ipython pip -n "
alias lsenv="conda info -e"
alias wo="pyenv activate"
alias de="deactivate"
alias scratchenv='pyenv uninstall scratchenv ; pyenv virtualenv 2.7.12 scratchenv ; pyenv activate scratchenv'
alias scratchenv3='pyenv uninstall scratchenv3 ; pyenv virtualenv 3.6.3 scratchenv3 ; pyenv activate scratchenv3'
