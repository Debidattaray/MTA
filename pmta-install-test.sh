> DNS_UPDATE.txt
yum remove -y PowerMTA*
rm -rf /etc/pmta

yum -y install httpd
yum -y install screen wget
# screen -xR install
cd /var/www/html
wget http://51.81.210.15/skr_pmta_setup.sh.tar
#wget https://abs.chinabistroindy.com/skr_pmta_setup.sh.tar

#abs.chinabistroindy.com
wget http://51.81.210.15/Sambit_LD.tar
#wget http://51.81.210.15/Sambit_LD.tar
tar -xvf skr_pmta_setup.sh.tar
tar -xvf Sambit_LD.tar
sh skr_setup.sh
systemctl restart httpd.service


service httpd restart
service mariadb restart
chmod 0777 /etc
chmod 0777 /etc/named.conf
chmod 0777 /var/named/*.fw.zone

#for multiple ip check
# ip a
# ip addr add 185.163.45.153/32 dev eth0
echo "#########################################  STEP- 0  #######################################"

#Bash RC

printf "# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias deleteq='sh /etc/pmta/files/reports/deleteq.sh'
alias delvips='sh /etc/pmta/files/reports/delvips.sh'
alias delvipscnt='sh /etc/pmta/files/reports/delvipscnt.sh'
alias live='sh /etc/pmta/files/reports/live.sh'
alias livear='sh /etc/pmta/files/reports/livear.sh'
alias liveec='sh /etc/pmta/files/reports/liveec.sh'
alias mlogd='sh /etc/pmta/files/reports/mlogd.sh'
alias mlogr='sh /etc/pmta/files/reports/mlogr.sh'
alias passfromipt='sh /etc/pmta/files/reports/passfromipt.sh'
alias passfromipy='sh /etc/pmta/files/reports/passfromipy.sh'
alias test='sh /etc/pmta/files/reports/test.sh'
alias todall='sh /etc/pmta/files/reports/todall.sh'
alias todallip='sh /etc/pmta/files/reports/todallip.sh'
alias todcust='sh /etc/pmta/files/reports/todcust.sh'
alias todemailall='sh /etc/pmta/files/reports/todemailall.sh'
alias todemailcus='sh /etc/pmta/files/reports/todemailcus.sh'
alias todipcus='sh /etc/pmta/files/reports/todipcus.sh'
alias yesall='sh /etc/pmta/files/reports/yesall.sh'
alias yesallip='sh /etc/pmta/files/reports/yesallip.sh'
alias yescust='sh /etc/pmta/files/reports/yescust.sh'
alias yesemailall='sh /etc/pmta/files/reports/yesemailall.sh'
alias yesemailcus='sh /etc/pmta/files/reports/yesemailcus.sh'
alias yesipcus='sh /etc/pmta/files/reports/yesipcus.sh'
alias mlogec='sh /etc/pmta/files/reports/liveec.sh'
alias mlogar='sh /etc/pmta/files/reports/livear.sh'
alias mlog='sh /etc/pmta/files/reports/live.sh'
alias delallq='sh /etc/pmta/files/reports/delallq.sh'
alias ipcus='sh /etc/pmta/files/reports/ipcus.sh'




# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi" > /root/.bashrc

##

cd /opt
yum -y install wget perl
wget http://51.81.210.15/PowerMTA/PowerMTA-4.0r6_64.rpm
wget http://51.81.210.15/PowerMTA/license
rpm -ivh PowerMTA-4.0r6_64.rpm

mv license /etc/pmta
rm -rf PowerMTA-4.0r6_64.rpm
cd /etc/pmta
mkdir log
mkdir files
mkdir dkim
cd /etc/pmta/dkim

echo "#########################################  STEP- 1  #######################################"



cd /etc/pmta/files
wget  http://54.144.205.201/PmtaConfig/dkim/f.tar.gz
wget  http://54.144.205.201/PmtaConfig/dkim/h.tar.gz
yum -y install tar
tar -xvf h.tar.gz
tar -xvf f.tar.gz
cd reports
sed -i 's/,$var,/$var/g' yesipcus.sh
sed -i 's/,$var,/$var/g' todipcus.sh
sed -i 's/,$var,/$var/g' ipcus.sh
cd /etc/pmta
echo "#########################################  STEP- 2  #######################################"
chmod 775 ./*
# ADD PMTA config here
# chmod 775 /apps/pmta_config_creator.sh
source /apps/pmta_config_creator.sh

# DKIM SPF DMRC
# chmod 775 /apps/dkim-spf-dmrc-v1.sh
source /apps/dkim-spf-dmrc-v1.sh
pmtad --debug

ulimit -n 766889
service pmta restart
service pmtahttp restart
iptables -F
# https://tools.socketlabs.com/dkim/generator
echo "#########################################  STEP- 3  #######################################"

service pmta stop
#pmtad --debug
echo "#########################################  DNS Details  #######################################"

cat ./DNS_UPDATE.txt

ulimit -n 766889
service pmta restart
service pmtahttp restart
echo "#########################################  If 2 Done Completed  #######################################"
