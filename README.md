# XMODEM-1k
XMODEM CRC 1k implementation for Matlab

These are a simple XMODEM transceiver functions<br/>
<br/>
For Transmitting File:<br/>
device=tcpserver("127.0.0.1",23);<br/>
//or: device=serial(COM1,96200);<br/>
file="C\fileToSend.txt";<br/>
XmodemTransmit(device,file);<br/>
<br/>
For Receiving File:<br/>
device=tcpserver("127.0.0.1",23);<br/>
//or: device=serial(COM1,96200);<br/>
file="C\fileReceive.txt";<br/>
XmodemReceive(device,file);<br/>
