void read_serial_bytes(byte _new_byte) {
    // MESSAGE START: if this byte is equal to or greater then 129 then we know that this is the start of a new message
    if (int(_new_byte) > 128 && int(_new_byte) < 255) {
        msg_type = _new_byte;
        reading_msg_flag = true;
        msg_body = new ArrayList<Byte>();
    } 
    
    // READ MESSAGE: if reading_msg_flag is set to true then read message
    if (reading_msg_flag) {
    
        // MESSAGE END: if this byte is equal to 128 then we know that this is end of a message
        if (_new_byte == MSG_END) {
            parse_serial_msg(msg_type, msg_body);
            reading_msg_flag = false;
        }

        // MESSAGE BODY: f a reading_msg_flag is set to true, and the byte count is smaller than longest possible message, 
        // and the value of the byte is lower than 128 (all message bytes have a value that is less than 127).
        else if (int(_new_byte) < 128) {
            msg_body.add(_new_byte);  
        }

    }
}

void parse_serial_msg(byte _msg_type, ArrayList<Byte> _msg_body) {

    // this is a status message and the size is 21 without the header byte
    if (_msg_type == STATUS_MSG && _msg_body.size() >= 20 && interaction_mode != mode_realtime) {
        int current_index = 0;
        byte[] temp_bytes = {0,0,0};


        println("first element " + _msg_body.get(current_index));
        // set the first element in array to set mode_radio_button
        mode_radio_button.activate(int(_msg_body.get(current_index)));
        current_index++;

        for (int i = 0; i < 3; i++) {
            temp_bytes[i] = _msg_body.get(current_index);  
            current_index++;
        } 
        controlP5.controller("hue_slider").setValue(bytes2int_127(temp_bytes));

        for (int i = 0; i < 3; i++) {
            temp_bytes[i] = _msg_body.get(current_index);  
            current_index++;
        } 
        controlP5.controller("sat_slider").setValue(bytes2int_127(temp_bytes));

        for (int i = 0; i < 3; i++) {
            temp_bytes[i] = _msg_body.get(current_index);  
            current_index++;
        } 
        controlP5.controller("bright_slider").setValue(bytes2int_127(temp_bytes));

        for (int i = 0; i < 3; i++) {
            temp_bytes[i] = _msg_body.get(current_index);  
            current_index++;
        } 
        controlP5.controller("strobe_slider").setValue(bytes2int_127(temp_bytes));

        for (int i = 0; i < 3; i++) {
            temp_bytes[i] = _msg_body.get(current_index);  
            current_index++;
        } 
        controlP5.controller("scroll_slider").setValue(bytes2int_127(temp_bytes));

        scroll_radio_button.activate(int(_msg_body.get(current_index)));
        current_index++;

        for (int i = 0; i < 3; i++) {
            temp_bytes[i] = _msg_body.get(current_index);  
            current_index++;
        } 
        controlP5.controller("scroll_width_slider").setValue(bytes2int_127(temp_bytes));

    }    

}

