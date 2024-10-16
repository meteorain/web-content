set clipboard=unnamed


exmap linter obcommand obsidian-linter:lint-file
nmap ff :linter

"open link
exmap openlink obcommand editor:follow-link
nmap gf :openlink 
exmap openlinknew obcommand editor:open-link-in-new-leaf
nmap gn :openlinknew
"back forward
exmap back obcommand app:go-back
nmap H :back
exmap forward obcommand app:go-forward
nmap L :forward
nmap ;f :forward

