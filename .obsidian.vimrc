set clipboard=unnamed

"open link
exmap openlink obcommand editor:follow-link
nmap gd :openlink 
"back forward
exmap back obcommand app:go-back
nmap H :back
exmap forward obcommand app:go-forward
nmap L :forward
nmap ;f :forward

