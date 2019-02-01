#Creating a Simulator Object
set ns [new Simulator]

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

#Creating two nodes 
set n0 [$ns node]
set n1 [$ns node]

#Creating links (topology) between two nodes 
$ns duplex-link $n0 $n1 1Mb 10ms DropTail

#Create a TCP agent and attach it to node n0  
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

#Create a TCP sink and attach to node 1
set sink0 [new Agent/TCPSink]
$ns attach-agent $n1 $sink0

#Connect the traffic sources with the traffic sinks
$ns connect $tcp0 $sink0 

#Create FTP application and attach it to agents 
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0 

#Start and stop ftp 
$ns at 0.5 "$ftp0 start"
$ns at 10.0 "$ftp0 stop"

#Call the finish procedure after 10.1 seconds of simulation time
$ns at 10.1 "finish"

#Run the simulation
$ns run
