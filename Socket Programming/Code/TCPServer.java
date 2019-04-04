import java.io.*; 
import java.net.*; 

class TCPServer {
	public static void main(String argv[]) throws Exception { 
	String clientSentence;
	String capitalizedSentence;
	
	ServerSocket welcomeSocket = null;


	try { 
         welcomeSocket = new ServerSocket(5678); //Server socket created at port 5678 
         System.out.println ("Connection Socket Created");
         try { 
              while (true)	//Infintie loop to accept connection from the client
                 {
                  welcomeSocket.setSoTimeout(10000);
                  System.out.println ("Waiting for Connection");
                  try {
                       Socket connectionSocket = welcomeSocket.accept(); 
			BufferedReader inFromClient = new BufferedReader(new	InputStreamReader(connectionSocket.getInputStream())); 
			DataOutputStream outToClient = new DataOutputStream(connectionSocket.getOutputStream());
			clientSentence = inFromClient.readLine(); //Reading from Client
			capitalizedSentence = clientSentence.toUpperCase() + '\n'; //Converting to uppercase
			outToClient.writeBytes(capitalizedSentence); //Writing to Client 
                      }
                  catch (SocketTimeoutException ste)
                      {
                       System.out.println ("Timeout Occurred");
                      }
                 }
             } 
         catch (IOException e) 
             { 
              System.err.println("Accept failed."); 
              System.exit(1); 
             } 
        } 
    catch (IOException e) 
        { 
         System.err.println("Could not listen on port: 5678."); 
         System.exit(1); 
        }


	
/*	while(true) {	//Infintie loop to accept connection from the client
		System.out.println ("Server Socket Created");
		Socket connectionSocket = welcomeSocket.accept(); 
		BufferedReader inFromClient = new BufferedReader(new	InputStreamReader(connectionSocket.getInputStream())); 
	
		DataOutputStream outToClient = new DataOutputStream(connectionSocket.getOutputStream());
		clientSentence = inFromClient.readLine(); //Reading from Client
		capitalizedSentence = clientSentence.toUpperCase() + '\n'; //Converting to uppercase
		outToClient.writeBytes(capitalizedSentence); //Writing to Client
    	} */
    }
}
