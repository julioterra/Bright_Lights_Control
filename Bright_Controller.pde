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


//class Bright_Controller {
//  
//  Serial myPort; 
//
//  Bright Controller (Serial myPort) {
//  
//  
//  
//  }  
//  
//  
//      boolean check_array_state_change(int new_msg[], int old_msg[]) {
//        for(int i = 0; i < new_msg.length; i++) {
//            if(new_msg[i] != old_msg[i]) return true;
//        } 
//        return false;
//    }
//    
//    int[] update_previous_array(int new_msg[], int old_msg[]) {
//        for(int i = 0; i < new_msg.length; i++) {
//            old_msg[i] = new_msg[i];
//        } 
//        return old_msg;
//    }
//    
//    byte[] convert_array_int_to_byte(int new_msg[]) {
//        byte[] new_byte_msg = new byte[new_msg.length]; 
//        for(int i = 0; i < new_msg.length; i++) {
//            if (new_msg[i] > 127) new_byte_msg[i] = byte(127);
//            if (new_msg[i] < 0) new_byte_msg[i] = byte(0);
//            else new_byte_msg[i] = byte(new_msg[i]);  
//        }
//        return new_byte_msg;
//    }
//    
//    byte[] convert_array_int_to_byte_full(int new_msg[]) {
//        byte[] new_byte_msg = new byte[new_msg.length*3]; 
//        for(int i = 0; i < new_msg.length; i++) {
//            byte[] temp_byte_array = int2bytes_127(new_msg[i]);
//            for (int j = 0; j < 3; j++) {
//              int index_offset = i * 3;
//              new_byte_msg[index_offset + j] = temp_byte_array[j];
//            }
//        }
//        return new_byte_msg;
//    }
//    
//
//
//    // Methods that should be part of the serial_output/physical_output/abstract_output class    
//    void send_serial_msg(byte msg_type, byte[] msg_body) {
//        if (serial_connected) {
//            myPort.write(msg_type);
//            for(int i = 0; i < msg_body.length; i++) {
//                myPort.write(msg_body[i]);
//            }
//            myPort.write(MSG_END);
//        }
//    }
//    
//    void send_serial_msg_arraylist(byte msg_type, ArrayList<Byte> msg_body) {
//        if (serial_connected) {
//            myPort.write(msg_type);
//            for(int i = 0; i < msg_body.size(); i++) {
//                byte current_byte = msg_body.get(i);
//                if (current_byte > 127) println("** realtime msg issue, byte value: " + int (current_byte));
//                myPort.write(current_byte);
//            }
//            myPort.write(MSG_END);
//        }
//    }
//
//  
//  
//  
//  
//  
//}
