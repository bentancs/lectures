import java.io.*;
import java.net.*;

class TCPClient {
	public static void main(String argv[]) throws Exception {
		String sentence;
		String modifiedSentence;

		BufferedReader inFromUser = new BufferedReader(new InputStreamReader(System.in));

		Socket clientSocket = new Socket("127.0.0.1", 5678);

		System.out.println ("Client Socket Created");

		DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
		
		BufferedReader inFromServer = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));

		System.out.print("Echo: ");

		sentence = inFromUser.readLine(); //Reading from Keyboard

		outToServer.writeBytes(sentence + '\n'); //Writing to server

		modifiedSentence = inFromServer.readLine(); //Reading from Server

		System.out.println("FROM SERVER: " + modifiedSentence); //Printing
		
		clientSocket.close();	//Close the connection
	}
} 
		
