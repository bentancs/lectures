#Make a NS simulator 
set ns [new Simulator]        

#Setting up files for trace & NAM
set trace_nam [open out.nam w]
#set trace_all [open all.tr w]   

# Open the TCP trace file
set par [open param.tr w]

#Tracing files using their commands
$ns namtrace-all $trace_nam
#$ns trace-all $trace_all

$ns trace-all $par
#Closing trace file and starting NAM
proc finish { } {
	global ns trace_nam par
	$ns flush-trace
	close $trace_nam  
	#close $trace_all
	close $par
	exec nam out.nam & 
	exit 0 
}

# Create the nodes:
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]


# Create the links:
$ns duplex-link $n0 $n1   100Mb  50ms DropTail
$ns duplex-link $n1 $n2   100Kb  1ms DropTail


# ########################################################
# Set Queue Size of link (n1-n2) to 10 (default is 50 ?)
#$ns queue-limit $n1 $n2 10


# Add a TCP sending module to node n0
set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1

# ########################################################
$tcp1 set window_ 5000
$tcp1 set packetSize_ 500


# Add a TCP receiving module to node n4
set sink1 [new Agent/TCPSink]
$ns attach-agent $n2 $sink1

# Direct traffic from "tcp1" to "sink1"
$ns connect $tcp1 $sink1

# Setup a FTP traffic generator on "tcp1"
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP         

#trace the tcp parameters
$tcp1 attach $par
$tcp1 trace cwnd_
$tcp1 trace ssthreshold_
$tcp1 trace maxseq_
$tcp1 trace rtt_
$tcp1 trace dupacks_
$tcp1 trace ack_
$tcp1 trace ndatabytes_
$tcp1 trace ndatapack_
$tcp1 trace nrexmit_
$tcp1 trace nrexmitpack_  
      

# Schedule start/stop times
$ns at 0.1   "$ftp1 start"
$ns at 50.1 "$ftp1 stop"

# Set simulation end time
$ns at 50.5 "finish"            


##################################################
## Another way to obtain CWND from TCP agent: Trace the value of CWND in very 0.1s and write to WindowFile 
##################################################

proc plotWindow {tcpSource outfile} {
   global ns

   set now [$ns now]
   set cwnd [$tcpSource set cwnd_]

###Print TIME CWND   for  gnuplot to plot progressing on CWND   
   puts  $outfile  "$now $cwnd"

   $ns at [expr $now+0.1] "plotWindow $tcpSource  $outfile"
}

set outfile [open  "WindowFile"  w]


$ns  at  0.0  "plotWindow $tcp1  $outfile"



# Run simulation !!!!
$ns run
