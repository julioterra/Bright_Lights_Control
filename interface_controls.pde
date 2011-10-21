class User_Interface {
  
    public ControlP5 controlP5;
    public RadioButton on_radio_button;
    public RadioButton mode_radio_button;
    public RadioButton scroll_radio_button;
    
    PApplet processing_app;
    Serial myPort; 

  User_Interface(PApplet _processing_app, Serial _myPort) {
      processing_app = _processing_app;
      myPort = _myPort;
      controlP5 = new ControlP5(processing_app);
    
      PVector control_origin = new PVector(20,20);
      PVector transport_controls = new PVector(control_origin.x,control_origin.y);
      PVector mode_specific_controls = new PVector(control_origin.x,control_origin.y+200);
     
      PVector on_origin = new PVector(transport_controls.x,transport_controls.y);
    
      /********************
        ON/OFF RADIO BUTTON SET-UP
        create the radio buttons to select on and off
        */
      on_radio_button = controlP5.addRadioButton("onOffRadioButton", (int)on_origin.x, (int)on_origin.y);
      on_radio_button.setColorForeground(color(120));
      on_radio_button.setColorActive(color(255));
      on_radio_button.setColorLabel(color(255));
      on_radio_button.setItemsPerRow(1);
      on_radio_button.setSpacingColumn(50);
      on_radio_button.setNoneSelectedAllowed(false);
    
      addToRadioButton(on_radio_button,"on",0, 80, 46);
      addToRadioButton(on_radio_button,"off",1, 80, 46);
    
      on_radio_button.activate(1);
    
      /********************
        MODE RADIO BUTTON SET-UP
        create the radio buttons to select between standard, strobe, scroll, and realtime modes
        */
      PVector mode_origin = new PVector(transport_controls.x+80,transport_controls.y);
      mode_radio_button = controlP5.addRadioButton("modeRadioButton", (int)mode_origin.x, (int)mode_origin.y);
      mode_radio_button.setColorForeground(color(120));
      mode_radio_button.setColorActive(color(255));
      mode_radio_button.setColorLabel(color(255));
      mode_radio_button.setItemsPerRow(5);
      mode_radio_button.setSpacingColumn(50);
      mode_radio_button.setNoneSelectedAllowed(false);
    
      // add radion button elements to each 
      addToRadioButton(mode_radio_button,"standard",1, 80, 46);
      addToRadioButton(mode_radio_button,"strobe",2, 80, 46);
      addToRadioButton(mode_radio_button,"scroll",3, 80, 46);
      addToRadioButton(mode_radio_button,"realtime",4, 80, 46);
     
      mode_radio_button.activate(0);
    
    
    
      /********************
        HSB BUTTON SET-UP
        create the sliders to control HSB values
        */
      PVector hsb_origin = new PVector(mode_specific_controls.x,mode_specific_controls.y+40);
      int hsb_space_y = 20;
      controlP5.addSlider("hue_slider",      0,slider_range,0,(int)hsb_origin.x,(int)hsb_origin.y,200,10);
      controlP5.addSlider("sat_slider",      0,slider_range,0,(int)hsb_origin.x,(int)hsb_origin.y+(hsb_space_y*1),200,10);
      controlP5.addSlider("bright_slider",   0,slider_range,0,(int)hsb_origin.x,(int)hsb_origin.y+(hsb_space_y*2),200,10);
    
    
      /********************
        STROBE BUTTON SET-UP
        create the sliders to control strobe values
        */
      PVector strobe_origin = new PVector(mode_specific_controls.x+280,mode_specific_controls.y+40);
      controlP5.addSlider("strobe_slider",   0,127,0,(int)strobe_origin.x,(int)strobe_origin.y,200,10);
    
      /********************
        SCROLL SET-UP
        create the sliders to control scroll values
        */
      PVector scroll_origin = new PVector(mode_specific_controls.x+560,mode_specific_controls.y+40);
      controlP5.addSlider("scroll_slider", 5,127,0,(int)scroll_origin.x,(int)scroll_origin.y,200,10);
      controlP5.addSlider("scroll_width_slider", 0,127,0,(int)scroll_origin.x,(int)(scroll_origin.y + 20),200,10);
    
      // create the radio buttons to select between different types of scrolling
      scroll_radio_button = controlP5.addRadioButton("scrollRadioButton", (int)scroll_origin.x, (int)(scroll_origin.y + 40));
      scroll_radio_button.setColorForeground(color(0, 0, 50));
      scroll_radio_button.setColorActive(color(255));
      scroll_radio_button.setColorLabel(color(255));
      scroll_radio_button.setItemsPerRow(4);
      scroll_radio_button.setSpacingColumn(50);
      
      // add radion button elements to each 
      addToRadioButton(scroll_radio_button,"to right",0,80,46);
      addToRadioButton(scroll_radio_button,"to left",1,80,46);
      addToRadioButton(scroll_radio_button,"inward",2,80,46);
      addToRadioButton(scroll_radio_button,"outward",3,80,46);
    
      scroll_radio_button.activate(0);
    
    }
    
    
    void addToRadioButton(RadioButton theRadioButton, String theName, int theValue, int theColor, int theWidth) {
      Toggle toggle_select = theRadioButton.addItem(theName,theValue);
      toggle_select.captionLabel().setColorBackground(color(theColor));
      toggle_select.captionLabel().style().movePadding(2,0,-1,2);
      toggle_select.captionLabel().style().moveMargin(-2,0,0,-3);
      toggle_select.captionLabel().style().backgroundWidth = theWidth;
    }
    
    
    
    void controlEvent(ControlEvent theEvent) {
      
        if(theEvent.isGroup()) {
    
            if (theEvent.group().name() == "onOffRadioButton") {
                switch ((int)theEvent.group().value()) {
                    case 0:  
                        lights_on = true;
                        break;
                    case 1: 
                        lights_on = false;
                        send_serial_msg(MODE_MSG_off, convert_array_int_to_byte_full(hsb_msg));
                        break;
                }
            }
    
            // HANDLE DATA FROM RADIO BUTTONS
            // handle the data from mode selection radio buttons
            if (theEvent.group().name() == "modeRadioButton") {
                interaction_mode = int(theEvent.group().value());
            }
    
            if (lights_on && (theEvent.group().name() == "onOffRadioButton" || theEvent.group().name() == "modeRadioButton")) { 
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
                    default:
                        break;
                }
            }
    
            // SCROLL RADIO BUTTON DATA
            // handle the data from mode selection radio buttons
            if (theEvent.group().name() == "scrollRadioButton") {
                  scroll_msg[1] = int(theEvent.group().value());
                  display_box_obj.set_scroll(127, scroll_msg[0], scroll_msg[1], scroll_msg[2]);
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
                    freq_bands_obj.set_base_color_hsb(slider_range, hsb_msg[0],hsb_msg[1],hsb_msg[2]);
                    if (lights_on && interaction_mode != mode_realtime) {
                    println("sending HSB msg");
                        previous_hsb_msg = update_previous_array(hsb_msg, previous_hsb_msg);
                        if (slider_range != 127) send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte_full(hsb_msg));
                        else send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte(hsb_msg));
                    }
                }
            }
    
            else if (theEvent.controller().name().equals("sat_slider")) {
                hsb_msg[1] = int(theEvent.controller().value());
                if (check_array_state_change(hsb_msg, previous_hsb_msg)) {
                    freq_bands_obj.set_base_color_hsb(slider_range, hsb_msg[0],hsb_msg[1],hsb_msg[2]);
                    if (lights_on && interaction_mode != mode_realtime) {
                        previous_hsb_msg = update_previous_array(hsb_msg, previous_hsb_msg);
                        if (slider_range != 127) send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte_full(hsb_msg));
                        else send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte(hsb_msg));
                    }
                }
            }
    
            else if (theEvent.controller().name().equals("bright_slider")) {
                hsb_msg[2] = int(theEvent.controller().value());
                if (check_array_state_change(hsb_msg, previous_hsb_msg)) {
                    freq_bands_obj.set_base_color_hsb(slider_range, hsb_msg[0],hsb_msg[1],hsb_msg[2]);
                    if (lights_on && interaction_mode != mode_realtime) {
                        previous_hsb_msg = update_previous_array(hsb_msg, previous_hsb_msg);
                        if (slider_range != 127) send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte_full(hsb_msg));
                        else send_serial_msg(SET_MSG_hsb, convert_array_int_to_byte(hsb_msg));
                    }
                }
            }
    
            else if (theEvent.controller().name().equals("strobe_slider")) {
                strobe_msg[0] = int(theEvent.controller().value());
                if (check_array_state_change(strobe_msg, previous_strobe_msg)) {
                    if (lights_on && interaction_mode == 2) {
                        display_box_obj.set_strobe(127, strobe_msg[0]);
                        previous_strobe_msg = update_previous_array(strobe_msg, previous_strobe_msg);
                        send_serial_msg(MODE_MSG_strobe, convert_array_int_to_byte(strobe_msg));
                    }
                }
            }
    
            else if (theEvent.controller().name().equals("scroll_slider")) {
                scroll_msg[0] = int(theEvent.controller().value());
                if (check_array_state_change(scroll_msg, previous_scroll_msg)) {
                    if (lights_on && interaction_mode == 3) {
                        display_box_obj.set_scroll(127, scroll_msg[0], scroll_msg[1], scroll_msg[2]);
                        previous_scroll_msg = update_previous_array(scroll_msg, previous_scroll_msg);
                        send_serial_msg(MODE_MSG_scroll, convert_array_int_to_byte(scroll_msg));
                    }
                }
            }
    
            else if (theEvent.controller().name().equals("scroll_width_slider")) {
                scroll_msg[2] = int(theEvent.controller().value());
                if (check_array_state_change(scroll_msg, previous_scroll_msg)) {
                    if (lights_on && interaction_mode == 3) {
                        display_box_obj.set_scroll(127, scroll_msg[0], scroll_msg[1], scroll_msg[2]);
                        previous_scroll_msg = update_previous_array(scroll_msg, previous_scroll_msg);
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
        if (serial_connected) {
            myPort.write(msg_type);
            for(int i = 0; i < msg_body.length; i++) {
                myPort.write(msg_body[i]);
            }
            myPort.write(MSG_END);
        }
    }
    
    void send_serial_msg_arraylist(byte msg_type, ArrayList<Byte> msg_body) {
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
