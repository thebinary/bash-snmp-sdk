#!/usr/bin/env bash

#Author	    :	thebinary <binary4bytes@gmail.com>
#Date	    :	Tue Jun 11 14:59:19 +0545 2019-06-11
#Purpose    :	Core SNMP Wrapper functions

SSDK_SNMP_VERSION="2c"
SSDK_SNMP_COMMUNITY="public"


function ssdk:walk {
    snmpwalk -v$SSDK_SNMP_VERSION -c $SSDK_SNMP_COMMUNITY $@
}

function ssdk:set {
    snmpset -v$SSDK_SNMP_VERSION -c $SSDK_SNMP_COMMUNITY $@
}

function ssdk:get {
    snmpget -v$SSDK_SNMP_VERSION -c $SSDK_SNMP_COMMUNITY $@
}


function ssdk:table:indexes {
    local host="$1"
    local table_name="$2"

    index_field_oid=$(table:fieldoid $table_name INDEX 2>/dev/null)
    if [ $? -ne 0 ]
    then
	row_field_oid=$(table:fieldoid $table_name ROW 2>/dev/null)
	if [ $? -ne 0 ]
	then 
	    echo "[ERR] '$table' no index or row field defined" >& 2
	    return 1
	fi

	data=$(ssdk:walk -On -Oq $host $row_field_oid)
	if [ $? -ne 0 ]
	then
	    return $?
	fi

	echo -e "$data" | awk '{print $1}' | sed "s/^$row_field_oid\.//g"
    else
	ssdk:walk -Ov -Oq $host $index_field_oid
	return $?
    fi

}
