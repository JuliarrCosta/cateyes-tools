# cateyes-tools

Based in Classless Addressing with support to Classful.

#### Methods 

| Method        | Description                                                           |
| ------------- | --------------------------------------------------------------------- |
| validate_ip() | Verify ip address format, valid mask and octet.                       |
| host_number   | Calculate host number                                                 |
| ping_network  | Ping all host in the network using the concept of CIDR in all octets. |

#### Example Test

![[Test.png]]

#### Features

-> Ping multiple hosts
-> Status report
-> Using CIDR concept 
-> Support for various networks

#### Installation 

` git clone https://github.com/JuliarrCosta/cateyes-tools.git`

`cd scan_network`

 `chmod +x scan_network.sh `

`./scan_network.sh <IP/MASK>`

Enjoy! 😀
