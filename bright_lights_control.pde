// slow bluetooth
// confirm that controls are always working

import processing.serial.*;
import controlP5.*;

// CONSTANTS: message syntax constants
byte MSG_END =           byte(128);

// CONSTANTS: receiving message header constants
byte CONNECT_CONFIRM =   byte(255);              
byte STATUS_MSG =        byte(254);              
byte MODE_MSG_realtime = byte(253);
byte MODE_MSG_off =      byte(252);
byte SET_MSG_hsb =       byte(129);
byte MODE_MSG_color_hsb = byte(192);
byte MODE_MSG_scroll =   byte(193);
byte MODE_MSG_strobe =   byte(194);

// Serial port object
Serial myPort;

// Interface control objects
ControlP5 controlP5;
RadioButton mode_radio_button;
RadioButton scroll_radio_button;

// Interface state message variables
    int interaction_mode = 0;
    
    // holds hsb values and previous hsb values
    int hsb_msg[] = {0,0,0};
    int previous_hsb_msg[] = {0,0,0};
    
    // holds hsb values and previous hsb values
    int scroll_msg[] = {4,0,0};
    int previous_scroll_msg[] = {0,0,0};

    // holds hsb values and previous hsb values
    int strobe_msg[] = {0};
    int previous_strobe_msg[] = {0};

// test variables
 int msg_count_input = 0;
 byte new_msg_input [] = new byte [3];
 boolean new_msg_input_flag = false;
 long last_switch;
 long switch_interval = 30;
 boolean on_now = false;



void setup () {
     // set the window size:
    size(400,400);
    connect_serial("/dev/tty.BlueJulio-M1");
//    connect_serial("/dev/tty.usbserial-A");
    init_interface();
    
    last_switch = millis();
    background(0);

    myPort.write(STATUS_MSG);
    
}

void draw () {
  
}

void stop () {
  myPort.stop();  
  super.stop();  
}

boolean connection_established = false;
boolean reading_msg_flag = false;
byte msg_type = 0;
ArrayList<Byte> msg_body;

void serialEvent(Serial myPort) {
    connection_established = true;
    while (myPort.available() > 0) {
         byte new_byte = byte(myPort.read());
          
         if (new_byte == CONNECT_CONFIRM) {
             myPort.write(STATUS_MSG);
             msg_body = new ArrayList<Byte>();
             println("\nstatus requested");
         } 

         if (connection_established) {
             print(int(new_byte) + ", ");
             read_serial_bytes(new_byte);
         }
     }
}

