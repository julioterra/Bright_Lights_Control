class Physical_Devices_Output {

    Serial myPort;
    PApplet processing_app;
    boolean connection_established = false;
    boolean reading_msg_flag = false;
    byte msg_type = 0;
    ArrayList<Byte> msg_body;
    boolean serial_connected;

    Physical_Devices_Output(PApplet _processing_app) {
      processing_app = _processing_app;
    }
  
    public Serial connect_serial(String serial_device_name) {
        String serial_list [] = Serial.list();
        println(serial_list);
        
    
        int serial_num = -1;
        for(int i = (serial_list.length - 1); i >= 0; i--){     
            if (serial_list[i].contains(serial_device_name)) {
                try{
                    serial_num = i;
                    myPort = new Serial(processing_app, serial_list[serial_num], 57600);
                    delay(3000);
                    myPort.buffer(1);
                    myPort.write('\n');
                    delay(1000);
                    serial_connected = true;  
                } catch(Exception e) {
                    serial_connected = false;  
                }
            }
        }    
    
        println("\n** connection status **");
        if (serial_connected) println("found serial: " + serial_list[serial_num]);
        else println ("ERROR: serial NOT found");
        
        return myPort;
    }
    
    int connect_serial_obj(String serial_device_name) {
        boolean serial_found = false;
        String serial_list [] = Serial.list();
        println(serial_list);
        
    
        int serial_num = -1;
        for(int i = (serial_list.length - 1); i >= 0; i--){     
            if (serial_list[i].contains(serial_device_name)) {
                try{
                    serial_num = i;
                    myPort = new Serial(processing_app, serial_list[serial_num], 57600);
                    delay(3000);
                    myPort.buffer(1);
                    myPort.write('\n');
                    delay(1000);
                    serial_found = true;
                    serial_connected = true;  
                } catch(Exception e) {
                    serial_found = false;
                    serial_connected = false;  
                }
            }
        }    
    
        println("\n** connection status **");
        if (serial_found) println("found serial: " + serial_list[serial_num]);
        else println ("ERROR: serial NOT found");
        
        return serial_num;
    }

    boolean connected() {
      return connection_established; 
    }
    
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
    
//    void parse_serial_msg(byte _msg_type, ArrayList<Byte> _msg_body) {
//    
//        // this is a status message and the size is 21 without the header byte
//        if (_msg_type == STATUS_MSG && _msg_body.size() >= 20 && interaction_mode != mode_realtime) {
//            int current_index = 0;
//            byte[] temp_bytes = {0,0,0};
//    
//    
//            println("first element " + _msg_body.get(current_index));
//            // set the first element in array to set mode_radio_button
//            user_interface.mode_radio_button.activate(int(_msg_body.get(current_index)));
//            current_index++;
//    
//            for (int i = 0; i < 3; i++) {
//                temp_bytes[i] = _msg_body.get(current_index);  
//                current_index++;
//            } 
//            user_interface.controlP5.controller("hue_slider").setValue(bytes2int_127(temp_bytes));
//    
//            for (int i = 0; i < 3; i++) {
//                temp_bytes[i] = _msg_body.get(current_index);  
//                current_index++;
//            } 
//            user_interface.controlP5.controller("sat_slider").setValue(bytes2int_127(temp_bytes));
//    
//            for (int i = 0; i < 3; i++) {
//                temp_bytes[i] = _msg_body.get(current_index);  
//                current_index++;
//            } 
//            user_interface.controlP5.controller("bright_slider").setValue(bytes2int_127(temp_bytes));
//    
//            for (int i = 0; i < 3; i++) {
//                temp_bytes[i] = _msg_body.get(current_index);  
//                current_index++;
//            } 
//            user_interface.controlP5.controller("strobe_slider").setValue(bytes2int_127(temp_bytes));
//    
//            for (int i = 0; i < 3; i++) {
//                temp_bytes[i] = _msg_body.get(current_index);  
//                current_index++;
//            } 
//            user_interface.controlP5.controller("scroll_slider").setValue(bytes2int_127(temp_bytes));
//    
//            user_interface.scroll_radio_button.activate(int(_msg_body.get(current_index)));
//            current_index++;
//    
//            for (int i = 0; i < 3; i++) {
//                temp_bytes[i] = _msg_body.get(current_index);  
//                current_index++;
//            } 
//            user_interface.controlP5.controller("scroll_width_slider").setValue(bytes2int_127(temp_bytes));
//        }    
//    }

    // Methods that should be part of the serial_output/physical_output/abstract_output class    
    void send_serial_msg(byte msg_type, byte[] msg_body) {
        if (serial_connected) {
            print("sending serial: " + (int)msg_type + ", ");
            myPort.write(msg_type);
            for(int i = 0; i < msg_body.length; i++) {
                myPort.write(msg_body[i]);
            print((int)msg_body[i] + ", ");
            }
            myPort.write(MSG_END);
            println((int)MSG_END + ", ");
        }
         else {
            println("trying to send message but having serial issues"); 
         }
    }
    
    public void send_serial_msg_arraylist(byte msg_type, ArrayList<Byte> msg_body) {
        if (serial_connected) {
            myPort.write(msg_type);
            for(int i = 0; i < msg_body.size(); i++) {
                byte current_byte = msg_body.get(i);
                if (current_byte > 127) println("** realtime msg issue, byte value: " + int (current_byte));
                myPort.write(current_byte);
            }
            myPort.write(MSG_END);
        }
    }
}
