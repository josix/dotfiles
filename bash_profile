# Setting PATH for Python 3.5
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
export PATH

# Setting the PS1 
export PS1='\[\033[44;37m\]\d \t\[\033[0m\] \[\033[0;31m\]\u\[\033[0;33m\] @ \[\033[0;31m\]\H \[\033[0;36m\]\w\[\033[0;33m\] \$\[\033[0m\] '

# Setting the alias  
alias ls='ls -G'
alias la='ls -lah'
alias wilson='cd /Volumes/Data/wilson'
alias grep='grep --color=auto'
alias ghost='ssh f103207425@ghost.cs.nccu.edu.tw'
alias arches='ssh -p 3322 sg35@140.119.55.171 '
alias fghost='sftp f103207425@ghost.cs.nccu.edu.tw'
alias WILSON='cd /Volumes/WILSON/'
