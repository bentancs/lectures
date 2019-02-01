#Creating a Simulator Object
set ns [new Simulator]

#Tell the simulator to use dynamic routing
#$ns rtproto DV

#Setting up files for trace & NAM
set trace_nam [open out.nam w]
set trace_all [open all.tr w]

#Tracing files using their commands
$ns namtrace-all $trace_nam
$ns trace-all $trace_all

#Closing trace file and starting NAM
proc finish { } {
	global ns trace_nam trace_all 
	$ns flush-trace
	close $trace_nam  
	close $trace_all
	exec nam out.nam & 
	exit 0 
}

#Creating seven nodes
for {set i 0} {$i < 7} {incr i} {
       	set n($i) [$ns node]
}


#Create links between the nodes
for {set i 0} {$i < 7} {incr i} {
       	$ns duplex-link $n($i) $n([expr ($i+1)%7]) 1Mb 10ms DropTail
}

#Create a UDP agent and attach it to node n(0)
set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0

#Create a CBR traffic source and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

#Create a Null agent (a traffic sink) and attach it to node n(3)
set null0 [new Agent/Null]
$ns attach-agent $n(3) $null0

#Connect the traffic source with the traffic sink
$ns connect $udp0 $null0 

  
#Schedule events for the CBR agent and the network dynamics
$ns at 0.5 "$cbr0 start"
$ns rtmodel-at 1.0 down $n(1) $n(2)
$ns rtmodel-at 2.0 up $n(1) $n(2)
$ns at 4.5 "$cbr0 stop"

#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"

#Run the simulation
$ns run
