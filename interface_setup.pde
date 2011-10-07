void init_interface() {
  controlP5 = new ControlP5(this);

  /********************
    MODE RADIO BUTTON SET-UP
    create the radio buttons to select between standard, strobe, scroll, and realtime modes
    */
  mode_radio_button = controlP5.addRadioButton("modeRadioButton", 20, 40);
  mode_radio_button.setColorForeground(color(120));
  mode_radio_button.setColorActive(color(255));
  mode_radio_button.setColorLabel(color(255));
  mode_radio_button.setItemsPerRow(5);
  mode_radio_button.setSpacingColumn(50);

  // add radion button elements to each 
  addToRadioButton(mode_radio_button,"off",0, 80, 46);
  addToRadioButton(mode_radio_button,"standard",1, 80, 46);
  addToRadioButton(mode_radio_button,"strobe",2, 80, 46);
  addToRadioButton(mode_radio_button,"scroll",3, 80, 46);
  addToRadioButton(mode_radio_button,"realtime",4, 80, 46);
 
  mode_radio_button.activate(interaction_mode);


  /********************
    HSB BUTTON SET-UP
    create the sliders to control HSB values
    */
  int hsb_slider_x = 20;
  int hsb_slider_y = 100;
  int hsb_space_y = 20;
  controlP5.addSlider("hue_slider",      0,1000,0,hsb_slider_x,hsb_slider_y,200,10);
  controlP5.addSlider("sat_slider",      0,1000,0,hsb_slider_x,hsb_slider_y+(hsb_space_y*1),200,10);
  controlP5.addSlider("bright_slider",   0,1000,0,hsb_slider_x,hsb_slider_y+(hsb_space_y*2),200,10);


  /********************
    STROBE BUTTON SET-UP
    create the sliders to control strobe values
    */
  int strobe_slider_x = 20;
  int strobe_slider_y = 200;
  controlP5.addSlider("strobe_slider",   0,127,0,strobe_slider_x,strobe_slider_y,100,10);



  /********************
    SCROLL SET-UP
    create the sliders to control scroll values
    */
  int scroll_x = 20;
  int scroll_y = 270;
  controlP5.addSlider("scroll_slider",   5,127,0,scroll_x+120,scroll_y,100,10);
  controlP5.addSlider("scroll_width_slider",   0,127,0,scroll_x+120,scroll_y + 20,100,10);

  // create the radio buttons to select between different types of scrolling
  scroll_radio_button = controlP5.addRadioButton("scrollRadioButton", 20, scroll_y);
  scroll_radio_button.setColorForeground(color(0));
  scroll_radio_button.setColorActive(color(255));
  scroll_radio_button.setColorLabel(color(255));
  scroll_radio_button.setItemsPerRow(1);
  scroll_radio_button.setSpacingColumn(70);
  
  // add radion button elements to each 
  addToRadioButton(scroll_radio_button,"left to right",0,0,66);
  addToRadioButton(scroll_radio_button,"right to left",1,0,66);
  addToRadioButton(scroll_radio_button,"inward",2,0,66);
  addToRadioButton(scroll_radio_button,"outward",3,0,66);

  scroll_radio_button.activate(0);

}

void addToRadioButton(RadioButton theRadioButton, String theName, int theValue, int theColor, int theWidth) {
  Toggle toggle_select = theRadioButton.addItem(theName,theValue);
  toggle_select.captionLabel().setColorBackground(color(theColor));
  toggle_select.captionLabel().style().movePadding(2,0,-1,2);
  toggle_select.captionLabel().style().moveMargin(-2,0,0,-3);
  toggle_select.captionLabel().style().backgroundWidth = theWidth;
}
