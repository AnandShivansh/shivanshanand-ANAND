if [[ $# -ne 1 ]]; then
    echo "Enter Only one argument i.e. <foldername>"
    exit
fi
cd ~
ls -lR > finding
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
if [[ "$findpr" == "0" ]]; then
    echo "The Folder $1 is not present"
    exit
else
    cd "$pth"
    ls -lRS > list
    maxsize="0"
    name=""
    #f="0"
    while IFS='' read -r line || [[ -n "$line" ]]; do
        if [[ $line == .* ]]; then
            f="0"
        else 
            if [[ $f == 0 ]]; then
                if [[ $line == -* ]]; then
                    f="1"
                    temp=$(echo "$line" | rev | awk '{print $5}' | rev)
                    if [[ "$temp" -gt "$maxsize" ]]; then
                        maxsize=$temp
                        name=$(echo "$line" | rev | awk '{print $1}' | rev)
                    fi
                fi
            fi
        fi
    done < list
    echo $name
fi
