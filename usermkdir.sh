#!/bin/ksh

main () {
	clear
    echo "start menu"
    echo "1:新增目錄"
    echo "2:刪除目錄" 	
    read Menu_No?"                                 請選擇選項(1-2) : "
    case $Menu_No in  
        1)
            DIR_INFO MKDIR
            ;;
        2)
            DIR_INFO RMDIR
            ;;
        q|Q)
            exit 
            ;;
        *)
            echo "" 
	    echo "[Error]  輸入錯誤, 請輸入 (1-2)的選項"
	    read Answer?"  按Enter鍵繼續 "
	    main
            ;;
    esac

}

# Setting the LPAR information.  
MENU_INPUT () {
#set -x
   echo ""
   HOSTN=""
   HOSTLIST=""
   HOSTDIR="/home/se/safechk/cfg/host.lst" 
   timestamp=`date +"%Y%m%d%H%M%S"`
   HOSTNAME=`hostname`

   if [[ "$HOSTN" == "" ]]; then
       echo ""
       echo "                  (隨時可輸 q 以離開 ) "
       echo "#==========================================================#"
       echo "# 輸入格式(每台主機以空格做為分隔): DAP1-1 DAR1-1 LOG1 MDS1#"
       echo "#                                                          #"
       echo "# 群組輸入格式: DAP (一次一個群組)                         #"
       echo "#                                                          #"
       echo "# 全部主機請輸入: ALL                                      #"
       echo "#==========================================================#"
       read HOSTN?"輸入欲傳送的主機名稱 : "
       if [[ "$HOSTN" == "q" ]] || [[ "$HOSTN" == "Q" ]]; then
           main
       fi

       case $HOSTN in
           dap|DAP)
               HOSTLIST=`cat $HOSTDIR | grep -i ^DAP`
               ;;
           dar|DAR)
               HOSTLIST=`cat $HOSTDIR | grep -i ^DAR`
               ;;
           mds|MDS)
               HOSTLIST=`cat $HOSTDIR | grep -i ^MDS`
               ;;
           log|LOG)
               HOSTLIST=`cat $HOSTDIR | grep -i ^LOG`
               ;;
           fix|FIX)
               HOSTLIST=`cat $HOSTDIR | grep -i ^FIXGW`
               ;;
           ts|TS)
               HOSTLIST=`cat $HOSTDIR | grep -i ^TS`
               ;;
           all|ALL)
               HOSTLIST=`cat $HOSTDIR | grep -i -v $HOSTNAME`
               ;;
           *)
               HOSTLIST=$HOSTN
               ;;
	esac

			   if [[ -z "$HOSTLIST" ]]; then
           	  		echo ""
	    			echo "               [Error]  輸入為空值 "
	    			echo ""
	    			read ANSWR?"               按Enter鍵繼續 "
	    			main
			   fi
    fi
}

# Setting the User information.  
USER_CHECK (){

    DIROWNER=""
    DIRGROUP=""

    if [[ "$DIROWNER" == "" ]]; then
        echo ""
	echo "                  (隨時可輸 q 以離開 ) "
	echo ""
	read DIROWNER?" 輸入目錄的擁有者 : "
	fi

	if [[ "$DIROWNER" == "q" ]] || [[ "$DIROWNER" == "Q" ]]; then
	    main
    fi

	USERNAMECHK=`grep "^${DIROWNER}:" /etc/passwd | awk -F: '{print $1}'`
	if [[ "$USERNAMECHK" != "$DIROWNER" ]]; then
	    echo ""
	    echo "               [Error]  輸入使用者名稱不存在 "
	    echo ""
	    read ANSWR?"               按Enter鍵繼續 "
	    main 
	fi

	if [[ -z "$USERNAMECHK" ]]; then
	    echo ""
	    echo "               [Error]  輸入使用者名稱為空值 "
	    echo ""
	    read ANSWR?"               按Enter鍵繼續 "
	    main 
	fi

        read DIRGROUP?" 輸入目錄的擁有群組 : "
	if [[ "$DIRGROUP" == "q" ]] || [[ "$DIRGROUP" == "Q" ]]; then
	    main
	fi

	GROUPCHK=`grep "^${DIRGROUP}:" /etc/group | awk -F: '{print $1}'`

	if [[ "$GROUPCHK" != "$DIRGROUP" ]]; then
	    echo ""
	    echo "               [Error]  輸入群組不存在 "
	    echo ""
	    read ANSWR?"               按Enter鍵繼續 "
	    main 
	fi

	if [[ -z "$GROUPCHK" ]]; then
  	    echo ""
	    echo "               [Error]  輸入群組為空值 "
	    echo ""
	    read ANSWR?"               按Enter鍵繼續 "
	    main 
	fi
}

# Setting the Directory information.  
DIR_CHECK () {
	
DIRPATH=""
DIRPERM=""
MODE=$1

    read DIRPATH?" 輸入目錄的路徑位置(絕對路徑) : "

    if [[ "$DIRPATH" == "q" ]] || [[ "$DIRPATH" == "Q" ]]; then
        main
    fi

    if [[ -z "$DIRPATH" ]]; then
        echo ""
        echo "               [Error]  輸入目錄為空值 "
		echo ""
		read ANSWR?"               按Enter鍵繼續 "
        main
    fi

	if [[ $MODE = MKDIR ]]; then

		read DIRPERM?" 輸入目錄的權限,請輸入3個(0-7數字),如755: "

		if [[ "$DIRPERM" == "q" ]] || [[ "$DIRPERM" == "Q" ]]; then
			main
		fi

		if [[ "$DIRPERM" != [1-7][0-7][0-7] ]]; then
			echo ""
			echo "               [Error]  輸入Permission非數字格式,請輸入3個(0-7範圍)的數字"
			echo ""
			read ANSWR?"               按Enter鍵繼續 "
			main
		fi
	fi
}

# Setting the main information.  
DIR_INFO () {

MODE=$1
DIRPATH=""
DIRPERM=""
CHKFLG=0

# User the MENU_INPUT function, to Set the LPAR information.  
MENU_INPUT
# User the USER_CHECK function, to Set the USER information.  
USER_CHECK

# User the DIR_CHECK function, to Set the Directory information.  
if [[ $MODE = MKDIR ]]; then
    DIR_CHECK MKDIR
fi

# User the DIR_CHECK function, to Set the Directory information.  
if [[ $MODE = RMDIR ]]; then
    DIR_CHECK RMDIR
fi

    if [[ "$CHKFLG" != "0" ]]; then
        echo ""
	read ANSWR?"               按Enter鍵繼續 "
	main
    else
	echo ""
	echo "Directory OWNER:      $DIROWNER"
	echo "Directory GROUP:      $DIRGROUP"
	echo "Directory PATH:       $DIRPATH"
	echo "Directory Permission: $DIRPERM"
	echo ""
	echo "#===主機列表===#"
	echo "$HOSTLIST"
    echo "#==============#"
		   
	read ANSWER?"             請確認上述資訊無誤(Y/N): "
	case $ANSWER in
	    n|N)
	        main
	        ;;
	    y|Y)

			if [[ $MODE = MKDIR ]];then 
				CMDTYPE="$DIROWNER:$DIRGROUP $DIRPATH $DIRPERM $MODE "
			else 
				CMDTYPE="$DIRPATH $MODE "
			fi

			for HOST in $HOSTLIST ; do
	            echo "$HOST 執行中..."

				echo "SSH_CMD $CMDTYPE"
				SSH_CMD $CMDTYPE

			    if [[ -f /tmp/dirdatafile.${HOST} ]] ; then
       		    	echo $HOST OK! >> /tmp/$USER.$timestamp
					cat /tmp/dirdatafile.${HOST} >> /tmp/$USER.$timestamp
		        	rm /tmp/dirdatafile.${HOST}
    			else
        			echo $HOST has a problem! >> /tmp/$USER.$timestamp
    			fi
	        done
#-----------------------------------------------------------
# Section 2 --- Verify that the directory were created
#    Part 2 --- Inspect the retrieved files
#-----------------------------------------------------------

	         echo ""
	         echo "#==========================#"
	         echo "#  執行指令主機結果清單:   #"
	         echo "#==========================#"
	         cat /tmp/$USER.$timestamp
			 rm /tmp/$USER.$timestamp
	         read ANSWR?"               按Enter鍵繼續 "
     	         main
	         ;;
	    *)
	         echo "[Error]  輸入錯誤, 請輸入(Y/N)"
	         read ANSWR?"               按Enter鍵繼續 "
	         	main
	         ;;
        esac
    fi
}

# Use the ssh Remote excution to the LPAR .
SSH_CMD() {
#set -x 

#-----------------------------------------------------------
#Create or delete directory --- create or delete directory on a list of hosts
#You will need to adjust HOSTLIST, OWNER, PERMIT.  You may need to adjust DELAY
#-----------------------------------------------------------

if [[ $# -lt 2 ]]; then
    echo "Please Input mkdir_ssh.sh Owner:Group Directory Permission"
    echo
    echo "Example: mkdir_ssh.sh useradm:security /home/se/test 755 MKDIR/RMDIR"
    echo "Example: mkdir_ssh.sh /home/se/test MKDIR/RMDIR"
    exit 1
fi

#-----------------------------------------------------------
# Section 0 --- Set variable
#-----------------------------------------------------------

DELAY=1
USER=$(whoami)
HOMEDIR=`lsuser $USER | awk '{print $5}' | cut -c6-`

# When Paremeter is 4 , then the mode is mkdir.
if [[ $# -eq 4 ]]; then
	OWNER=$1
	DIR=$2
	PERMIT=$3
	MODE=$4
fi

# When Paremeter is 2 , then the mode is rmdir. 
if [[ $# -eq 2 ]]; then
	DIR=$1
	MODE=$2
fi


exec 4>&1

#-----------------------------------------------------------
# Section 1 --- Create Directory
#-----------------------------------------------------------
if [[ $MODE = "MKDIR" ]]; then
    ssh -p 2222 -t -t $HOST >&4 2>/dev/null |&
    print -p mkdir -p $DIR
    print -p chown $OWNER $DIR
    print -p chmod $PERMIT $DIR
    print -p "test -d $DIR && touch dirdatafile.${HOST}"
	print -p "ls -ld $DIR > dirdatafile.${HOST}"
    print -p exit
    wait
fi

if [[ $MODE = "RMDIR" ]] ; then
    ssh -p 2222 -t -t $HOST >&4 2>/dev/null |&
    print -p rm -rf $DIR
    print -p "test ! -d $DIR && touch dirdatafile.${HOST}"
    print -p exit
    wait
fi

#-----------------------------------------------------------
# Section 2 --- Verify that the directory were created
#    Part 1 --- Retrieve those check files
#-----------------------------------------------------------
	echo "$HOST 結果檢查中..."
    scp -P 2222 ${USER}@${HOST}:$HOMEDIR/dirdatafile.${HOST} /tmp/
	ssh -p 2222 ${USER}@${HOST} "rm -f $HOMEDIR/dirdatafile.${HOST}"
}

main
