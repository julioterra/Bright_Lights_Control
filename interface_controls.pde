void controlEvent(ControlEvent theEvent) {
  
    if(theEvent.isGroup()) {

        // HANDLE DATA FROM RADIO BUTTONS
        // handle the data from mode selection radio buttons
        if (theEvent.group().name() == "modeRadioButton") {
            interaction_mode = int(theEvent.group().value());
            switch (interaction_mode) {
                case 0:  
                    send_serial_msg(MODE_MSG_off, convert_array_int_to_byte_full(hsb_msg));
                    break;
                case 1:  
                    send_serial_msg(MODE_MSG_color_hsb, convert_array_int_to_byte_full(hsb_msg));
                    break;
                case 2:
                    send_serial_msg(MODE_MSG_strobe, convert_array_int_to_byte(strobe_msg));
                    break;
                case 3:
                    send_serial_msg(MODE_MSG_scroll, convert_array_int_to_byte(scroll_msg));
                    break;
                case 4:
                    byte empty_array[] = {byte(0),MSG_END};
                    send_serial_msg(MODE_MSG_realtime, empty_array);
                    break;
            }
        }

        // SCROLL RADIO BUTTON DATA
        // handle the data from mode selection radio buttons
        if (theEvent.group().name() == "scrollRadioButton") {
              scroll_msg[1] = int(theEvent.group().value());
              if (interaction_mode == 3) {
                  send_serial_msg(MODE_MSG_scroll, convert_array_int_to_byte(scroll_msg));
                  
              }
        }
  
    } 
    
    // HANDLE DATA FROM ALL SLIDERS
    // handle the data from mode selection radio buttons
    else if (theEvent.isController()){
        if (theEvent.controller().name().equals("hue_slider")) {
                hsb_msg[0] = int(theEvent.controller().value());
                if (check_array_state_change(hsb_msg, previous_hsb_msg)) {
                    previous_hsb_msg = update_previous_array(hsb_msg, previous_hsb_msg);
                    if (slider_range != 127) send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte_full(hsb_msg));
                    else send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte(hsb_msg));
                    freq_bands_obj.set_base_color_hsb(slider_range, hsb_msg[0],hsb_msg[1],hsb_msg[2]);
                }

        }
        else if (theEvent.controller().name().equals("sat_slider")) {
                hsb_msg[1] = int(theEvent.controller().value());
                if (check_array_state_change(hsb_msg, previous_hsb_msg)) {
                    previous_hsb_msg = update_previous_array(hsb_msg, previous_hsb_msg);
                    send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte_full(hsb_msg));
                    if (slider_range != 127) send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte_full(hsb_msg));
                    else send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte(hsb_msg));
                    freq_bands_obj.set_base_color_hsb(slider_range, hsb_msg[0],hsb_msg[1],hsb_msg[2]);
                }

        }
        else if (theEvent.controller().name().equals("bright_slider")) {
                hsb_msg[2] = int(theEvent.controller().value());
                if (check_array_state_change(hsb_msg, previous_hsb_msg)) {
                    previous_hsb_msg = update_previous_array(hsb_msg, previous_hsb_msg);
                    send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte_full(hsb_msg));
                    if (slider_range != 127) send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte_full(hsb_msg));
                    else send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte(hsb_msg));
                    freq_bands_obj.set_base_color_hsb(slider_range, hsb_msg[0],hsb_msg[1],hsb_msg[2]);
                }

        }
        else if (theEvent.controller().name().equals("strobe_slider")) {
            strobe_msg[0] = int(theEvent.controller().value());
            if (check_array_state_change(strobe_msg, previous_strobe_msg)) {
                previous_strobe_msg = update_previous_array(strobe_msg, previous_strobe_msg);
                if (interaction_mode == 2) {
                    send_serial_msg(MODE_MSG_strobe, convert_array_int_to_byte(strobe_msg));
                }
            }
        }
        else if (theEvent.controller().name().equals("scroll_slider")) {
            scroll_msg[0] = int(theEvent.controller().value());
            if (check_array_state_change(scroll_msg, previous_scroll_msg)) {
                previous_scroll_msg = update_previous_array(scroll_msg, previous_scroll_msg);
                if (interaction_mode == 3) {
                    send_serial_msg(MODE_MSG_scroll, convert_array_int_to_byte(scroll_msg));
                }
            }
        }
        else if (theEvent.controller().name().equals("scroll_width_slider")) {
            scroll_msg[2] = int(theEvent.controller().value());
            if (check_array_state_change(scroll_msg, previous_scroll_msg)) {
                previous_scroll_msg = update_previous_array(scroll_msg, previous_scroll_msg);
                if (interaction_mode == 3) {
                    send_serial_msg(MODE_MSG_scroll, convert_array_int_to_byte(scroll_msg));
                }
            }
        }
    }
}


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


void send_serial_msg(byte msg_type, byte[] msg_body) {
    myPort.write(msg_type);
    for(int i = 0; i < msg_body.length; i++) {
        myPort.write(msg_body[i]);
    }
    myPort.write(MSG_END);
}

void send_serial_msg_arraylist(byte msg_type, ArrayList<Byte> msg_body) {
    myPort.write(msg_type);
    for(int i = 0; i < msg_body.size(); i++) {
        myPort.write(msg_body.get(i));
    }
    myPort.write(MSG_END);
}


