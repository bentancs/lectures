import java.io.*;
import java.net.*;

public class Lookup {
	public static void main(String[] args) {
		String hostname = "vanderbilt.edu"; 
		try { 

  			InetAddress a = InetAddress.getByName(hostname);
 			System.out.println(hostname + ":" + a.getHostAddress()); 

			InetAddress b = InetAddress.getLocalHost();
			System.out.println("Local Host:" + b.getHostAddress());
	

		} catch (UnknownHostException e) {

  			System.out.println("No address found for " + hostname); 

		} 
	}
}
