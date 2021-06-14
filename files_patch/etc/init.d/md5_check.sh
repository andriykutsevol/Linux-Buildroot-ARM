 #!/bin/sh
 
 
 
 
 
if [ "$2" = 'all' ]; then

  line1_tmp=`md5sum $1`
  line1=`echo $line1_tmp | grep -o  "^[[:alnum:]]*"`

else

  line1_tmp=`dd if=$1 bs=1024 count=$2 | md5sum`
  line1=`echo $line1_tmp | grep -o  "^[[:alnum:]]*"`
fi


line2=`cat $3 | grep -o   "^[[:alnum:]]*"`

#echo "--------"
#echo "$1 --- $line1 = $line2"
#echo "--------"


if [ "$line1" = "$line2" ]; then
  echo "$1 : $3 is OK \n" >> /etc/md5check
  exit 0
else
  echo "ERROR: md5sum for $1 is wrong"
  echo 'system is reboted now...'
  #reboot
fi