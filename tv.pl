#!/usr/bin/perl

use CGI qw(:standard);
use IO::Socket;
use MIME::Base64;

#IP Address of TV
my $tvip = "192.168.1.37";

#print "Content-type: text/html\n\n";

my $sock = new IO::Socket::INET (
 PeerAddr => $tvip, 
 PeerPort => '55000', 
 Proto => 'tcp', 
); 
die "Could not create socket: $!\n" unless $sock; 

#Normal remote keys
#KEY_0
#KEY_1
#KEY_2
#KEY_3
#KEY_4
#KEY_5
#KEY_6
#KEY_7
#KEY_8
#KEY_9
#KEY_UP
#KEY_DOWN
#KEY_LEFT
#KEY_RIGHT
#KEY_MENU
#KEY_PRECH
#KEY_GUIDE
#KEY_INFO
#KEY_RETURN
#KEY_CH_LIST
#KEY_EXIT
#KEY_ENTER
#KEY_SOURCE
#KEY_AD
#KEY_PLAY
#KEY_PAUSE
#KEY_MUTE
#KEY_PICTURE_SIZE
#KEY_VOLUP
#KEY_VOLDOWN
#KEY_TOOLS
#KEY_POWEROFF
#KEY_CHUP
#KEY_CHDOWN
#KEY_CONTENTS
#KEY_W_LINK #Media P
#KEY_RSS #Internet
#KEY_MTS #Dual
#KEY_CAPTION #Subt
#KEY_REWIND
#KEY_FF
#KEY_REC
#KEY_STOP

#Bonus buttons not on the normal remote:
#KEY_TV

#Don't work/wrong codes:
#KEY_CONTENT
#KEY_INTERNET
#KEY_PC
#KEY_HDMI1
#KEY_OFF
#KEY_POWER
#KEY_STANDBY
#KEY_DUAL
#KEY_SUBT
#KEY_CHANUP
#KEY_CHAN_UP
#KEY_PROGUP
#KEY_PROG_UP

my $myip = "192.168.1.226"; #Doesn't seem to be really used
my $mymac = "00-0C-29-FB-B9-69"; #Used for the access control/validation, but not after that AFAIK
my $appstring = "iphone..iapp.samsung"; #What the iPhone app reports
my $tvappstring = "iphone.UE32D5500.iapp.samsung"; #Might need changing to match your TV type
my $remotename = "Siri Samsung Remote"; #What gets reported when it asks for permission/also shows in General->Wireless Remote Control menu

my $messagepart1 = chr(0x64) . chr(0x00) . chr(length(encode_base64($myip, ""))) . chr(0x00) . encode_base64($myip, "") . chr(length(encode_base64($mymac, ""))) . chr(0x00) . encode_base64($mymac, "") . chr(length(encode_base64($remotename, ""))) . chr(0x00) . encode_base64($remotename, "");
my $part1 = chr(0x00) . chr(length($appstring)) . chr(0x00) . $appstring . chr(length($messagepart1)) . chr(0x00) . $messagepart1;

print $sock $part1;
#print $part1;
#print "\n";

my $messagepart2 = chr(0xc8) . chr(0x00);
my $part2 = chr(0x00) . chr(length($appstring)) . chr(0x00) . $appstring . chr(length($messagepart2)) . chr(0x00) . $messagepart2;
print $sock $part2;
#print $part2;
#print "\n";

#Preceding sections all first time only

if (defined(param("key"))) {
   #Send remote key
   my $key = "KEY_" . param("key");
   print $key."\n";
   my $messagepart3 = chr(0x00) . chr(0x00) . chr(0x00) . chr(length(encode_base64($key, ""))) . chr(0x00) . encode_base64($key, "");
   my $part3 = chr(0x00) . chr(length($tvappstring)) . chr(0x00) . $tvappstring . chr(length($messagepart3)) . chr(0x00) . $messagepart3;
   print $sock $part3;
   #print $part3;
   #print "\n";
} elsif (defined(param("text"))) {
   #Send text, e.g. in YouTube app's search, N.B. NOT BBC iPlayer app.
   my $text = param("text");
   my $messagepart3 = chr(0x01) . chr(0x00) . chr(length(encode_base64($text, ""))) . chr(0x00) . encode_base64($text, "");
   my $part3 = chr(0x01) . chr(length($appstring)) . chr(0x00) . $appstring . chr(length($messagepart3)) . chr(0x00) . $messagepart3;
   print $sock $part3;
   #print $part3;
   #print "\n";   
}

#print "Closing off";

close($sock);

#print "\n\n";
