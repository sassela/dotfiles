# git
alias gcom='git checkout master'
alias gcob='git checkout -b'
alias gcm='git commit -m'
alias 'ga.a'='git add --patch'
alias gcob='git checkout -b'
alias glom='git pull origin master'

# stack
alias sbff='stack install --file-watch --fast'
alias sbft='stack install --file-watch --fast --test'
alias sbftw='stack install --file-watch --fast --test --ghc-options="-Wall -Wwarn"'

# hlint
apply-refact () {
    hlint "$1" --refactor --refactor-options="--inplace"
}

# python
alias python='python3'
alias pip='pip3'

# etc
alias szshrc='source ~/.zshrc'
alias ls='ls -GFh'
alias cd2='cd ../..'
alias cd3='cd ../../..'
