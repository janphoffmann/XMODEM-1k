# XMODEM-1k
XMODEM CRC 1k implementation for Matlab

These are a simple XMODEM transceiver functions

For Transmitting File:
device=tcpserver("127.0.0.1",23);
//or: device=serial(COM1,96200);
file="C\fileToSend.txt";
XmodemTransmit(device,file);

For Receiving File:
device=tcpserver("127.0.0.1",23);
//or: device=serial(COM1,96200);
file="C\fileReceive.txt";
XmodemReceive(device,file);
