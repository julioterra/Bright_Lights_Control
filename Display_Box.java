import processing.core.PApplet;
import processing.core.PVector;
import processing.core.PShape;
import java.util.HashMap;
import java.util.ArrayList;

public class Display_Box extends Bright_Element {

  Freq_Bands_Input freq_bands_obj;
  
  // display class objects
  PVector display_leds_nums;
  PVector display_position;
  ArrayList<PVector> display_size_active;
  PVector display_size;
  ArrayList<PVector> display_position_active;
  ArrayList<Integer> display_colors_active;

  PShape bw_box_front;
  PShape bw_box_back;

  float rgb_color[] = {0,0,0};
  int scroll_msg[] = {4,0,0};
  int strobe_msg[] = {0};
  
  int display_bandwidth = 0;
  int display_mode = 1;
  int display_modes_total = 5;
  int realtime_mode = 0;

  // constructor   
    Display_Box (PVector _display_leds_nums) {
	      bw_box_front = processing_app.loadShape("bright_front_new.svg");
	      bw_box_back= processing_app.loadShape("bright_back.svg");
		  display_leds_nums = _display_leds_nums;
		
	      display_colors_active = new ArrayList<Integer>();
	      for (int i = 0; i < display_leds_nums.x * display_leds_nums.y; i ++) {
	          display_colors_active.add(0);
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
    	display_mode = processing_app.constrain(_mode, 0, display_modes_total-1);
    }
    
    void init_pos(int posx, int posy) {
    	display_position = new PVector ((posx+display_bandwidth/2), posy);
    }
  
    void init_size(int sizex, int sizey) {
      display_size = new PVector (sizex, sizey);  
      display_bandwidth = (int)(display_size.x / display_leds_nums.x);
    }
  
    void set_color_hsb(float range, float h, float s, float b) {
      processing_app.colorMode(processing_app.HSB, 255);
      processing_app.println("set color - hsb range " + range + ": " + h + ", " + s  + ", " + b);
      rgb_color[0] = processing_app.map(h, 0f, range, 0f, 255f);
      rgb_color[1] = processing_app.map(s, 0f, range, 0f, 255f);
      rgb_color[2] = processing_app.map(b, 0f, range, 0f, 255f);
    }
  
    void set_strobe(float range, float _strobe_speed) {
      
      
    }

    void set_scroll(int range, int _scroll_speed, int _scroll_direction, float _scroll_width) {
      
      
    }

    void display_realtime_freq_bands(ArrayList<Byte> _new_bytes) {
        display_mode = 4;
        float radius_mult = 1.9f;
        
        // hue changed from changed
        for (int i = 0; i < _new_bytes.size()/3; i ++) {
            int index_offset = i * 3;
            processing_app.colorMode(processing_app.RGB, 255);
            float temp_red = processing_app.map((int)(_new_bytes.get(index_offset+0)), 0, 100, 0, 255);
            float temp_green = processing_app.map((int)(_new_bytes.get(index_offset+1)), 0, 100, 0, 255);
            float temp_blue = processing_app.map((int)(_new_bytes.get(index_offset+2)), 0, 100, 0, 255);
            int temp_color = processing_app.color(temp_red, temp_green, temp_blue, 10);
            processing_app.colorMode(processing_app.HSB, 255);
            float freq_amplitude = (processing_app.brightness(temp_color)/255f);
            int x_loc = (int)(display_position.x + (i * display_bandwidth) + (display_bandwidth/2));

            display_colors_active.set(i, temp_color);
            display_size_active.set(i, new PVector((display_bandwidth*radius_mult*freq_amplitude), (display_bandwidth*radius_mult*freq_amplitude)));
            display_position_active.set(i, new PVector(x_loc, display_position.y));  
        }
    }
    
    void display_box() {
        processing_app.colorMode(processing_app.HSB, 255);
        processing_app.background(processing_app.color(255, 0, 200));
        processing_app.smooth();
        processing_app.ellipseMode(processing_app.CENTER);
        float scale_mult = 0.55f;
    
        PVector box_size = new PVector((float)(display_size.x*1.265),(float)((display_size.x*1.265)/5));
        PVector box_pos = new PVector((float)(display_position.x-(box_size.x*0.1)),(float)(display_position.y-(box_size.y*0.5)));

        processing_app.shape(bw_box_back, box_pos.x, box_pos.y, box_size.x, box_size.y);           

       // if (display_mode == 1 && display_mode == 4) {
            for (int i = 0; i < display_leds_nums.x * display_leds_nums.y; i ++) {
                processing_app.fill(display_colors_active.get(i));           
                PVector temp_size = new PVector(display_size_active.get(i).x, display_size_active.get(i).y);   
                PVector temp_pos = new PVector(display_position_active.get(i).x, display_position_active.get(i).y);   
                for (float j = 1; j >= 0.1; j = j - j * 0.025f) {
                   processing_app.ellipse(temp_pos.x, temp_pos.y, temp_size.x*j, temp_size.y*j);
                }
            }
       // }
       processing_app.shape(bw_box_front, box_pos.x, box_pos.y, box_size.x, box_size.y);

    }

}

