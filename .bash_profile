PATH=$PATH:/Users/sassela/.local/bin:$HOME/.lein/

alias emacs="/usr/local/Cellar/emacs/25.3/Emacs.app/Contents/MacOS/Emacs -nw"
alias ls='ls -GFh'

alias prepl='pushd $(mktemp -d) && pulp init && pulp repl && popd'
alias cd2='cd ../..'
alias cd3='cd ../../..'
alias cd4='cd ../../../..'
alias cd5='cd ../../../../..'
alias light-table='open -a /Applications/LightTable/LightTable.app'
