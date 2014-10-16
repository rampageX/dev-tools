# /etc/profile.d/opt_apps.sh 
APPS=/opt/apps 
for a in `ls -d $APPS $APPS/*-current $APPS/node_modules/* 2>/dev/null`; do 
  if [[ ( ! $PATH == *$a/bin* ) && ( -e $a/bin ) ]]; then 
    PATH=$a/bin:$PATH 
  fi 
done 
export PATH 


