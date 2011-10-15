class Freq_Bands {

    Minim minim;
    AudioInput audio_input;
    FFT fft;
    
    // make these into a customized setting for the object
    float freq_band_mult = 0;
    int setup_band_freq = 0;
    float freq_amplitude_range = 0;
    int band_width_display = 0;
    
    color rgb_base_color = color (255, 255, 255);
    int display_mode = 1;
    
    // generated elements of the collection
    ArrayList<Integer> freq_bands = new ArrayList<Integer>();
    ArrayList<Float> freq_bands_amp_offset = new ArrayList<Float>();
    ArrayList<Float> freq_bands_amp = new ArrayList<Float>();
    ArrayList<Float> freq_bands_amp_float = new ArrayList<Float>();

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
        init_freq_bands_array();
      
        set_amplitude_range(150f);  
    }  

    void init_freq_bands_array() {
         // initialize the freq bands based on starting setup_band_freq and freq_band_mult 
        for (float end_freq = setup_band_freq; end_freq < audio_input.sampleRate() / 2; end_freq = end_freq * freq_band_mult) {
           println ("end frequency #" + freq_bands.size() + ": " + int(end_freq));
          freq_bands.add(int(end_freq));
          freq_bands_amp.add(0f);
        }
        band_width_display = width / freq_bands.size();
    }
    
    void init_freq_bands_amp_offset(float [] _freq_amp_offset) {
        freq_bands_amp_offset = new ArrayList<Float>();
        for(int i = 0; i < _freq_amp_offset.length; i++ ) {
            if (i < _freq_amp_offset.length) {
                freq_bands_amp_offset.add(_freq_amp_offset[i]); 
            } else {
                freq_bands_amp_offset.add(_freq_amp_offset[_freq_amp_offset.length-1]);  
            }        
            println ("amp offset band #" + i + ": " + freq_bands_amp_offset.get(i));
        }
    }
    
    void set_base_color_rgb(int r, int g, int b) {
        colorMode(RGB);
        rgb_base_color = color (r, g, b);
    }
    
    void set_base_color(color _color) {
        rgb_base_color = _color;
    }
    
    void set_amplitude_range (float _freq_amplitude_range) {
        freq_amplitude_range = _freq_amplitude_range;
    }  

    int get_number_of_bands() {
       return freq_bands.size();
    }
    
    void calculate_bands_amplitude(){
      fft.forward(audio_input.mix);
      float start_freq = 0;
      float end_freq = 0;
      for(int i = 0; i < freq_bands.size(); i++)  {
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
      fill(color(255,0,0));
      smooth();
      for(int i = 0; i < freq_bands.size(); i++)  {
        int x_loc = i * band_width_display;
        float freq_amplitude = freq_bands_amp.get(i)*height;
        rect(x_loc, height - freq_amplitude, band_width_display, freq_amplitude);
      }
    }
    
    void display_bands_as_circles() {
        background(0);
        smooth();
        ellipseMode(CENTER);
        
        if (display_mode == 0) {
            ArrayList<Byte> temp_bytes = get_led_vals_amp2bright();
            fill(color(255,0,0));
            for(int i = 0; i < temp_bytes.size()/3; i ++)  {
                int index_offset = i * 3;
                float freq_amplitude = float(temp_bytes.get(index_offset))/127f;
                
                int x_loc = (i * band_width_display) + (band_width_display/2);
                ellipse(x_loc, height/2, freq_amplitude*band_width_display, freq_amplitude*band_width_display);
            }  
        } 
        else if (display_mode == 1) {
            ArrayList<Byte> temp_bytes = get_led_vals_amp2color();
            for(int i = 0; i < temp_bytes.size()/3; i ++)  {
                int index_offset = i * 3;
                float temp_red = map(int(temp_bytes.get(index_offset+0)),0,100,0,255);
                float temp_green = map(int(temp_bytes.get(index_offset+1)),0,100,0,255);
                float temp_blue = map(int(temp_bytes.get(index_offset+2)),0,100,0,255);
                
                color temp_color = color(temp_red,temp_green,temp_blue);
                fill(temp_color);  
                int x_loc = (i * band_width_display) + (band_width_display/2);
                ellipse(x_loc, height/2, band_width_display, band_width_display);
            }  
        }
    }
    
    ArrayList<Float> get_freq_bands_amp() {
       ArrayList<Float> freq_bands_float = new ArrayList<Float>();
       for (int i = 0; i < freq_bands_amp.size() ; i ++) {
           freq_bands_float.add(freq_bands_amp.get(i));
       }
       return freq_bands_float;
    }
    
    ArrayList<Byte> get_led_vals_amp2bright() {
       ArrayList<Byte> led_bytes = new ArrayList<Byte>();
       for (int i = 0; i < freq_bands_amp.size() ; i ++) {
           led_bytes.add(byte(freq_bands_amp.get(i) * map(red(rgb_base_color), 0, 255, 0, 127)));
           led_bytes.add(byte(freq_bands_amp.get(i) * map(green(rgb_base_color), 0, 255, 0, 127)));
           led_bytes.add(byte(freq_bands_amp.get(i) * map(blue(rgb_base_color), 0, 255, 0, 127)));
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
