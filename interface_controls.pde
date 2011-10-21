class User_Interface_Input extends Bright_Element {
  
    public ControlP5 controlP5;
    public RadioButton on_radio_button;
    public RadioButton mode_radio_button;
    public RadioButton scroll_radio_button;
    
    PApplet processing_app;
    Serial myPort; 
    Physical_Devices_Output physical_output;
    Freq_Bands freq_bands_obj;

  public User_Interface_Input(PApplet _processing_app, Physical_Devices_Output _physical_output, Freq_Bands _freq_bands_obj) {
      processing_app = _processing_app;
      physical_output = _physical_output;
      freq_bands_obj = _freq_bands_obj;
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
    
    
    
    public void controlEvent(ControlEvent theEvent) {
        if(theEvent.isGroup()) {
            controller.process_input(theEvent.group().name(), theEvent.group().value());
        }         
        else if (theEvent.isController()){
           controller.process_input(theEvent.controller().name(), theEvent.controller().value());
        }
    }

    public void externalEvent(String id, float value) {
        if(id.contains("modeRadioButton") || id.contains("onOffRadioButton") || id.contains("scrollRadioButton")) {
            RadioButton temp_radio = (RadioButton) user_interface.controlP5.getGroup(id);
            temp_radio.activate((int)value);
//            user_interface.controlP5.group(id).activate((int)value);
        }
        else {
            user_interface.controlP5.controller(id).setValue(value);
        }
    }

    // Add all of these to a database
    // Create a data structure that features
    //   1. ui_element type (group or standard)
    //   2. ui_elment name
    //   3. ui_element object

}
