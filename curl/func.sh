# $1, $2, ... это параметры функции.

curl_dnl_func() {
	
	#curl --silent ftp://andrey:ok@192.168.2.1$folder_on_ftp/$1 -o $folder_on_host/$1
	curl --silent -u root ftp://$m50_ftp_ip$folder_on_ftp/$1 -o $folder_on_host/$1
	
	if [ -f $folder_on_host/$1 ]
	  chmod 666 $folder_on_host/$1
	  then
		if [ "$2" = "x" ]; then
			chmod a+x $folder_on_host/$1
			echo "  chmod a+x $folder_on_host/$1"
		fi
		
		echo "  $folder_on_host/$1 : was downloaded "
	  else
		echo "  ERROR: $folder_on_host/$1 : was not downloaded"
	fi

}

# For win
# C:\Program Files>curl.exe -u -root ftp://$m50_ftp_ip/M50DATA/FtpDir/data_lock -o data_lock_
# ok :)

curl_upl_func() {
  echo "curl_upl_func()"
  if [ -f $folder_on_host/$1 ]; then
	  curl --upload-file $folder_on_host/$1 -u root ftp://$m50_ftp_ip$folder_on_ftp/$1
	  echo "  $folder_on_host/$1 : was uploaded to M50"
  else
	  echo "  ERROR: $folder_on_host/$1 : to transfer does not exists"
  fi
	  
}

ip_is_up=no

# ping -c 1 -t 1 192.168.1.1 && echo "192.168.1.1 is up!"
ping -c 1 -t 1 $m50_ftp_ip > /dev/null;

if [ $? -eq 0 ]; then
    echo "$m50_ftp_ip is up";
    ip_is_up=yes
else 
    echo "$m50_ftp_ip is down";
    ip_is_up=yes
    #exit
fi


# это можно и не делать так как там return стоит.
#if [ "$ip_is_up" = "yes" ]
#then