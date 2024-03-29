class Bright_Controller extends Bright_Element{
  
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

    Bright_Controller () {
    ;
    
    
    }  


    //////////////////////////////////////////////////////
    // methods that handle input from the SERIAL INTERFACE
    //////////////////////////////////////////////////////

    void parse_serial_msg(byte _msg_type, ArrayList<Byte> _msg_body) {
    
        // this is a status message and the size is 21 without the header byte
        if (false) {
    //    if (_msg_type == STATUS_MSG && _msg_body.size() >= 20 && interaction_mode != mode_realtime) {
            int current_index = 0;
            byte[] temp_bytes = {0,0,0};
    
    
            println("first element " + _msg_body.get(current_index));
            // set the first element in array to set mode_radio_button
            user_interface.mode_radio_button.activate(int(_msg_body.get(current_index)));
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
    
            user_interface.scroll_radio_button.activate(int(_msg_body.get(current_index)));
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
            if (new_msg[i] > 127) new_byte_msg[i] = byte(127);
            if (new_msg[i] < 0) new_byte_msg[i] = byte(0);
            else new_byte_msg[i] = byte(new_msg[i]);  
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
      if (id == "onOffRadioButton") {
          switch ((int)value) {
              case 0:  
                  lights_on = true;
                  break;
              case 1: 
                  lights_on = false;
                  physical_output.send_serial_msg(MODE_MSG_off, convert_array_int_to_byte_full(hsb_msg));
                  break;
          }
      }
      else if (id == "modeRadioButton") {
          interaction_mode = (int)value;
      }

      if (lights_on && (id == "onOffRadioButton" || id == "modeRadioButton")) { 
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
              case 4:
                  byte empty_array[] = {byte(0),MSG_END};
                  physical_output.send_serial_msg(MODE_MSG_realtime, empty_array);
                  break;
              default:
                  break;
          }
      }

      // SCROLL RADIO BUTTON DATA
      // handle the data from mode selection radio buttons
      if (id == "scrollRadioButton") {
            scroll_msg[1] = (int)value;
            display_box_obj.set_scroll(127, scroll_msg[0], scroll_msg[1], scroll_msg[2]);
            if (interaction_mode == 3) {
                physical_output.send_serial_msg(MODE_MSG_scroll, convert_array_int_to_byte(scroll_msg));
                
            }
      }
            
      if (id.equals("hue_slider")) {
            hsb_msg[0] = (int)value;
            if (check_array_state_change(hsb_msg, previous_hsb_msg)) {
                freq_bands_obj.set_base_color_hsb(slider_range, hsb_msg[0],hsb_msg[1],hsb_msg[2]);
                if (lights_on && interaction_mode != mode_realtime) {
                println("sending HSB msg");
                    previous_hsb_msg = update_previous_array(hsb_msg, previous_hsb_msg);
                    if (slider_range != 127) physical_output.send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte_full(hsb_msg));
                    else physical_output.send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte(hsb_msg));
                }
            }
        }

        else if (id.equals("sat_slider")) {
            hsb_msg[1] = (int)value;
            if (check_array_state_change(hsb_msg, previous_hsb_msg)) {
                freq_bands_obj.set_base_color_hsb(slider_range, hsb_msg[0],hsb_msg[1],hsb_msg[2]);
                if (lights_on && interaction_mode != mode_realtime) {
                    previous_hsb_msg = update_previous_array(hsb_msg, previous_hsb_msg);
                    if (slider_range != 127) physical_output.send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte_full(hsb_msg));
                    else physical_output.send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte(hsb_msg));
                }
            }
        }

        else if (id.equals("bright_slider")) {
            hsb_msg[2] = (int)value;
            if (check_array_state_change(hsb_msg, previous_hsb_msg)) {
                freq_bands_obj.set_base_color_hsb(slider_range, hsb_msg[0],hsb_msg[1],hsb_msg[2]);
                if (lights_on && interaction_mode != mode_realtime) {
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
                    display_box_obj.set_strobe(127, strobe_msg[0]);
                    previous_strobe_msg = update_previous_array(strobe_msg, previous_strobe_msg);
                    physical_output.send_serial_msg(MODE_MSG_strobe, convert_array_int_to_byte(strobe_msg));
                }
            }
        }

        else if (id.equals("scroll_slider")) {
            scroll_msg[0] = (int)value;
            if (check_array_state_change(scroll_msg, previous_scroll_msg)) {
                if (lights_on && interaction_mode == 3) {
                    display_box_obj.set_scroll(127, scroll_msg[0], scroll_msg[1], scroll_msg[2]);
                    previous_scroll_msg = update_previous_array(scroll_msg, previous_scroll_msg);
                    physical_output.send_serial_msg(MODE_MSG_scroll, convert_array_int_to_byte(scroll_msg));
                }
            }
        }

        else if (id.equals("scroll_width_slider")) {
            scroll_msg[2] = (int)value;
            if (check_array_state_change(scroll_msg, previous_scroll_msg)) {
                if (lights_on && interaction_mode == 3) {
                    display_box_obj.set_scroll(127, scroll_msg[0], scroll_msg[1], scroll_msg[2]);
                    previous_scroll_msg = update_previous_array(scroll_msg, previous_scroll_msg);
                    physical_output.send_serial_msg(MODE_MSG_scroll, convert_array_int_to_byte(scroll_msg));
                }
            }
        }
    }

    public byte[] int2bytes_127(int int_val) {
        byte[] byte_vals = {0,0,0};
        byte_vals[0] = byte(int_val >> 8);          // most significant byte
        byte_vals[1] = byte(int_val >> 1);
        byte_vals[2] = byte(int_val << 6);          // least significant byte
        
        // shift all byte values over by one, so that values will range between 0 - 127 only
        for (int i = 0; i < 3; i ++) {
            int temp_int = int(byte_vals[i]);
            byte_vals[i] = byte(temp_int >> 1);
        }
    
        return byte_vals;
    }
    
    public int bytes2int_127(byte[] byte_vals) {
        // shift all byte values over by one in preparation to convert back to int
        for (int i = 0; i < 3; i ++) {
            byte_vals[i] = byte(int(byte_vals[i] << 1)); 
        }
        
        int new_int = ((int(byte_vals[2]) >> 6) +       // least significant byte
                       (int(byte_vals[1]) << 1) + 
                       (int(byte_vals[0]) << 8));      // most significant byte
    
        return new_int;      
    }

}
