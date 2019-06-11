#!/usr/bin/env bash

#Author	    :	thebinary <binary4bytes@gmail.com>
#Date	    :	Tue Jun 11 11:32:16 +0545 2019-06-11
#Purpose    :

source_dir=$(dirname ${BASH_SOURCE[0]})
source $source_dir/../init.sh

echo "ROOT OID - IFMIB"
table:rootoid IFMIB
echo "RETURN: $?"
echo ""

echo "ROOT OID - IFMIB2"
table:rootoid IFMIB2
echo "RETURN: $?"
echo ""

echo "FIELD OID - IFMIB index"
table:fieldoid IFMIB index
echo "RETURN: $?"
echo ""

echo "FIELD OID - IFMIB DESCR"
table:fieldoid IFMIB DESCR
echo "RETURN: $?"
echo ""

echo "FIELD OID - IFMIB EMPTY"
table:fieldoid IFMIB EMPTY
echo "RETURN: $?"
echo ""

echo "ENTRY SET - IFMIB 123 index=1 descr=\"'test'\" empty=1"
table:entry:set IFMIB 1234 index=1 descr="'test'" empty=1
echo "RETURN: $?"
echo ""

echo "ENTRY GET - IFMIB 1234 index descr empty"
table:entry:get IFMIB 1234 index descr empty
echo "RETURN: $?"
echo ""
