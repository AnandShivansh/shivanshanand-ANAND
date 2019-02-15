if [[ $# -ne 4 ]]; then
    echo "Enter 4 arguments i.e. <Foldername><space><Month(3 characters only starting with uppercase)><space><Date><space><Year>"
    exit
fi 
months=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)
indx="0"
day="0"
leap="0"
checkleap()
{
    leap="0"
    if [[ $(($1 % 4)) -eq 0 ]]; then
        if [[ $(($1 % 100)) -eq 0 ]]; then
            if [[ $(($1 % 400)) -eq 0 ]]; then
                leap="1"
            else
                leap="0"
            fi
        else
            leap="1"
        fi
    else
        leap="0"
    fi
}
checkmonth()
{
    indx="0"
    i="0"
    while [[ $i -lt 12 ]]; do
        if [[ $1 == ${months[$i]} ]]; then
            indx=$[$i+1]
        fi
        i=$[$i+1]
    done
}
checkday()
{
    day="0"
    if [[ $2 == "Jan" || $2 == "Mar" || $2 == "May" || $2 == "Jul" || $2 == "Aug" || $2 == "Oct" || $2 == "Dec" ]]; then
        if [[ $1 -gt 31 || $1 -lt 1 ]]; then
            day="0"
        else
            day="1"
        fi
    else
        if [[ $2 == "Apr" || $2 == "Jun" || $2 == "Sep" || $2 == "Nov" ]]; then
            if [[ $1 -gt 30 || $1 -lt 1 ]]; then
                day="0"
            else 
                day="1"
            fi
        else
            if [[ $2 == "Feb" ]]; then
                if [[ $1 -gt 29 || $1 -lt 1 ]]; then 
                    day="0"
                else
                    if [[ $1 == 29 ]]; then
                        if [[ $leap == 1 ]]; then
                            day="1"
                        else
                            day="0"
                        fi
                    else
                        day="1"
                    fi
                fi
            fi
        fi
    fi
}
val="0"
validity()
{  
    val="0"
    checkleap $3
    checkmonth $1
    checkday $2 $1
    if [[ $3 -lt 0 || $indx == 0 || $day == 0 ]]; then
        echo "Invalid Date"
        val="0"
    else
        val="1"
    fi
}
prsyr=$(echo "$(date)" | rev | awk '{print $1}' | rev)
prmn=$(echo "$(date)" | awk '{print $2}')
prsdt=$(echo "$(date)" | awk '{print $3}')
prsmt="0"
if [[ $prmn == "Jan" ]]; then
    prsmt=1
else
    if [[ $prmn == "Feb" ]]; then
        prsmt=2
    else
        if [[ $prmn == "Mar" ]]; then
            prsmt=3
        else
            if [[ $prmn == "Apr" ]]; then
                prsmt=4
            else
                if [[ $prmn == "May" ]]; then
                    prsmt=5
                else
                    if [[ $prmn == "Jun" ]]; then
                        prsmt=6
                    else
                        if [[ $prmn == "Jul" ]]; then
                            prsmt=7
                        else
                            if [[ $prmn == "Aug" ]]; then
                                prsmt=8
                            else
                                if [[ $prmn == "Sep" ]]; then
                                    prsmt=9
                                else
                                    if [[ $prmn == "Oct" ]]; then
                                        prsmt=10
                                    else
                                        if [[ $prmn == "Nov" ]]; then
                                            prsmt=11
                                        else
                                            if [[ $prmn == "Dec" ]]; then
                                                prsmt=12
                                            fi
                                        fi
                                    fi
                                fi
                            fi
                        fi
                    fi
                fi
            fi
        fi
    fi
fi
fdate="0"
fmonth="0"
fyear="0"
finalcomps()
{
    fdate="0"
    fmonth="0"
    fyear="0"
    if [[ $3 == *":"* ]]; then
        if [[ $1 -gt $prsmt ]]; then
            fyear=$[$prsyr - 1]
            fmonth=$1
            fdate=$2
        else
            if [[ $1 == $prsmt && $2 -gt $prsdt ]]; then
                fyear=$[$prsyr - 1]
                fmonth=$1
                fdate=$2
            else
                fyear=$prsyr
                fmonth=$1
                fdate=$2
            fi
        fi
    else
        fyear=$3
        fmonth=$1
        fdate=$2
    fi
}
cd ~
ls -LR > finding
findpr="0"
pth=""
if [[ "$1" == "home" ]]; then
    pth="/$1"
    findpr="1"
else
    if [[ "$1" == "$USER" ]]; then
        pth="/home/$1"
        findpr="1"
    else
        while IFS='' read -r line || [[ -n "$line" ]]; do
            if [[ $line == .* ]]; then
                temp=$(echo "$line" | rev | cut -d/ -f 1 | rev)
                ttemp=$(echo "$temp" | cut -d':' -f 1)
                if [[ "$ttemp" == "$1" ]]; then
                    findpr="1"
                    pth=$(echo "$line" | cut -d':' -f 1)
                fi
            fi
        done < finding
    fi
fi
rm finding
if [[ $findpr == "0" ]]; then
    echo "The directory $folder doesnot exist"
    exit
else
    validity $2 $3 $4
    if [[ $val == 1 ]]; then
        cd ~
        cd "$pth"
        ls -lR > list
        if [[ $(ls | grep -w "archive-date" | wc -l) == 0 ]]; then
            mkdir archive-date
        fi
        ttmonth=""
        tmonth="0"
        tyear=""
        tdate="0"
        start=""
        while IFS='' read -r line || [[ -n "$line" ]]; do
            if [[ $line == .* ]]; then
                start="$(echo "$line" | cut -d':' -f 1)"
            else
                if [[ $line == -* ]]; then
                    ttmonth=$(echo "$line" | awk '{print $6}')
                    checkmonth $ttmonth
                    tmonth=$indx
                    tdate=$(echo "$line" | awk '{print $7}')
                    tyear=$(echo "$line" | awk '{print $8}')
                    finalcomps $tmonth $tdate $tyear
                    ccmonth=$2
                    checkmonth $ccmonth
                    cmonth=$indx
                    cdate=$3
                    cyear=$4
                    fname="$(echo "$line" | awk '$1=$1' | cut -d' ' -f 9-)"
                    moving="$start/$fname"     
                    if [[ "$fname" == "list" ]]; then
                        ff=""
                    else
                        if [[ "$fyear" -lt "$cyear" ]]; then
                            mv "$moving" archive-date 2>/dev/null
                        else 
                            if [[ "$fyear" == "$cyear" ]]; then
                                if [[ "$fmonth" -lt "$cmonth" ]]; then
                                    mv "$moving" archive-date 2>/dev/null
                                else
                                    if [[ "$fmonth" == "$cmonth" ]]; then
                                        if [[ "$fdate" -lt "$cdate" ]]; then
                                            mv "$moving" archive-date 2>/dev/null
                                        fi
                                    fi
                                fi
                            fi
                        fi
                    fi
                fi
            fi
        done < list
        rm list
    fi
fi
