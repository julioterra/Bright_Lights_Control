class Display_Box extends Bright_Element {

  Freq_Bands freq_bands_obj;
  
  // display class objects
  PVector display_leds_nums;
  PVector display_position;
  PVector display_size;

  float rgb_color[] = new float[3];
  int scroll_msg[] = {4,0,0};
  int strobe_msg[] = {0};

  ArrayList<PVector> display_position_active;
  ArrayList<PVector> display_size_active;
  ArrayList<Integer> active_colors;
  
  int display_bandwidth = 0;
  int display_mode = 1;
  int display_modes_total = 5;
  PShape bw_box_front;
  PShape bw_box_back;
  int realtime_mode = 0;

  // constructor   
    Display_Box (PApplet _this_app, Freq_Bands _freq_bands) {
  
      freq_bands_obj = _freq_bands;    
      bw_box_front = loadShape("bright_front_new.svg");
      bw_box_back= loadShape("bright_back.svg");
      display_leds_nums = new PVector(freq_bands_obj.get_number_of_bands(), 1);

      active_colors = new ArrayList<Integer>();
      for (int i = 0; i < display_leds_nums.x * display_leds_nums.y; i ++) {
          active_colors.add(0);
      }
      display_size_active  = new ArrayList<PVector>();
      for (int i = 0; i < display_leds_nums.x * display_leds_nums.y; i ++) {
          display_size_active.add(new PVector(0,0));
      }      
      display_position_active  = new ArrayList<PVector>();
      for (int i = 0; i < display_leds_nums.x * display_leds_nums.y; i ++) {
          display_position_active.add(new PVector(0,0));
      }      
    }  
  
    void set_display_mode(int _mode) {
      display_mode = constrain(_mode, 0, display_modes_total-1);
    }
  
  
    // ** METHODS FOR THE DISPLAY CLASS 
  
    void init_pos(int posx, int posy) {
      display_position = new PVector ((posx+display_bandwidth/2), posy);
    }
  
    void init_size(int sizex, int sizey) {
      display_size = new PVector (sizex, sizey);  
      display_bandwidth = int(display_size.x / display_leds_nums.x);
    }
  
    void set_color_hsb(float range, float h, float s, float b) {
      colorMode(HSB, 255);
      println("set color - hsb range " + range + ": " + h + ", " + s  + ", " + b);
      rgb_color[0] = map(h, 0f, range, 0f, 255f);
      rgb_color[1] = map(s, 0f, range, 0f, 255f);
      rgb_color[2] = map(b, 0f, range, 0f, 255f);
    }
  
    void set_strobe(float range, float _strobe_speed) {
      
      
    }

    void set_scroll(int range, int _scroll_speed, int _scroll_direction, float _scroll_width) {
      
      
    }

    void display_realtime_freq_bands(ArrayList<Byte> _new_bytes) {
        display_mode = 4;
        float radius_mult = 1.9;
        
        // hue changed from changed
        for (int i = 0; i < _new_bytes.size()/3; i ++) {
            int index_offset = i * 3;
            colorMode(RGB, 255);
            float temp_red = map(int(_new_bytes.get(index_offset+0)), 0, 127, 0, 255);
            float temp_green = map(int(_new_bytes.get(index_offset+1)), 0, 127, 0, 255);
            float temp_blue = map(int(_new_bytes.get(index_offset+2)), 0, 127, 0, 255);
            color temp_color = color(temp_red, temp_green, temp_blue, 10);
            colorMode(HSB, 255);
            float freq_amplitude = (brightness(temp_color)/255f);
            int x_loc = (int)(display_position.x + (i * display_bandwidth) + (display_bandwidth/2));

            active_colors.set(i, temp_color);
            display_size_active.set(i, new PVector((display_bandwidth*radius_mult*freq_amplitude), (display_bandwidth*radius_mult*freq_amplitude)));
            display_position_active.set(i, new PVector(x_loc, display_position.y));  
        }
    }
    
    void display_box() {
        colorMode(HSB, 255);
        background(color(255, 0, 200));
        smooth();
        ellipseMode(CENTER);
        float scale_mult = 0.55;
    
        PVector box_size = new PVector(display_size.x*1.265,(display_size.x*1.265)/5);
        PVector box_pos = new PVector(display_position.x-(box_size.x*0.1),display_position.y-(box_size.y*0.5));
        shape(bw_box_back, box_pos.x, box_pos.y, box_size.x, box_size.y);           


//        if (display_mode == 1 && display_mode == 4) {
            for (int i = 0; i < display_leds_nums.x * display_leds_nums.y; i ++) {
                fill(active_colors.get(i));           
                PVector temp_size = new PVector(display_size_active.get(i).x, display_size_active.get(i).y);   
                PVector temp_pos = new PVector(display_position_active.get(i).x, display_position_active.get(i).y);   
                for (float j = 1; j >= 0.1; j = j - j * 0.025f) {
                   ellipse(temp_pos.x, temp_pos.y, temp_size.x*j, temp_size.y*j);
                }
            }
//        }
        shape(bw_box_front, box_pos.x, box_pos.y, box_size.x, box_size.y);

    }

}

