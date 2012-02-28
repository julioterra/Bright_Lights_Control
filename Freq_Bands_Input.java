import processing.core.PApplet;
import java.util.ArrayList;
import ddf.minim.analysis.*;
import ddf.minim.*;

public class Freq_Bands_Input extends Bright_Element implements BL_InputRealtime {

    Minim minim;
    AudioInput audio_input;
    FFT fft;
  
    // make these into a customized setting for the object
    float amplitude_bandwidth = 0f;
  
    // generated elements of the collection
    ArrayList<Integer> freq_bands = new ArrayList<Integer>();
    ArrayList<Float> freq_bands_amp_offset = new ArrayList<Float>();
    ArrayList<Float> freq_bands_amp = new ArrayList<Float>();
  

	/****************************************
	/****************************************
	 ** CONSTRUCTORS
	 **/

    public Freq_Bands_Input () {
		init_minim();    
	}

    public Freq_Bands_Input (int _start_freq, float _freq_bands_width) {
		init_minim();
        init_freq_bands_array(_start_freq, _freq_bands_width);      
    }  


	/****************************************
	/****************************************
	 ** INIT FUNCTIONS
	 **/
	
	private void init_minim() {
		minim = new Minim(processing_app);  
        // initialize the audio input object
        audio_input = minim.getLineIn(Minim.STEREO, 512);
        // initialize the FFT object that has a time-domain buffer the same size as audio_input's sample buffer
        fft = new FFT(audio_input.bufferSize(), audio_input.sampleRate());
        // set window type to hamming
        fft.window(FFT.HAMMING);
        init_amplitude_bandwidth(150f);
	}

    // initialize the freq bands based on the starting frequency and number of frequency bands 
    public int init_freq_bands_array(int _start_freq, float _freq_bands_width) {
        for (float end_freq = _start_freq; end_freq < audio_input.sampleRate() / 2; end_freq = end_freq * _freq_bands_width) {
          processing_app.println ("end frequency #" + freq_bands.size() + ": " + (int)(end_freq));
          freq_bands.add((int)(end_freq));
          freq_bands_amp.add(0f);
        }
        return freq_bands.size();
    }

	// initialize the amplitude offset for each frequency bands
    public void init_freq_bands_amp_offset(float [] _freq_amp_offset) {
        freq_bands_amp_offset = new ArrayList<Float>();
        for (int i = 0; i < freq_bands.size(); i++ ) {
            if (i < _freq_amp_offset.length) { freq_bands_amp_offset.add(_freq_amp_offset[i]); } 
            else { freq_bands_amp_offset.add(_freq_amp_offset[_freq_amp_offset.length-1]); }        
            processing_app.println ("amp offset band #" + i + ": " + freq_bands_amp_offset.get(i));
        }
    }

	// initialize the overall amplitude bandwith
    public void init_amplitude_bandwidth (float _amplitude_bandwidth) {
      amplitude_bandwidth = _amplitude_bandwidth;
    }  


	/****************************************
	/****************************************
	 ** INTERFACE FUNCTIONS
	 **/

    public int get_realtime_data_array_size() {
      return freq_bands.size();
    }

	public ArrayList<Float> get_realtime_data() {
      fft.forward(audio_input.mix);
      float end_freq = 0;
      for (int i = 0; i < freq_bands.size(); i++) {
        float start_freq = end_freq;
        end_freq = freq_bands.get(i);
        float freq_amplitude = (fft.calcAvg(start_freq, end_freq) * freq_bands_amp_offset.get(i)) / amplitude_bandwidth;  
        freq_bands_amp.set(i, freq_amplitude);
      }
       return freq_bands_amp;		
	}


	/****************************************
	/****************************************
	 ** CONTRAL FUNCTIONS
	 **/

    public void stop() {
        audio_input.close();
        minim.stop();
    }
  
}

