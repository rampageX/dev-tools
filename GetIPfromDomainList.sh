#!/bin/bash
while read DomainName;do
	dig @8.8.8.8 $DomainName A | \
	grep -v '^;' | grep 'IN[[:space:]]\+A'| \
	awk '{print $1 " " $5}' >> IPList.txt
done < DomainList.txt
