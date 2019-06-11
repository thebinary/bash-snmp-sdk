#!/usr/bin/env bash

#Author	    :	thebinary <binary4bytes@gmail.com>
#Date	    :	Tue Jun 11 01:49:38 +0545 2019-06-11
#Purpose    :	SNMP Table core functions


#
# get the root oid of table
# return codes
#   0 => success
#   1 => table_name root oid not defined
# stdout
#   root_oid of the table
#
function table:rootoid {
    local table_name="$1"
    local table_root_varname="S_ROOT_${table_name}"
    local root_oid=${!table_root_varname}
    if [ -z $root_oid ]
    then
	echo "[ERR] '$table_name' root oid not defined" >& 2
	return 1
    fi

    echo "$root_oid"
}


#
# get the definition of given field in given table 
# return codes
#   0 => success
#   1 => table field name not defined
# stdout
#   field definition
#
function table:fielddata {
    local table_name="$1"
    local field_name_orig="$2"

    # convet to uppercase
    local field_name="${field_name_orig^^}"

    local field_varname="S_FIELD_${table_name}_${field_name}"
    local field_data=${!field_varname}	
    if [ -z "$field_data" ]
    then
	echo "[ERR] '$table_name::$field_name' field not defined" >& 2
	return 1
    fi 

    echo "$field_data" | tr ':' ' '
}


#
# get the full oid of with table root and field id
# return codes
#   0 => success
#   1 => table root oid not defined
#   3 => table field not defined
#
# stdout
#   <table_root_oid>.<field_id>
#
function table:fieldoid {
    local table_name="$1"
    local field_name="$2"

    root_oid=$(table:rootoid "$table_name")
    if [ $? -ne 0 ]
    then
	return 1
    fi

    field_data=($(table:fielddata $table_name $field_name))
    if [ $? -ne 0 ]
    then
	return 2	
    fi 

    local field_id=${field_data[1]}
    printf "%s.%s\n" $root_oid $field_id
}


#
#
#
function table:entry:set {
    local table_name="$1"
    local index="$2"
    shift 2
    local parameters=($@)

    local root_oid=$(table:rootoid "$table_name")
    if [ $? -ne 0 ]
    then
	return 1
    fi

    for parameter in ${parameters[@]}
    do
	local parameter_data=($(echo "$parameter" | tr '=' ' '))
	local param_name=${parameter_data[0]}
	local param_value=${parameter_data[1]}

	field_data=($(table:fielddata $table_name $param_name))
	if [ $? -ne 0 ]
	then
	    continue
	fi
	local field_type=${field_data[0]}
	local field_id=${field_data[1]}
	local field_oid="$root_oid.$field_id"

	local setter="$field_oid.$index $field_type $param_value"
	echo $setter
    done
}


function table:entry:get {
    local table_name="$1"
    local index="$2"
    shift 2
    local parameters=($@)

    local root_oid=$(table:rootoid "$table_name")
    if [ $? -ne 0 ]
    then
	return 1
    fi

    for param in ${parameters[@]}
    do
	field_data=($(table:fielddata $table_name $param))
	if [ $? -ne 0 ]
	then
	    continue
	fi
	local field_id=${field_data[1]}
	local field_oid="$root_oid.$field_id"

	local getter="$field_oid.$index"
	echo $getter
    done
}
