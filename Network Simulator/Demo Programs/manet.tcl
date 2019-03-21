# ======================================================================
# Define options
# ======================================================================
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             20                          ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol

# ======================================================================
# Main Program
# ======================================================================


#
# Initialize Global Variables
#
set ns_		[new Simulator]

set tracefd     [open manet.tr w]
$ns_ trace-all $tracefd

set namtrace [open manet.nam w]
$ns_ namtrace-all-wireless $namtrace 500 500

# set up topography object
set topo       [new Topography]

$topo load_flatgrid 500 500

#
# Create God
#
set god_ [create-god $val(nn)]

#
#  Create the specified number of mobilenodes [$val(nn)] and "attach" them
#  to the channel. 
#  Here two nodes are created : node(0) and node(1)

# configure node

        $ns_ node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
			 -phyType $val(netif) \
			 -channelType $val(chan) \
			 -topoInstance $topo \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace OFF \
			 -movementTrace OFF			
			 
	for {set i 0} {$i < $val(nn) } {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 0		;# disable random motion
		$ns_ initial_node_pos $node_($i) 25             ;# set size of nodes
		
	}

#
# Provide initial (X,Y, for now Z=0) co-ordinates for mobilenodes
#
$node_(0) set X_ 1.0
$node_(0) set Y_ 1.0
$node_(1) set X_ 50.0
$node_(1) set Y_ 50.0
$node_(2) set X_ 100.0
$node_(2) set Y_ 100.0


source "scen-20-test"
#
# Now produce some simple node movements
# Node_(0) starts to move towards X=25.0, Y=25.0 with speed 10m/s
#
$ns_ at 0.1 "$node_(0) setdest 25.0 25.0 15.0"
$ns_ at 0.2 "$node_(1) setdest 100.0 100.0 15.0"
$ns_ at 0.3 "$node_(2) setdest 250.0 250.0 15.0"

# Setup traffic flow between nodes
# TCP connections between node_(0) and node_(4)

set tcp1 [new Agent/TCP/Reno]
$tcp1 set class_ 2
set sink1 [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp1
$ns_ attach-agent $node_(2) $sink1
$ns_ connect $tcp1 $sink1
set ftp [new Application/FTP]
$ftp attach-agent $tcp1
$ns_ at 0.1 "$ftp start" 
$ns_ at 100.1 "$ftp stop"

#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 150.0 "$node_($i) reset";
}
$ns_ at 150.0 "stop"
$ns_ at 150.01 "puts \"NS EXITING...\" ; $ns_ halt"

proc stop {} {
    global ns_ tracefd namtrace 
    $ns_ flush-trace
    close $tracefd
    close $namtrace
    exec nam manet.nam & exit 0
}

##################################################
## Obtain CWND from TCP agent
##################################################

proc plotWindow {tcpSource outfile} {
   global ns_

   set now [$ns_ now]
   set cwnd [$tcpSource set cwnd_]

###Print TIME CWND   for  gnuplot to plot progressing on CWND   
   puts  $outfile  "$now $cwnd"

   $ns_ at [expr $now+0.1] "plotWindow $tcpSource  $outfile"
}

set outfile [open  "WindowFile"  w]


$ns_  at  0.0  "plotWindow $tcp1  $outfile"


puts "Starting Simulation..."
$ns_ run

