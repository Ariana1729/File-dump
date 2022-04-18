set PATH "$HOME/.local/bin:$HOME/.gem/ruby/3.0.0/bin:$PATH"
status --is-interactive; and source (rbenv init -|psub)

function __fish_command_not_found_handler --on-event fish_command_not_found
    echo "fish: Unknown command '$argv'"
end

alias ll='ls -la'
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias pacs='sudo pacman -S'
alias pipi='pip2 install --user'
alias py=python2.7
alias python=python2.7
alias auri='makepkg -si'
alias yafu='~/Desktop/Apps/yafu/yafu/yafu'
alias ffpsil='ffplay -hide_banner -loglevel panic'
alias aslrd='echo 0 | sudo tee /proc/sys/kernel/randomize_va_space'
alias aslre='echo 2 | sudo tee /proc/sys/kernel/randomize_va_space'
alias ida64='wine ~/.wine/drive_c/Program\ Files/IDA\ 7.0/ida64.exe'
alias ida32='wine ~/.wine/drive_c/Program\ Files/IDA\ 7.0/ida.exe'
alias gitcom='git add .;git commit;git push'
alias hvim='~/Desktop/Apps/hyx-0.1.5/hyx'
alias brightness='sudo /home/ariana/Desktop/Computer/Scripts/brightness.sh $argv'
alias icat='kitty +kitten icat'
function fact;yafu "factor($argv)";end
function hex;python -c 'print hex('$argv')';end
function chex;python2 -c 'print "'$argv'".encode("hex") if len("'$argv'")==1 else "".join(i.encode("hex") for i in "'$argv'")';end
function ord;python2 -c 'print ord("'$argv'") if len("'$argv'")==1 else [ord(i) for i in "'$argv'"]';end
function chr;python2 -c 'print ("0"*(len("{0:x}".format('$argv'))%2)+"{0:x}".format('$argv')).decode("hex")';end
