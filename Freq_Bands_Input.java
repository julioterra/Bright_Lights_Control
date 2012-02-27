import processing.core.PApplet;
import java.util.HashMap;
import java.util.ArrayList;
import ddf.minim.analysis.*;
import ddf.minim.*;

public class Freq_Bands_Input extends Bright_Element {

    Minim minim;
    AudioInput audio_input;
    FFT fft;
  
    // make these into a customized setting for the object
    float init_freq_band_mult = 0;
    int init_band_freq = 0;
    float amplitude_bandwidth = 0f;
    float amplitude_bandwidth_mult = 1f;
    float [] rgb_base_color_array = new float[3];
  
    // ** REMOVE FROM THIS CLASS display class objects
    int realtime_mode = 1;
    int realtime_modes_total = 2;
  
    boolean display_linked;
    Display_Box display_link;
  
    // generated elements of the collection
    ArrayList<Integer> freq_bands = new ArrayList<Integer>();
    ArrayList<Float> freq_bands_amp_offset = new ArrayList<Float>();
    ArrayList<Float> freq_bands_amp = new ArrayList<Float>();
  
    // constructor   
    public Freq_Bands_Input (PApplet _this_app, int _init_band_freq, float _init_freq_band_mult) {
        minim = new Minim(processing_app);  
        // initialize the audio input object
        audio_input = minim.getLineIn(Minim.STEREO, 512);
        // initialize the FFT object that has a time-domain buffer the same size as audio_input's sample buffer
        fft = new FFT(audio_input.bufferSize(), audio_input.sampleRate());
        // set window type to hamming
        fft.window(FFT.HAMMING);
    
        // initialize the freq_bands array  
        init_band_freq = _init_band_freq; 
        init_freq_band_mult = _init_freq_band_mult;
        init_freq_bands_array(_init_band_freq, _init_freq_band_mult);      
        set_amplitude_bandwidth(150f);
        display_linked = false;
    }  

    void init_connect_display_link(Display_Box _display_link) {
        display_link = _display_link;  
        display_linked = true;
        processing_app.println("connected to display");
    }

    int init_freq_bands_array(int _init_band_freq, float _init_freq_band_mult) {
        // initialize the freq bands based on starting init_band_freq and init_freq_band_mult 
        for (float end_freq = init_band_freq; end_freq < audio_input.sampleRate() / 2; end_freq = end_freq * init_freq_band_mult) {
          processing_app.println ("end frequency #" + freq_bands.size() + ": " + (int)(end_freq));
          freq_bands.add((int)(end_freq));
          freq_bands_amp.add(0f);
        }
        return freq_bands.size();
    }

    void init_freq_bands_amp_offset(float [] _freq_amp_offset) {
        freq_bands_amp_offset = new ArrayList<Float>();
        for (int i = 0; i < freq_bands.size(); i++ ) {
            if (i < _freq_amp_offset.length) { freq_bands_amp_offset.add(_freq_amp_offset[i]); } 
            else { freq_bands_amp_offset.add(_freq_amp_offset[_freq_amp_offset.length-1]); }        
            processing_app.println ("amp offset band #" + i + ": " + freq_bands_amp_offset.get(i));
        }
    }

    void toggle_realtime_mode() {
      realtime_mode ++;
      if (realtime_mode >= realtime_modes_total) realtime_mode = 0;
    }

	int get_realtime_mode() {
		return realtime_mode;
	}

    void set_base_color_hsb(float range, float h, float s, float b) {
        processing_app.colorMode(processing_app.HSB, 255);
        processing_app.println("set color - hsb range " + range + ": " + h + ", " + s  + ", " + b);
        rgb_base_color_array[0] = processing_app.map(h, 0f, range, 0f, 255f);
        rgb_base_color_array[1] = processing_app.map(s, 0f, range, 0f, 255f);
        rgb_base_color_array[2] = processing_app.map(b, 0f, range, 0f, 255f);
    }

    void set_amplitude_bandwidth_mult (float _amplitude_bandwidth) {
      amplitude_bandwidth_mult = _amplitude_bandwidth;
    }  

    void set_amplitude_bandwidth (float _amplitude_bandwidth) {
      amplitude_bandwidth = _amplitude_bandwidth;
    }  

    int get_number_of_bands() {
      return freq_bands.size();
    }

	public ArrayList<Float> get_bands_amplitude() {
      fft.forward(audio_input.mix);
      float start_freq = 0;
      float end_freq = 0;
      for (int i = 0; i < freq_bands.size(); i++) {
        start_freq = end_freq;
        end_freq = freq_bands.get(i);
        float freq_amplitude = fft.calcAvg(start_freq, end_freq) * freq_bands_amp_offset.get(i);  
        freq_amplitude = freq_amplitude / (amplitude_bandwidth*amplitude_bandwidth_mult); 
        freq_bands_amp.set(i, freq_amplitude);
      }
       return freq_bands_amp;		
	}

    void stop() {
        audio_input.close();
        minim.stop();
    }
  
}

