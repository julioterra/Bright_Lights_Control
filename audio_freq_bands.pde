class Freq_Bands {

  Minim minim;
  AudioInput audio_input;
  FFT fft;

  // make these into a customized setting for the object
  float freq_band_mult = 0;
  int setup_band_freq = 0;
  float freq_amplitude_range = 0;
  PVector display_position;
  PVector display_size;
  int display_bandwidth = 0;

  color rgb_base_color;
  float [] rgb_base_color_array = new float[3];
  int display_mode = 1;
  PShape bw_box_front;
  PShape bw_box_back;


  // generated elements of the collection
  ArrayList<Integer> freq_bands = new ArrayList<Integer>();
  ArrayList<Float> freq_bands_amp_offset = new ArrayList<Float>();
  ArrayList<Float> freq_bands_amp = new ArrayList<Float>();
  //    ArrayList<Float> freq_bands_amp_float = new ArrayList<Float>();

  // constructor   
  Freq_Bands (PApplet _this_app, int _setup_band_freq, float _freq_band_mult) {
    minim = new Minim(_this_app);  
    // initialize the audio input object
    audio_input = minim.getLineIn(Minim.STEREO, 512);
    // initialize the FFT object that has a time-domain buffer the same size as audio_input's sample buffer
    fft = new FFT(audio_input.bufferSize(), audio_input.sampleRate());
    // set window type to hamming
    fft.window(FFT.HAMMING);

    // initialize the freq_bands array  
    setup_band_freq = _setup_band_freq; 
    freq_band_mult = _freq_band_mult;
    init_freq_bands_array(_setup_band_freq, _freq_band_mult);      
    set_amplitude_range(150f);
    rgb_base_color = color (255, 255, 255);
    bw_box_front = loadShape("bright_front_new.svg");
    bw_box_back= loadShape("bright_back.svg");
  }  

  void init_freq_bands_array(int _setup_band_freq, float _freq_band_mult) {

    // initialize the freq bands based on starting setup_band_freq and freq_band_mult 
    for (float end_freq = setup_band_freq; end_freq < audio_input.sampleRate() / 2; end_freq = end_freq * freq_band_mult) {
      println ("end frequency #" + freq_bands.size() + ": " + int(end_freq));
      freq_bands.add(int(end_freq));
      freq_bands_amp.add(0f);
    }
    //        display_bandwidth = width / freq_bands.size();
  }

  void init_freq_bands_pos(int posx, int posy) {
    display_position = new PVector ((posx+display_bandwidth/2), posy);
  }

  void init_freq_bands_size(int sizex, int sizey) {
    display_size = new PVector (sizex, sizey);  
    display_bandwidth = int(display_size.x / freq_bands.size());
  }


  void init_freq_bands_amp_offset(float [] _freq_amp_offset) {
    freq_bands_amp_offset = new ArrayList<Float>();
    for (int i = 0; i < _freq_amp_offset.length; i++ ) {
      if (i < _freq_amp_offset.length) {
        freq_bands_amp_offset.add(_freq_amp_offset[i]);
      } 
      else {
        freq_bands_amp_offset.add(_freq_amp_offset[_freq_amp_offset.length-1]);
      }        
      println ("amp offset band #" + i + ": " + freq_bands_amp_offset.get(i));
    }
  }

  void set_base_color_rgb(int r, int g, int b) {
    colorMode(RGB, 255);
    rgb_base_color = color (r, g, b);
  }

  void set_base_color_hsb(float range, float h, float s, float b) {
    colorMode(HSB, 255);
    println("set color - hsb range " + range + ": " + h + ", " + s  + ", " + b);
    float _h = map(h, 0f, range, 0f, 255f);
    float _s = map(s, 0f, range, 0f, 255f);
    float _b = map(b, 0f, range, 0f, 255f);
    println("set color - hsb range normal: " + _h + ", " + _s  + ", " + _b);
    rgb_base_color_array[0] = _h;
    rgb_base_color_array[1] = _s;
    rgb_base_color_array[2] = _b;

    rgb_base_color = color (_h, _s, _b);
    println("color set - rgb range 255: " + (rgb_base_color >> 16 & 0xFF) + ", " + (rgb_base_color >> 8 & 0xFF)  + 
      ", " + (rgb_base_color & 0xFF));
  }

  void set_base_color(color _color) {
    colorMode(HSB, 255);
    rgb_base_color = _color;
    rgb_base_color_array[0] = hue(_color);
    rgb_base_color_array[1] = saturation(_color);
    rgb_base_color_array[2] = brightness(_color);

  }

  void set_amplitude_range (float _freq_amplitude_range) {
    freq_amplitude_range = _freq_amplitude_range;
  }  

  int get_number_of_bands() {
    return freq_bands.size();
  }

  void calculate_bands_amplitude() {
    fft.forward(audio_input.mix);
    float start_freq = 0;
    float end_freq = 0;
    for (int i = 0; i < freq_bands.size(); i++) {
      start_freq = end_freq;
      end_freq = freq_bands.get(i);
      float freq_amplitude = fft.calcAvg(start_freq, end_freq) * freq_bands_amp_offset.get(i);  
      freq_amplitude = constrain(freq_amplitude, 0, freq_amplitude_range);
      freq_amplitude = freq_amplitude / freq_amplitude_range; 
      freq_bands_amp.set(i, freq_amplitude);
    }
  }

  void display_bands_as_bar() {
    background(0);
    fill(rgb_base_color);
    smooth();
    for (int i = 0; i < freq_bands.size(); i++) {
      int x_loc = i * display_bandwidth;
      float freq_amplitude = freq_bands_amp.get(i)*height;
      rect(x_loc, height - freq_amplitude, display_bandwidth, freq_amplitude);
    }
  }

  void display_bands_as_circles() {
    background(0);
    smooth();
    ellipseMode(CENTER);
    float scale_mult = 0.55;

    PVector box_size = new PVector(display_size.x*1.265,(display_size.x*1.265)/5);
    PVector box_pos = new PVector(display_position.x-(box_size.x*0.1),display_position.y-(box_size.y*0.5));
    shape(bw_box_back, box_pos.x, box_pos.y, box_size.x, box_size.y); 

    float radius_mult = 1.9;
    // hue changed from changed
    if (display_mode == 0) {
        ArrayList<Byte> temp_bytes = get_led_vals_amp2color();
        for (int i = 0; i < temp_bytes.size()/3; i ++) {
            int index_offset = i * 3;
            colorMode(RGB, 255);
            float temp_red = map(int(temp_bytes.get(index_offset+0)), 0, 127, 0, 255);
            float temp_green = map(int(temp_bytes.get(index_offset+1)), 0, 127, 0, 255);
            float temp_blue = map(int(temp_bytes.get(index_offset+2)), 0, 127, 0, 255);
            color temp_color = color(temp_red, temp_green, temp_blue, 10);
            fill(temp_color);  
            int x_loc = (int)(display_position.x + (i * display_bandwidth) + (display_bandwidth/2));
            for (float j = 1; j >= 0.1; j = j - j * 0.025f) {
               ellipse(x_loc, display_position.y, display_bandwidth*radius_mult*j, display_bandwidth*radius_mult*j);
            }
        }
    }

    // circle brightness changed
    else if (display_mode == 1) {
        ArrayList<Byte> temp_bytes = get_led_vals_amp2bright_sat(175, 35);
        for (int i = 0; i < temp_bytes.size()/3; i ++) {
            int index_offset = i * 3;
            colorMode(RGB, 255);
            float temp_red = map(int(temp_bytes.get(index_offset)), 0, 127, 0, 255);
            float temp_green = map(int(temp_bytes.get(index_offset+1)), 0, 127, 0, 255);
            float temp_blue = map(int(temp_bytes.get(index_offset+2)), 0, 127, 0, 255);
            color temp_color = color(temp_red, temp_green, temp_blue, 10);

            fill(temp_color);
            int x_loc = (int)(display_position.x + (i * display_bandwidth) + (display_bandwidth/2));
            float freq_amplitude = (float)(freq_bands_amp.get(i));
            for (float j = 1; j >= 0.1; j = j - j * 0.025f) {
               ellipse(x_loc, display_position.y, display_bandwidth*radius_mult*j, display_bandwidth*radius_mult*j);
            }
        }
    } 

    // circle radius dinamically changed
//    else if (display_mode == 2) {
//      ArrayList<Byte> temp_bytes = get_led_vals_amp2bright(100);
//      for (int i = 0; i < temp_bytes.size()/3; i ++) {
//        int index_offset = i * 3;
//        colorMode(RGB, 255);
//        fill(rgb_base_color);
//        colorMode(RGB, 127);
//        color temp_color = color(temp_bytes.get(index_offset), temp_bytes.get(index_offset+1), temp_bytes.get(index_offset+2),100);
//        int x_loc = (int)(display_position.x + (i * display_bandwidth) + (display_bandwidth/2));
//        float freq_amplitude = (brightness(temp_color)/255f);
//        ellipse(x_loc, display_position.y, freq_amplitude*display_bandwidth*radius_mult, freq_amplitude*display_bandwidth*radius_mult);
//      }
//    }
    shape(bw_box_front, box_pos.x, box_pos.y, box_size.x, box_size.y);
  }

  ArrayList<Float> get_freq_bands_amp() {
    ArrayList<Float> freq_bands_float = new ArrayList<Float>();
    for (int i = 0; i < freq_bands_amp.size() ; i ++) {
      freq_bands_float.add(freq_bands_amp.get(i));
    }
    return freq_bands_float;
  }

  void toggle_display_mode() {
    display_mode ++;
    if (display_mode >= 2) display_mode = 0;
  }

  ArrayList<Byte> get_led_vals_active_display_mode() {
    if (display_mode == 0) return get_led_vals_amp2color();
    else return get_led_vals_amp2bright(40);
  }

  ArrayList<Byte> get_led_vals_amp2bright(int min_bright) {
    ArrayList<Byte> led_bytes = new ArrayList<Byte>();
    for (int i = 0; i < freq_bands_amp.size() ; i ++) {
      colorMode(HSB, 255);
      float _h = rgb_base_color_array[0]; 
      float _s = rgb_base_color_array[1]; 
      float _b = map((rgb_base_color_array[2] * freq_bands_amp.get(i)), 0f, 255f, min_bright, 255f); 
      color temp_color = color(_h, _s, _b );

      colorMode(RGB, 255);
      led_bytes.add(byte(map((temp_color >> 16 & 0xFF), 0, 255, 0, 127)));
      led_bytes.add(byte(map((temp_color >> 8 & 0xFF), 0, 255, 0, 127)));
      led_bytes.add(byte(map((temp_color & 0xFF), 0, 255, 0, 127)));
    }
    return led_bytes;
  }      

  ArrayList<Byte> get_led_vals_amp2bright_sat(int min_bright,int min_sat) {
    ArrayList<Byte> led_bytes = new ArrayList<Byte>();
    for (int i = 0; i < freq_bands_amp.size() ; i ++) {
      colorMode(HSB, 255);
      float _h = rgb_base_color_array[0]; 
      float _s = map((rgb_base_color_array[1] * freq_bands_amp.get(i)), 0f, 255f, min_sat, 255f); 
      float _b = map((rgb_base_color_array[2] * freq_bands_amp.get(i)), 0f, 255f, min_bright, 255f); 
      color temp_color = color(_h, _s, _b);

      colorMode(RGB, 255);
      led_bytes.add(byte(map((temp_color >> 16 & 0xFF), 0, 255, 0, 127)));
      led_bytes.add(byte(map((temp_color >> 8 & 0xFF), 0, 255, 0, 127)));
      led_bytes.add(byte(map((temp_color & 0xFF), 0, 255, 0, 127)));
    }
    return led_bytes;
  }      

  ArrayList<Byte> get_led_vals_amp2color() {
    ArrayList<Byte> led_bytes = new ArrayList<Byte>();
    for (int i = 0; i < freq_bands_amp.size() ; i ++) {
      int temp_hue = 220 + int(freq_bands_amp.get(i)*160);
      colorMode(HSB, 360, 100, 100);
      color temp_color = color(temp_hue, 100, 100);
      colorMode(RGB, 255);
      led_bytes.add(byte(map((temp_color >> 16 & 0xFF), 0, 255, 0, 127)));
      led_bytes.add(byte(map((temp_color >> 8 & 0xFF), 0, 255, 0, 127)));
      led_bytes.add(byte(map((temp_color & 0xFF), 0, 255, 0, 127)));
    }       
    return led_bytes;
  }

  void stop() {
    audio_input.close();
    minim.stop();
  }
}

