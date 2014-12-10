#!/bin/bash
wget http://autoproxy-gfwlist.googlecode.com/svn/trunk/gfwlist.txt -O gfwlist.txt
base64 -d gfwlist.txt > gfwlist.dec	#Base64 decode
grep '^@@' gfwlist.dec > gfwlist.direct	#direct connect
grep '^||' gfwlist.dec > gfwlist.p1	#pattern 1:start with "||"
grep '^\.' gfwlist.dec > gfwlist.p2	#pattern 2:start with "."
grep '^|[^|]' gfwlist.dec > gfwlist.p3	#pattern 3:start with single "|"
grep -v '^|\|^$\|^@\|^\.\|^\[\|^!' gfwlist.dec > gfwlist.p4	#pattern 4:others
#
echo 'converting to domain list...'
sed -i 's/^||//g' gfwlist.p1	#remove the leading "||"
sed -i 's/\/.*$//g' gfwlist.p1	#remove anything after "/", including "/"
sed -i 's/\^//g' gfwlist.p1	#remove "^" if any, due to gfwlist's flawed lines
#sed -i '/^$/d' gfwlist.p1	#delete blank line

sed -i 's/^\.//g' gfwlist.p2	#remove the leading "."
sed -i 's/^google[\.\*].*//g' gfwlist.p2	#remove lines start with google. or google*
sed -i 's/\/.*//g' gfwlist.p2	#remove anything after "/", including "/"
#sed -i '/^$/d' gfwlist.p2	#delete blank line

sed -i 's/|http:\/\///g' gfwlist.p3	#remove prefix
sed -i 's/|https:\/\///g' gfwlist.p3	#remove prefix
sed -i 's/\/.*$//g' gfwlist.p3	#remove .....
sed -i 's/^\*\.//g' gfwlist.p3
#sed -i 's/\*//g' gfwlist.p3

grep '\.' gfwlist.p4 > gfwlist.tmp	#remove lines contain no domain
mv gfwlist.tmp gfwlist.p4
sed -i 's/\/.*$//g' gfwlist.p4	#remove....
sed -i 's/^google.*$//g' gfwlist.p4	#remove lines start with google
grep -v '\.wikipedia\.org.*' gfwlist.p4 > gfwlist.tmp	#remove wikipedia lines
mv gfwlist.tmp gfwlist.p4
#sed -i '/^$/d' gfwlist.p4	#delete blank line

cp gfwlist.p1 domainlist.tmp
echo '
'>> domainlist.tmp
cat -s gfwlist.p2 >> domainlist.tmp
echo '
'>> domainlist.tmp
cat -s gfwlist.p3 >> domainlist.tmp
echo '
'>> domainlist.tmp
cat -s gfwlist.p4 >> domainlist.tmp
sort domainlist.tmp | uniq > domainlist.txt
sed -i '/^[[:space:]]*$/d' domainlist.txt	#delete blank line
grep '\*' domainlist.txt > domainlist.special
grep '^|' domainlist.txt >> domainlist.special
sed -i '/\*\|^|/d' domainlist.txt
rm domainlist.tmp

echo 'done.'
exit 0
