if [[ "$#" -ne 2 ]]; then
    echo "Enter Only 2 aguments i.e. <N(number of memory consuming applications to find)><space><x(time in seconds to update the applications running)>"
    exit
fi
i="0"
crop=$[$1 + 7]
while [[ "$i" == 0 ]]; do
    top -o %MEM -b | head -$crop | tail -$1 | awk -F' ' '{print $12}'
    echo 
    echo
    sleep $2
done

