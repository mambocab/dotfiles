# Conda environments
alias mkenv="conda create python=3 ipython pip -n "
alias mkenv2="conda create python=2 ipython pip -n "
alias lsenv="conda info -e"
alias wo="source activate"
alias de="source deactivate"
alias scratchenv='pyenv uninstall scratchenv ; pyenv virtualenv scratchenv ; pyenv activate scratchenv'
