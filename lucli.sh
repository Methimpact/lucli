#!/bin/bash
#
# use openwrt/lede luci json rpc to get ip(s) matching a pattern
#
#   https://github.com/openwrt/luci/wiki/JsonRpcHowTo
#   https://github.com/openwrt/luci/tree/lede-17.01/modules/luci-mod-rpc
# 
#

dfghjk=""
echo "THIS IS NOT USABLE IN PRODUCTION!"
read dfghjk

#https://htmlpreview.github.io/?
##https://github.com/openwrt/luci/tree/master/documentation/api/modules
#ipkg https://raw.githubusercontent.com/openwrt/luci/master/documentation/api/modules/luci.model.ipkg.html#find
#wifi https://raw.githubusercontent.com/openwrt/luci/master/documentation/api/modules/luci.sys.wifi.html
#user https://raw.githubusercontent.com/openwrt/luci/master/documentation/api/modules/luci.sys.user.html
#luci.sys.process https://raw.githubusercontent.com/openwrt/luci/master/documentation/api/modules/luci.sys.process.html
#Class luci.sys.net https://raw.githubusercontent.com/openwrt/luci/master/documentation/api/modules/luci.sys.net.html
#luci.sys https://raw.githubusercontent.com/openwrt/luci/master/documentation/api/modules/luci.sys.html
#luci.ip https://raw.githubusercontent.com/openwrt/luci/master/documentation/api/modules/luci.ip.html
#luci.sys.init https://raw.githubusercontent.com/openwrt/luci/master/documentation/api/modules/luci.sys.init.html
#Object Instance luci.model.uci https://raw.githubusercontent.com/openwrt/luci/master/documentation/api/modules/luci.model.uci.html#Cursor.get



# A POSIX variable
# Reset in case getopts has been used previously in the shell.
OPTIND=1


thost=("11.0.0.1" "192.168.56.1" "192.168.8.1" "10.0.0.1")
host="192.168.56.1"
host="192.168.8.1"
host="11.0.0.1"
user="root"
pass="password"
did=1

blah="y"
blaroht="n"
blah="n"
verb=""


blah="y"
#blaroht="y"


doto="#"
otod="#"
xlib="#"
mthd="#"
aprm="#"
jcolor="-C"

if [ $blah = y ]
then
    blah="y"
    #verb="-vvvv"
fi

reqlib='{
    "auth" : {      "login":"user+pass"
    },"ipkg" : {    "find":"pat+cb", "info":"pkg", "install":"pkgs", "installed":"pkg",
                    "list_all":"pat+cb",  "list_installed":"pat+cb",  "overlay_root":"",
                    "remove":"pkgs",  "status":"pkg", "update":"",  "upgrade":""
    },"wifi" : {    "getiwinfo":"ifname"
    },"user" : {    "getuser":"uid", "checkpasswd":"username+pass", "getpasswd":"username", "setpasswd":"username+password"
    },"process" : { "info":"", "list":"", "setgroup":"gid", "setuser":"uid", "signal":"pid+sig"
    },"net" : {     "arptable":"", "conntrack":"", "deviceinfo":"", "devices":"", "host_hints":"",
                    "ipv4_hints":"", "ipv6_hints":"", "mac_hints":"", "pingtest":"host", "routes":"", "routes6":""
    },"sys" : {     "call":"cmdline", "dmesg":"", "exec":"cmd", "getenv":"var", "hostname":"host", "httpget":"url+stream+target",
                    "mounts":"", "reboot":"", "syslog":"", "uniqueid":"bytes", "uptime":""
    },"ip" : {      "new":"address+netmask", "IPv4":"address+netmask", "IPv6":"address+netmask",
                    "route":"address", "routes":"filter+callback", "neighbors":"filter+callback", "link":"device"
    },"init" : {    "disable":"name", "enable":"name", "enabled":"name", "index":"name", "names":"", "start":"name", "stop":"name"
    }    }'





#    "" : {"":"", "":"", "":"", "":"", "":"", "":"" },
#    "" : {"":"", "":"", "":"", "":"", "":"", "":"" },
#    "" : {"":"", "":"", "":"", "":"", "":"", "":"" },

function eee(){
    if [ $1 = y ]
    then
        echo "$2"
    fi
}

function auth(){
    dudu='{"id": '$did', "method": "login","params": ["'${user}'","'${pass}'"]}'
    eee $blah "DUDU > $dudu"
    rot="$(curl ${copts} ${rpc}/auth --data "$dudu")"
    eee $blaroht "rot > $rot"
    tok="$(echo $rot | jq -r .result )"
    did=$((did+1))
    eee $blah "tok > $tok"
    eee $blah "did > $did"
}

function get(){
    typ=$1
    tlib=$2
    method=$3
    prms=$4
    kot=$5
    rot=""
    lur=""
    lur=${rpc}/${tlib}?auth=${kot}

    if [ $typ = g ]
    then
        eee $blah "GETE < GET > $tlib"
        rot="$(curl ${copts} ${lur})"
    elif [ $typ = p ]
    then
        prmslen=${#prms}
        eee $blaroht  "Prmslen  -=[$prmslen]=-"
        #eee $blah     "LUR  -=[$lur]=-"
        if [ "$prmslen" -ge "2" ]
        then
            b=()
            bi=""
            aprm=()
            for item in ${prms}
            do
                #aprm+=("$bi\"$item\"")
                aprm+=("$bi\"$item\"")
                bi=", "
                echo "FOR=$bi\"$item\""
            done
            dudu='{"id": '$did', "method":"'$method'", "params":['"${aprm[@]}"']}'
            eee $blah "PUDU < GE222 > $dudu"
            rot="$(curl ${copts} ${lur} --data "$dudu")"
        elif [ "$prmslen" -ge "1" ]
        then
            dudu='{"id": '$did', "method":"'$method'", "params":['$prms']}'
            eee $blah "PUDU < GE111 > $dudu"
            rot="$(curl ${copts} ${lur} --data "$dudu")"
        else
            dudu='{"id": '$did', "method":"'$method'" }' #"params":[]}'
            eee $blah "PUDU < G3LS3 > $dudu"
            rot="$(curl ${copts} ${lur} --data "$dudu")"
        fi
        eee $blaroht "rot > $rot"
        tores="$(echo $rot | jq -cC -r .result )"
        toerr="$(echo $rot | jq -cC -r .error )"
        did=$((did+1))
        eee $blah "jq < RESULT >>>> |"
        eee $blah "$tores"
        eee $blah "qj > TLUSER <<<< |"
        eee $blah "jq < ERROR > $toerr"
        eee $blah "did > $did"
    fi
}




function ipkgtest(){
eee $blah "ipkgtest"
get 'p' 'ipkg' 'overlay_root' '' $tok
#get 'p' 'ipkg' 'update' '' $tok
#get 'p' 'ipkg' 'list_all' '' $tok
#Invalid CB => #get 'p' 'ipkg' 'list_installed' '' $tok
}

function ucitest(){
eee $blah "ucitest"
get 'p' 'uci' 'get_all' '' $tok
}

function systest(){
eee $blah "systest"
get 'p' 'sys' 'process.list' '' $tok
get 'p' 'sys' 'net.ipv4_hints' '' $tok
get 'p' 'sys' 'net.conntrack' '' $tok
get 'p' 'sys' 'exec' '"/bin/ls"' $tok
get 'p' 'sys' 'exec' '"/bin/pwd"' $tok
get 'p' 'sys' 'init.names' '' $tok
get 'p' 'sys' 'init.index' '"mDNSResponder"' $tok
}

function iptest(){
eee $blah "iptest"
get 'p' 'sys.ip' 'link' '"eth0"' $tok
#get 'p' 'sys.ip' 'link' '"eth1"' $tok
#get 'p' 'sys.ip' 'link' '"eth2"' $tok
##get 'p' 'sys.ip' 'link' 'eth2' $tok
##get 'p' 'sys.ip' 'link' '"eth0"' $tok
}

function naantest(){
#ipkg
get 'p' 'ipkg' 'list_installed' '' $tok
#ucitest
get 'p' 'uci' 'get_all' '*' $tok
#systest
get 'p' 'sys' 'init.index' '"mDNSRespond333r"' $tok
get 'p' 'sys' 'exec' '"/bin/ls", ".."' $tok
get 'p' 'sys' 'exec' '"/b/in/pwd"' $tok
#iptest
get 'p' 'ip' 'link' '"eth0"' $tok
get 'p' 'sys.ip' 'link' '"eth2"' $tok
}

function maintest(){
ipkgtest
ucitest
systest
iptest
}

function maan(){
get 'p' 'sys' 'process.list' '' $tok
get 'p' 'sys' 'net.ipv4_hints' '' $tok
get 'p' 'sys' 'net.conntrack' '' $tok
}

#function parse(){

# Parse options to the `pip` command
# <3 thx <3 https://sookocheff.com/post/bash/parsing-bash-script-arguments-with-shopts/
while getopts "hvbrct:" opt; do
  case ${opt} in
    v )
        verb="-vvvv"
    ;;
    r )
        blaroht="y"
    ;;
    b )
        blah="y"
    ;;
    t )
        host=$OPTARG
    ;;
    c )
        jcolor="-C"
    ;;
    h )
        echo "Usage:"
        echo "    lucli [0P710N5] <COm4nd> [..]"
        echo ""
        echo "COm4nd:"
        echo "    x <lib> <cmd> [args]     Execute <lib> <cmd> [args]."
        echo "    l <lib> <cmd> [args]     LLLLLL <lib> <cmd> [args]."
        echo "    a                        Alive?."
        echo "    s                        ScanAndSearch for <host> ?."
        echo "    w [msg]                  ScanAndSearch for <host> ?."
        echo ""
        echo "General 0P710N5:"
        echo "    -h                              Display this help message."
        echo "    -v                              Give more output CURL . . . ."
        echo "    -b                              Display Blah message."
        echo "    -r                              Rhelp message."
        echo "    -t [HOST]                       Target Host."
        echo "    -c                              COLOR."
        echo ""
        echo "Examples:"
        echo "    lucli -h                             # Display this help message."
        echo "    lucli s                             # Display this help message."
        exit 0
      ;;
   \? )
     echo "Invalid Option: -$OPTARG" 1>&2
     exit 1
     ;;
  esac
done
shift $((OPTIND -1))

subcommand=$1; shift  # Remove 'pip' from the argument list
case "$subcommand" in
  # Parse options to the install sub command
  l)
    doto="L"
    xlib=$1; shift  # Remove 'install' from the argument list
    doto="L"
    #echo "LLLLLLLLLLLLLLLLLLLLLLLL"
    #echo "DOTO : $doto"
    #echo "OTOD : $xlib"
    #echo "LLLLLLLLLLLLLLLLLLLLLLLL"
    #exit 0
  ;;
  s)
    doto="S"
    #echo "SSSSSSSSSSSSSSSSSSSSSSSS"
    exit 0
  ;;
  a)
    doto="A"
    #echo "AAAAAAAAAAAAAAAAAAAAAAAA"
    exit 0
  ;;
  x)
    doto="X"
    xlib=$1; shift
    mthd=$1; shift
    aprm=$@; shift
    echo "XasdasdXXXXXXXXXXXXXXXXXXXXXXX"
    echo "DOTO  : $doto ;"
    echo "XLIB  : $xlib ;"
    echo "MTHD  : $mthd ;"
    echo "PARAM : "$aprm" ;"
    echo "aaXXXXXXXXXXXXXXXXXXXXXXXX"
    #exit 0
  ;;
  w)
    doto="W"
    xlib="$1"; shift

    echo "DOTO : $doto"
    echo "OTOD : $xlib"

    # Process package options
    while getopts ":t:" opt; do
      case ${opt} in
        t )
          target=$OPTARG
          ;;
        \? )
          echo "Invalid Option: -$OPTARG" 1>&2
          exit 1
          ;;
        : )
          echo "Invalid Option: -$OPTARG requires an argument" 1>&2
          exit 1
          ;;
      esac
    done
    shift $((OPTIND -1))
    ;;
esac

copts="-k $verb -L -s"
jopts="-r $jcolor"
url="https://${host}/cgi-bin/luci"
rpc="${url}/rpc"

echo " ########################"
echo "- CURL OPTS    : $copts"
echo "    \\___VERB  : $verb"
echo "  TARGET URL   : $url"
echo "  TARGET RPC   : $rpc"
echo ""
echo "- JQ OPTS      : $jopts"
echo "    \\___VERB  : $verb"
echo "    \\___COLOR : $jcolor"
echo "| DOTO  : $doto ;"
echo "| XLIB  : ${xlib} ;"
echo " ########################"
case ${doto} in
    X )
        echo "- XXXXXXXXXXXXXXXXXXXXXXXX"
        echo "- DOTO  : $doto ;"
        echo "- XLIB  : $xlib ;"
        echo "- MTHD  : $mthd ;"
        echo "- PARAM : "${aprm}" ;"
        echo "-XXXXXXXXXXXXXXXXXXXXXXXX"

        auth
        #for item in "${a[@]}"; do echo "[$item]"; done
        b=()
        bi=""
        for item in ${aprm}
        do
            b+=("$bi\"$item\"")
            bi=", "
        done
        #echo "${b[@]}"

        #declare -a "array=( $(echo $aprm | tr '`$<>' '????') )"
        #for item in "${array[@]}"; do echo "[$item]"; done
        c="$(echo ${b[@]})"
        if [ "$blaroht" = "y" ]
        then
            echo "----"
            echo ''${b[@]}''
            echo "${b[@]}"
            echo "----"
            echo "$c"
            echo "----"
            echo "${aprm[@]}"
        fi
        #get 'p' ''$xlib'' ''$mthd'' ''${b[@]}'' $tok
        get 'p' ''$xlib'' ''$mthd'' "${aprm[@]}"  $tok
        exit 0
    ;;
    A )
        echo "AAAAAAAAA"
        exit 0
    ;;
    L )
        echo "l l l. . . .. "
        #echo "$reqlib"        #echo ""
        if [ "${#xlib}" -ge "1" ]
        then
        echo "$reqlib" | jq --tab -C .$xlib
        else
        echo "$reqlib" | jq --tab -C
        fi
        exit 0
    ;;
    S )
        echo "S s S s S s s"
        exit 0
    ;;
    \? )
        echo "Invalid > TODO > -$OPTARG " 1>&2
        exit 1
    ;;
    : )
        echo "Invalid > TODO > -$OPTARG requires an argument" 1>&2
        exit 1
    ;;
esac

exit 0






#auth
#maan
#main
#test

exit 0


#### NaAaN ####
##
#iptest
#Na :> #get 'p' 'ip' 'link' '"eth0"' $tok
#Na :> #get 'p' 'sys.ip' 'link' '"eth2"' $tok



##
#### NaAaN ####








#iptest
#bk#atad='{ "method": "net.ipv4_hints"}'
#bk#curl ${copts} "${rpc}/sys?auth=${tok}" --data "$atad" | jq -c -r '.result[]'
#bk##| jq -r '.result[]|.[]'
#bk##| grep -B1 "${match}" | egrep -v "^(${match}|--)"
#bk####'"params": ["method":







#dzz='{ "method": "net.ipv4_hints"}'
#GET#rot="$(curl ${copts} ${rpc}/${tlib}?auth=${kot})"
#GET#curl ${copts} "${rpc}/${method}?auth=${tok}"  | jq -c -r '.result[]'
#GET#torr="$(echo $rot | jq -r .result )"
#curl ${copts} "${rpc}/${method}?auth=${tok}" --data "$atad" | jq -c -r '.result[]'
#read -p "host: " host #read -p "user: " user #read -s -p "pass: " pass#read -p "match: " match
