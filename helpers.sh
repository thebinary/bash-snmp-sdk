#!/bin/bash

#Author	    :	thebinary <binary4bytes@gmail.com>
#Date	    :	Tue Jun 11 14:55:47 +0545 2019-06-11
#Purpose    :   Helper functions

function ssdk:helper:chr {
    printf \\$(printf '%03o' $1)
}

function ssdk:helper:ord {
    printf '%d' "'$1"
}

function ssdk:helper:oid2str {
    for char in $(echo "$1" | tr '.' ' '); do ssdk:helper:chr $char; done
}

function ssdk:helper:str2oid {
    for i in $(echo "$1" | sed 's/\(.\)/ \1 /g'); do ssdk:helper:ord $i; echo -n "."; done;
}
