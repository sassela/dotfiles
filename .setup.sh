# zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# homebrew
mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
# dev tools
brew install ghc
brew install purescript

# stack, from https://github.com/commercialhaskell/stack/blob/master/doc/install_and_upgrade.md
curl -sSL https://get.haskellstack.org/ | sh

# stack alt,from http://dev.stephendiehl.com/hask/
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 575159689BEFB442                             # get fp complete key
echo 'deb http://download.fpcomplete.com/ubuntu trusty main'|sudo tee /etc/apt/sources.list.d/fpco.list    # add appropriate source repo
sudo apt-get update && sudo apt-get install stack -y

# dev env
mkdir play && cd play
