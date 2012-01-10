#!/bin/bash
#
# modifikovano: 12.05.2011 16:53:33
#
# port        app
#------------------------
# 21      =   FTP
# 22      =   SSH (može da se menja)
# 25      =   SMTP
# 53      =   DNS
# 80      =   HTTP
# 110     =   POP3
# 143     =   IMAP
# 443     =   HTTPS
# 465     =   GMail SMTP (SSL)
# 587     =   GMail SMTP (TLS)
# 993     =   IMAP encrypted
# 6667/8  =   IRC
# 7000    =   IRC (SSL)
# 9418    =   GIT (default)
#
firewall="/sbin/iptables"

if [ ! -e "$firewall" ]; then echo "ERROR: $firewall is not available. Do you have iptables or netfilter installed?" && exit 2 ; fi



iptables_rules () {
#notifier
echo 'Configuring iptables ports and services...'

# flaš starih pravila ("flush the toilet" analogija :>)
echo ' * Flushing old rules...'
flush_rules
# definisanje polisa koje ćemo kasnije da koristimo
$firewall -P INPUT ACCEPT
$firewall -P OUTPUT ACCEPT
# rutiranje ukoliko vaša linuks mašina služi kao ruter?
$firewall -P FORWARD DROP

# dozvole za ostvarivanje veze koje iniciraju paketi sa mog računara
# dolazece
$firewall -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# odlazece
$firewall -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# dozvole za sve što se odvija na "localhost"-u (apache, ftp etc.)
$firewall -A INPUT -i lo -j ACCEPT
$firewall -A OUTPUT -o lo -j ACCEPT

#regulisanje "loših" TCP paketa
#$firewall -A OUTPUT -p tcp -j bad_tcp_packets


############################### Korisnikova pravila za odredjene portove
echo ' * Applying specific rules for separated services...'

#dns upiti i sl.
#echo '   - dns'
#$firewall -A OUTPUT -m state --state NEW -p udp --dport 53 -j ACCEPT
#$firewall -A OUTPUT -m state --state NEW -p tcp --dport 53 -j ACCEPT

#http (mislim dooh)
#echo '   - http'
#$firewall -A OUTPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT
#https zahtevi
#echo '   - https'
#$firewall -A OUTPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT

#imap (encrypted)
#echo '   - imap (encrypted)'
#$firewall -A OUTPUT -m state --state NEW -p tcp --dport 993 -j ACCEPT
#gmail smtp (TLS)
#echo '   - GMail SMTP (tls)'
#$firewall -A OUTPUT -m state --state NEW -p tcp --dport 587 -j ACCEPT

#IRC (freenode + oftc ssl)
#echo '   - IRC (ssl)'
#$firewall -A OUTPUT -m state --state NEW -p tcp --dport 6697 -j ACCEPT
#$firewall -A OUTPUT -m state --state NEW -p tcp --dport 7000 -j ACCEPT

#GIT
#echo '   - git'
#$firewall -A OUTPUT -m state --state NEW -p tcp --dport 9418 -j ACCEPT

## Nesigurne i debilne stvari
#ftp (koristi se i za pristup FTP serverima iz veb pregledaca)
#echo '   - ftp'
#$firewall -A OUTPUT -m state --state NEW -p tcp --dport 21 -j ACCEPT
#echo '     - ftp kernel module' #ftp modul u kernelu
#modprobe ip_conntrack_ftp

#torrent
#echo '   - torrent (sharing)'
#$firewall -A OUTPUT -m state --state NEW -p tcp --dport 51001 -j ACCEPT
########################################################################


# blokiranje ICMP pinga
echo ' * Blocking ICMP ping'
# !Note: Kažu da ovo nije dobra stvar pa nije loše koristiti neko drugo pravilo
$firewall -A OUTPUT -p icmp --icmp-type echo-request -j DROP
# blokiranje svega ostalog
echo ' * Blocking everything else...'
$firewall -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
$firewall -A INPUT -i eth+ -p udp -j DROP
$firewall -A INPUT -i eth+ -p tcp -m tcp --syn -j DROP
#imcp blok
$firewall -A INPUT -p icmp -j DROP
$firewall -A OUTPUT -p icmp -j DROP
$firewall -A FORWARD -p icmp -j DROP
# blokiranje **svega** ostalog
$firewall -A INPUT -j DROP
#$firewall -A OUTPUT -j DROP
$firewall -A FORWARD -j DROP

}


flush_rules () {
echo ' * Flushing all iptables rules...'
$firewall -F
$firewall -X
$firewall -Z
$firewall -t nat -F
$firewall -t mangle -F
$firewall -t nat -X
$firewall -t mangle -X
}


help () {
echo "$0 - manage iptables rules
usage: $0 action

Actions:
  start   -  use defined iptables rules
  stop    -  flush iptables rules
  *       -  displays this help"
}


case $@ in
 start ) iptables_rules ;;
 stop ) flush_rules ;;
 * ) help ;;
esac

exit 0
