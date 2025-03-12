#!/bin/bash

cat << "EOF"

      _._     _,-'""`-._
     (,-.`._,'(       |\`-/|
         `-.-' \ )-`( , o o)
               `-    \`_`"'- 
		@cateyes
		
Example: ./scan_network.sh 192.168.0.1/24		

EOF

ip_cidr=$1
ip="${ip_cidr%%/*}"
mask_bits="${ip_cidr##*/}"
IFS="." read -r oct1 oct2 oct3 oct4 <<< "$ip"

validate_ip() {
	 
	
	if [[ ! "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
		return 1
	fi
	
	
	for octet in $oct1 $oct2 $oct3 $oct4; do
		if ((octet < 0 || octet > 254)); then
			return 1
		fi
	done
	
	
	if ! [[ "$mask_bits" =~ ^[0-9]+$ ]] || ((mask_bits < 0 || mask_bits > 31)); then
		return 1
	fi

	return 0;
}

host_number(){
	local host_bits=$((32 - mask_bits)) 
	if ((host_bits <= 0)); then
		return 1;
	fi
	local host_number=$(( (2 ** host_bits) - 2 ))
	echo "$host_number"
	
}

ping_network() {

    if (( mask_bits >= 24 )); then
        local hosts=$(host_number)
        for (( i=1; i<=$hosts; i++ )); do
            local target="$oct1.$oct2.$oct3.$i"
            ping -c 1 $target | grep -i "ttl" | awk '{print $4}' | sed "s/://g" &
        done

    elif (( mask_bits >= 16 && mask_bits < 24 )); then
        local hosts=$(( (2**(mask_bits % 8)) ))
        for (( i=0; i<=$hosts; i++ )); do
            for (( j=1; j<=254; j++ )); do
                local target="$oct1.$oct2.$i.$j"
                ping -c 1 $target | grep -i "ttl" | awk '{print $4}' | sed "s/://g" &
            done
        done

    elif (( mask_bits >= 8 && mask_bits < 16 )); then
        local hosts=$(( (2**(mask_bits % 8)) ))
        for (( i=0; i<=$hosts; i++ )); do
            for (( j=0; j<=255; j++ )); do
                for (( k=1; k<=254; k++ )); do
                    local target="$oct1.$i.$j.$k"
                    ping -c 1 $target | grep -i "ttl" | awk '{print $4}' | sed "s/://g" &
                done
            done
        done

else 
    local bits=(128 64 32 16 8 4 2 1)

    if (( mask_bits < 8 )); then
        for (( x=0; x<mask_bits; x++ )); do 
            for (( i=0; i<=mask_bits; i=${bits[x]} )); do
                for (( j=0; j<=255; j++ )); do
                    for (( k=0; k<=255; k++ )); do
                        for (( l=1; l<=254; l++ )); do
                            local target="$i.$j.$k.$l"
                            ping -c 1 $target | grep -i "ttl" | awk '{print $4}' | sed "s/://g" &
                        done
                    done
                done
            done
        done
    fi

    wait  
fi
 
}


main() {

	if validate_ip; then 
		echo "---------------- HOSTS UP -----------------"  
		echo "$(ping_network)"
	else 
		echo "invalid IP format! Example: 192.168.0.1/24"
	fi

}

main


