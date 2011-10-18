import processing.opengl.*;

// slow bluetooth
// confirm that controls are always working

import processing.serial.*;
import controlP5.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

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

int mode_realtime = int(4);
boolean lights_on = false;

// Serial port object
Serial myPort;
boolean serial_connected = false;

// Interface control objects
    ControlP5 controlP5;
    RadioButton on_radio_button;
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

    // slider range
    int slider_range = 1000;

// audio freq analysis variables 
    float freq_band_mult_init = 2.5;
    int setup_band_freq_init = 20;
//    float freq_amplitude_range_init =150f;
    float [] freq_amp_offset_init = {1f,1f,1f,3f,5f,8f,14f,20f};
    Freq_Bands freq_bands_obj;
    Display_Box display_box_obj;


void setup () {
     // set the window size:
    size(900,350);
    background(0);
    
    serial_connected = connect_serial("/dev/tty.BlueJulio-M1");
//    serial_connected = connect_serial("/dev/tty.usbserial-A");

    init_interface();

    freq_bands_obj = new Freq_Bands(this,setup_band_freq_init, freq_band_mult_init);
    freq_bands_obj.init_freq_bands_amp_offset(freq_amp_offset_init);
    
    display_box_obj = new Display_Box(this, freq_bands_obj);    
    display_box_obj.init_size(600, 250);    
    display_box_obj.init_pos(100, 140);
    
    freq_bands_obj.init_connect_display_link(display_box_obj);
    
    if (serial_connected) myPort.write(STATUS_MSG);
}

void draw () {
    display_box_obj.display_box();
    
    if(interaction_mode == 4) {
        ArrayList<Byte> realtime_msg = freq_bands_obj.calculate_bands_amplitude();  
        send_serial_msg_arraylist(MODE_MSG_realtime, realtime_msg);
    }
    else if(interaction_mode == 5) {
        freq_bands_obj.calculate_bands_amplitude();  
    }
}

void stop () {
  println("getting ready to close shop.");
  if (serial_connected) {
      myPort.stop();  
      println("closed serial.");
  }
  freq_bands_obj.stop();
  println("closed minim.");
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

void keyPressed() {
    freq_bands_obj.toggle_realtime_mode();
}

