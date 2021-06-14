#!/bin/sh
$log_name=/var/volatile/log/ptpd2.stats
echo 'sed -e :a -e '$q;N;11,$D;ba' $log_name'


sed -e :a -e '$q;N;11,$D;ba' /var/volatile/log/ptpd2.stats
