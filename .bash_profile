PATH=$PATH:$HOME/.lein/
PATH=$PATH:/Users/abby/.local/bin

alias emacs="/usr/local/Cellar/emacs/25.3/Emacs.app/Contents/MacOS/Emacs -nw"
alias ls='ls -GFh'

alias prepl='pushd $(mktemp -d) && pulp init && pulp repl && popd'
alias cd2='cd ../..'
alias cd3='cd ../../..'
alias cd4='cd ../../../..'
alias cd5='cd ../../../../..'
