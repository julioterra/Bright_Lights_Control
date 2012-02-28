import processing.core.PApplet;
import java.util.HashMap;
import java.util.ArrayList;
import java.lang.Number;

public class Bright_Controller extends Bright_Element {
  
    int interaction_mode = 0;
    boolean lights_on = false;
    int slider_range = 1000;
    final int MODE_REALTIME = 4;
    int realtime_mode = 1;
    int realtime_mode_total = 2;
    
    float hsb_base[] = new float[3];
	
    // holds hsb values and previous hsb values
    int hsb_msg[] = {0,0,0};
    int previous_hsb_msg[] = {0,0,0};
    
    // holds hsb values and previous hsb values
    int scroll_msg[] = {4,0,0};
    int previous_scroll_msg[] = {0,0,0};
  
    // holds hsb values and previous hsb values
    int strobe_msg[] = {0};
    int previous_strobe_msg[] = {0};

    User_Interface_Input user_interface;
    Physical_Devices_Output physical_output;
    Display_Box display_box;
    Freq_Bands_Input freq_bands;
    ArrayList<Float> freq_bands_amp = new ArrayList<Float>();
    
    HashMap<String, Physical_Devices_Output>  outputs;

    Bright_Controller (User_Interface_Input _user_interface) {
        user_interface = _user_interface;
        outputs = new HashMap<String, Physical_Devices_Output>();
		// debug_code = false;
    }  

    //////////////
    // join all the ouput registration methods into a single one with a HashKey and names
    void register_physical_output(Physical_Devices_Output _physical_output) {
        physical_output = _physical_output;
    }

    void register_display_output(Display_Box _display_box) {
        display_box = _display_box;
    }

	// void register_ouput(BL_Ouput new_output, BL_Model new_model) {
	// 	
	// }

	// void register_input(BL_Ouput new_input, BL_Model new_model) {
	// 	
	// }


    //////////////
    // join all the input registration methods into a single one with a HashKey and names
    void register_input(Freq_Bands_Input _freq_bands) {
        freq_bands = _freq_bands;
    }

	int get_interaction_mode() {
		return interaction_mode;
	}
	
	boolean is_on() {
		return lights_on;
	}

	void draw() {
		display_box.display_box();        

        if(interaction_mode >= MODE_REALTIME) {
            freq_bands_amp = freq_bands.get_realtime_data(); 
			if (is_on()) {
	            physical_output.send_serial_msg_arraylist(MODE_MSG_realtime, get_realtime_physical());
			}
 			display_box.display_realtime_freq_bands(get_realtime_display());
        }
	}

	void stop() {
	  physical_output.stop();  
      freq_bands.stop();
      processing_app.println("closed minim.");
	}

    //////////////////////////////////////////////////////
    // methods that handle input from the SERIAL INTERFACE
    //////////////////////////////////////////////////////

    void parse_serial_msg(byte _msg_type, ArrayList<Byte> _msg_body) {
    
        // this is a status message and the size is 21 without the header byte
        if (false) {
    //    if (_msg_type == STATUS_MSG && _msg_body.size() >= 20 && interaction_mode != MODE_REALTIME) {
            int current_index = 0;
            byte[] temp_bytes = {0,0,0};
    
    
            processing_app.println("first element " + _msg_body.get(current_index));
            // set the first element in array to set mode_radio_button
            user_interface.mode_radio_button.activate((int)(_msg_body.get(current_index)));
            current_index++;
    
            for (int i = 0; i < 3; i++) {
                temp_bytes[i] = _msg_body.get(current_index);  
                current_index++;
            } 
            user_interface.controlP5.controller("hue_slider").setValue(bytes2int_127(temp_bytes));
    
            for (int i = 0; i < 3; i++) {
                temp_bytes[i] = _msg_body.get(current_index);  
                current_index++;
            } 
            user_interface.controlP5.controller("sat_slider").setValue(bytes2int_127(temp_bytes));
    
            for (int i = 0; i < 3; i++) {
                temp_bytes[i] = _msg_body.get(current_index);  
                current_index++;
            } 
            user_interface.controlP5.controller("bright_slider").setValue(bytes2int_127(temp_bytes));
    
            for (int i = 0; i < 3; i++) {
                temp_bytes[i] = _msg_body.get(current_index);  
                current_index++;
            } 
            user_interface.controlP5.controller("strobe_slider").setValue(bytes2int_127(temp_bytes));
    
            for (int i = 0; i < 3; i++) {
                temp_bytes[i] = _msg_body.get(current_index);  
                current_index++;
            } 
            user_interface.controlP5.controller("scroll_slider").setValue(bytes2int_127(temp_bytes));
    
            user_interface.scroll_radio_button.activate((int)(_msg_body.get(current_index)));
            current_index++;
    
            for (int i = 0; i < 3; i++) {
                temp_bytes[i] = _msg_body.get(current_index);  
                current_index++;
            } 
            user_interface.controlP5.controller("scroll_width_slider").setValue(bytes2int_127(temp_bytes));
        }    
    }



    //////////////////////////////////////////////////////
    // methods that handle input from the USER INTERFACE
    //////////////////////////////////////////////////////
  
    boolean check_array_state_change(int new_msg[], int old_msg[]) {
        for(int i = 0; i < new_msg.length; i++) {
            if(new_msg[i] != old_msg[i]) return true;
        } 
        return false;
    }
    
    int[] update_previous_array(int new_msg[], int old_msg[]) {
        for(int i = 0; i < new_msg.length; i++) {
            old_msg[i] = new_msg[i];
        } 
        return old_msg;
    }
    
    byte[] convert_array_int_to_byte(int new_msg[]) {
        byte[] new_byte_msg = new byte[new_msg.length]; 
        for(int i = 0; i < new_msg.length; i++) {
            if (new_msg[i] > 127) new_byte_msg[i] = (byte)(127);
            if (new_msg[i] < 0) new_byte_msg[i] = (byte)(0);
            else new_byte_msg[i] = (byte)(new_msg[i]);  
        }
        return new_byte_msg;
    }
    
    byte[] convert_array_int_to_byte_full(int new_msg[]) {
        byte[] new_byte_msg = new byte[new_msg.length*3]; 
        for(int i = 0; i < new_msg.length; i++) {
            byte[] temp_byte_array = int2bytes_127(new_msg[i]);
            for (int j = 0; j < 3; j++) {
              int index_offset = i * 3;
              new_byte_msg[index_offset + j] = temp_byte_array[j];
            }
        }
        return new_byte_msg;
    }

    public void process_input(String id, float value) {
//       processing_app.println("EVENT RECEIVED BY CONTROLLER " + id + " value " + value);

      if (id.equals("onOffRadioButton")) {
          switch ((int)value) {
              case 0:  
                  lights_on = true;
                  break;
              case 1: 
                  lights_on = false;
                  physical_output.send_serial_msg(BL_Constants.MODE_MSG_off, convert_array_int_to_byte_full(hsb_msg));
                  break;
          }
      }
      else if (id.equals("modeRadioButton")) {
          interaction_mode = (int)value;
      }

      if (lights_on && (id.equals("onOffRadioButton") || id.equals("modeRadioButton"))) { 
          switch (interaction_mode) {
              case 0:  
                  physical_output.send_serial_msg(MODE_MSG_off, convert_array_int_to_byte_full(hsb_msg));
                  break;
              case 1:  
                  physical_output.send_serial_msg(MODE_MSG_color_hsb, convert_array_int_to_byte_full(hsb_msg));
                  break;
              case 2:
                  physical_output.send_serial_msg(MODE_MSG_strobe, convert_array_int_to_byte(strobe_msg));
                  break;
              case 3:
                  physical_output.send_serial_msg(MODE_MSG_scroll, convert_array_int_to_byte(scroll_msg));
                  break;
              case MODE_REALTIME:
                  byte empty_array[] = {(byte)(0), MSG_END};
                  physical_output.send_serial_msg(MODE_MSG_realtime, empty_array);
                  break;
              default:
                  break;
          }
      }

      // SCROLL RADIO BUTTON DATA
      // handle the data from mode selection radio buttons
      if (id.equals("scrollRadioButton")) {
            scroll_msg[1] = (int)value;
            display_box.set_scroll(127, scroll_msg[0], scroll_msg[1], scroll_msg[2]);
            if (interaction_mode == 3) {
                physical_output.send_serial_msg(MODE_MSG_scroll, convert_array_int_to_byte(scroll_msg));
                
            }
      }
            
      if (id.equals("hue_slider")) {
            hsb_msg[0] = (int)value;
            if (check_array_state_change(hsb_msg, previous_hsb_msg)) {
                set_base_color_hsb(slider_range, hsb_msg[0],hsb_msg[1],hsb_msg[2]);
                if (lights_on && interaction_mode != MODE_REALTIME) {
                processing_app.println("sending HSB msg");
                    previous_hsb_msg = update_previous_array(hsb_msg, previous_hsb_msg);
                    if (slider_range != 127) physical_output.send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte_full(hsb_msg));
                    else physical_output.send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte(hsb_msg));
                }
            }
        }

        else if (id.equals("sat_slider")) {
            hsb_msg[1] = (int)value;
            if (check_array_state_change(hsb_msg, previous_hsb_msg)) {
                set_base_color_hsb(slider_range, hsb_msg[0],hsb_msg[1],hsb_msg[2]);
                if (lights_on && interaction_mode != MODE_REALTIME) {
                    previous_hsb_msg = update_previous_array(hsb_msg, previous_hsb_msg);
                    if (slider_range != 127) physical_output.send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte_full(hsb_msg));
                    else physical_output.send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte(hsb_msg));
                }
            }
        }

        else if (id.equals("bright_slider")) {
            hsb_msg[2] = (int)value;
            if (check_array_state_change(hsb_msg, previous_hsb_msg)) {
                set_base_color_hsb(slider_range, hsb_msg[0],hsb_msg[1],hsb_msg[2]);
                if (lights_on && interaction_mode != MODE_REALTIME) {
                    previous_hsb_msg = update_previous_array(hsb_msg, previous_hsb_msg);
                    if (slider_range != 127) physical_output.send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte_full(hsb_msg));
                    else physical_output.send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte(hsb_msg));
                }
            }
        }

        else if (id.equals("strobe_slider")) {
            strobe_msg[0] = (int)value;
            if (check_array_state_change(strobe_msg, previous_strobe_msg)) {
                if (lights_on && interaction_mode == 2) {
                    display_box.set_strobe(127, strobe_msg[0]);
                    previous_strobe_msg = update_previous_array(strobe_msg, previous_strobe_msg);
                    physical_output.send_serial_msg(MODE_MSG_strobe, convert_array_int_to_byte(strobe_msg));
                }
            }
        }

        else if (id.equals("scroll_slider")) {
            scroll_msg[0] = (int)value;
            if (check_array_state_change(scroll_msg, previous_scroll_msg)) {
                if (lights_on && interaction_mode == 3) {
                    display_box.set_scroll(127, scroll_msg[0], scroll_msg[1], scroll_msg[2]);
                    previous_scroll_msg = update_previous_array(scroll_msg, previous_scroll_msg);
                    physical_output.send_serial_msg(MODE_MSG_scroll, convert_array_int_to_byte(scroll_msg));
                }
            }
        }

        else if (id.equals("scroll_width_slider")) {
            scroll_msg[2] = (int)value;
            if (check_array_state_change(scroll_msg, previous_scroll_msg)) {
                if (lights_on && interaction_mode == 3) {
                    display_box.set_scroll(127, scroll_msg[0], scroll_msg[1], scroll_msg[2]);
                    previous_scroll_msg = update_previous_array(scroll_msg, previous_scroll_msg);
                    physical_output.send_serial_msg(MODE_MSG_scroll, convert_array_int_to_byte(scroll_msg));
                }
            }
        }
    }

    public void toggle_realtime_mode() {
      realtime_mode ++;
      if (realtime_mode >= realtime_mode_total) realtime_mode = 0;
    }

	int int2byte127_r8 = Integer.parseInt("00000000" + "00000000" + "01111111" + "00000000", 2);
	int int2byte127_r1 = Integer.parseInt("00000000" + "00000000" + "00000000" + "11111110", 2);
	int int2byte127_l7 = Integer.parseInt("00000000" + "00000000" + "00000000" + "00000001", 2);
	int[] int2byte127_convert926 = {int2byte127_r8, int2byte127_r1, int2byte127_l7};

    public byte[] int2bytes_127(int int_val) {
        byte[] byte_vals = {0,0,0};

		// use a binary "and" to encode the appropriate bits for each byte
        int int_0 = (int_val & int2byte127_convert926[0]); 
        int int_1 = (int_val & int2byte127_convert926[1]); 
        int int_2 = (int_val & int2byte127_convert926[2]); 

		if (debug_code) {
			processing_app.println("int2bytes_127: ORIGINAL " + int_val + " [in bytes "+ Integer.toBinaryString(int_val) + "]");
	        processing_app.println("int2bytes_127: processed ints " + int_0 + 
								   " " + int_1 + 
								   " " + int_2 +
								   " [in bits" + 
								   " " + Integer.toBinaryString(int_0) + 
								   " " + Integer.toBinaryString(int_1) + 
								   " " + Integer.toBinaryString(int_2) + "] " );
							}
			
		// bit-shift the bit-processed integers and convert to bytes
        byte_vals[0] = (byte)(int_0 >> 8); 
        byte_vals[1] = (byte)(int_1 >> 1);        
        byte_vals[2] = (byte)(int_2) ;       

		if (debug_code) {
	        processing_app.println("int2bytes_127: bytes " + (int)byte_vals[0] + 
								   " " + (int)byte_vals[1] + 
								   " " + (int)byte_vals[2] + 
								   " [in bits" + 
								   " " + Integer.toBinaryString((int)byte_vals[0]) + 
								   " " + Integer.toBinaryString((int)byte_vals[1]) + 
								   " " + Integer.toBinaryString((int)byte_vals[2]) + "]" );
			bytes2int_127(byte_vals);
		}
        return byte_vals;
    }
    
    public int bytes2int_127(byte[] byte_vals) {

		// assign the bytes to integer variables
		int int_bv_0 = (int)(byte_vals[0]);
		int int_bv_1 = (int)(byte_vals[1]);
		int int_bv_2 = (int)(byte_vals[2]);

		if (debug_code) {
    		processing_app.println("bytes2int_127: byte converted to ints " + int_bv_0 + 
						   " " + int_bv_1 + 
						   " " + int_bv_2  + 
						   " [in bits " +  Integer.toBinaryString(int_bv_0) + 
						   " " + Integer.toBinaryString(int_bv_1) + 
						   " " +  Integer.toBinaryString(int_bv_2) + "]");
					}
	
		// bit shift the value of the bytes
		int_bv_0 = int_bv_0 << 8;
		int_bv_1 = int_bv_1 << 1;
		int_bv_2 = int_bv_2;

		if (debug_code) {
		    processing_app.println("bytes2int_127: bytes shifted " + int_bv_0 + 
						" " + int_bv_1 + 
						" " + int_bv_2 +
			   		    " [in bits " +  Integer.toBinaryString(int_bv_0) + 
					    " " + Integer.toBinaryString(int_bv_1) + 
					    " " +  Integer.toBinaryString(int_bv_2) + "]");
				 }
	
		int new_int = int_bv_0 + int_bv_1 + int_bv_2;
	    processing_app.println("bytes2int_127: RESULT " + new_int + " [in bytes " + Integer.toBinaryString(new_int) + "]");
        return new_int;      

    }

	
	////////////////////////////////////
	////////////////////////////////////
	////////////////////////////////////
	////////////////////////////////////
	////////////////////////////////////
	// Freq_Band control functions
	////////////////////////////////////
	////////////////////////////////////
	////////////////////////////////////

    void set_base_color_hsb(float range, float h, float s, float b) {
        processing_app.colorMode(processing_app.HSB, 255);
        processing_app.println("set color - hsb range " + range + ": " + h + ", " + s  + ", " + b);
        hsb_base[0] = processing_app.map(h, 0f, range, 0f, 255f);
        hsb_base[1] = processing_app.map(s, 0f, range, 0f, 255f);
        hsb_base[2] = processing_app.map(b, 0f, range, 0f, 255f);
    }
	
	ArrayList<Byte> get_realtime_physical() {
      if (realtime_mode == 0) {
		processing_app.println("physical data: reatlime mode 0 ");
        return get_led_vals_amp2hue();
      }
      else {
		processing_app.println("physical data: reatlime mode 1 ");
        return get_led_vals_amp2bright(0);
      }
    }

	ArrayList<Byte> get_realtime_display() {
      if (realtime_mode == 0) {
		processing_app.println("display data: reatlime mode 0 ");
        return get_led_vals_amp2hue();
      }
      else {
		processing_app.println("display data: reatlime mode 1 ");
        return get_led_vals_amp2bright_sat(200, 35);
      }
    }

    
    ArrayList<Float> get_freq_bands_amplitude() {
      ArrayList<Float> freq_bands_float = new ArrayList<Float>();
      for (int i = 0; i < freq_bands_amp.size() ; i ++) {
        freq_bands_float.add(freq_bands_amp.get(i));
      }
      return freq_bands_float;
    }

    ArrayList<Byte> get_led_vals_amp2bright(int min_bright) {
      ArrayList<Byte> led_bytes = new ArrayList<Byte>();
      for (int i = 0; i < freq_bands_amp.size() ; i ++) {
        processing_app.colorMode(processing_app.HSB, 255);
        float _h = hsb_base[0]; 
        float _s = hsb_base[1]; 
        float _b = processing_app.map((hsb_base[2] * freq_bands_amp.get(i)), 0f, 255f, min_bright, 255f); 
        int temp_color = processing_app.color(_h, _s, _b );
  
        processing_app.colorMode(processing_app.RGB, 255);
        led_bytes.add((byte)(processing_app.map((temp_color >> 16 & 0xFF), 0, 255, 0, 127)));
        led_bytes.add((byte)(processing_app.map((temp_color >> 8 & 0xFF), 0, 255, 0, 127)));
        led_bytes.add((byte)(processing_app.map((temp_color & 0xFF), 0, 255, 0, 127)));
      }
      return led_bytes;
    }      

    ArrayList<Byte> get_led_vals_amp2bright_sat(int min_bright,int min_sat) {
      ArrayList<Byte> led_bytes = new ArrayList<Byte>();
      for (int i = 0; i < freq_bands_amp.size() ; i ++) {
        processing_app.colorMode(processing_app.HSB, 255, 255, 255);
        float _h = hsb_base[0]; 
        float _s = processing_app.map((hsb_base[1] * freq_bands_amp.get(i)), 0f, 255f, min_sat, 255f); 
        float _b = processing_app.map((hsb_base[2] * freq_bands_amp.get(i)), 0f, 255f, min_bright, 255f); 
        int temp_color = processing_app.color(_h, _s, _b);
		
        processing_app.colorMode(processing_app.RGB, 255);
        led_bytes.add((byte)(processing_app.map((temp_color >> 16 & 0xFF), 0, 255, 0, 127)));
        led_bytes.add((byte)(processing_app.map((temp_color >> 8 & 0xFF), 0, 255, 0, 127)));
        led_bytes.add((byte)(processing_app.map((temp_color & 0xFF), 0, 255, 0, 127)));
      }
      return led_bytes;
    }      

    ArrayList<Byte> get_led_vals_amp2hue() {
      ArrayList<Byte> led_bytes = new ArrayList<Byte>();
      for (int i = 0; i < freq_bands_amp.size() ; i ++) {
        int temp_hue = 220 + (int)(freq_bands_amp.get(i)*160);
        processing_app.colorMode(processing_app.HSB, 360, 100, 100);
        int temp_color = processing_app.color(temp_hue, 100, 100);
        processing_app.colorMode(processing_app.RGB, 255);
        led_bytes.add((byte)(processing_app.map((temp_color >> 16 & 0xFF), 0, 255, 0, 127)));
        led_bytes.add((byte)(processing_app.map((temp_color >> 8 & 0xFF), 0, 255, 0, 127)));
        led_bytes.add((byte)(processing_app.map((temp_color & 0xFF), 0, 255, 0, 127)));
      }       
      return led_bytes;
    }
    

}
