import processing.opengl.*;
import processing.serial.*;
import controlP5.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

public class Bright_Lights_Control extends PApplet implements Bright_Constants{

    boolean serial_connected = false;
    
    // Interface control objects
        ControlP5 controlP5;
        RadioButton on_radio_button;
        RadioButton mode_radio_button;
        RadioButton scroll_radio_button;
    
        User_Interface_Input user_interface;
        Physical_Devices_Output physical_output;
        Bright_Controller controller;
        Freq_Bands_Input freq_bands_obj;
        Display_Box display_box_obj;
    
        // Interface state message variables
        int interaction_mode = 0;
    
        // audio freq analysis variables 
        float freq_band_mult_init = 2.5;
        int setup_band_freq_init = 20;
    	// float freq_amplitude_range_init =150f;
        float [] freq_amp_offset_init = {1f,1f,1f,3f,5f,8f,14f,20f};

    void setup () {
         // set the window size:
        size(900,350);
        background(0);
        Bright_Element.register_applet (this);

        physical_output = new Physical_Devices_Output();
        physical_output.connect_serial("/dev/tty.BlueJulio-M1");
    
        freq_bands_obj = new Freq_Bands_Input(this,setup_band_freq_init, freq_band_mult_init);
        freq_bands_obj.init_freq_bands_amp_offset(freq_amp_offset_init);
    
        user_interface = new User_Interface_Input(this, physical_output, freq_bands_obj);
        controller = new Bright_Controller(user_interface);     
        Bright_Element.register_controller (controller);
        
        display_box_obj = new Display_Box(this, freq_bands_obj);    
        display_box_obj.init_size(600, 250);    
        display_box_obj.init_pos(100, 140);

        controller.register_physical_output(physical_output); 
        controller.register_display_output(display_box_obj);
        controller.register_input(freq_bands_obj);
        
        freq_bands_obj.init_connect_display_link(display_box_obj);
        
		// device_states = new BModel_Handler();
		BModel_HandlerXML device_handler = new BModel_HandlerXML("BModel_TempPhysicalBW.xml");
		BModel_HandlerXML device_handler_2 = new BModel_HandlerXML("BModel_TempPhysicalBW2.xml");
		BModel_HandlerXML device_handler_3 = new BModel_HandlerXML("BModel_TempPhysicalBW3.xml");

    }

	void readXMLElement(XMLElement element, String prefix) {
		int sub_elements = element.getChildCount();
	  	for (int i = 0; i < sub_elements; i++) {
			XMLElement xmlChild = element.getChild(i);
		    String name = xmlChild.getName(); 		
			int children = xmlChild.getChildCount();
		  	print(prefix + "-" + name);
			if (children > 0) {
			    println(); 
				readXMLElement(xmlChild, prefix + "  ");
			}
			else {
				String content = xmlChild.getContent();
			    println(": " + content);    			
			}
		}
	}
    
    void draw () {
        display_box_obj.display_box();
        
        if(controller.get_interaction_mode() == 4) {
            ArrayList<Byte> realtime_msg = freq_bands_obj.calculate_bands_amplitude();  
			if (controller.is_on()) {
	            physical_output.send_serial_msg_arraylist(MODE_MSG_realtime, realtime_msg);
			}
        }
        else if(controller.get_interaction_mode() == 5) {
            freq_bands_obj.calculate_bands_amplitude();  
        }
    }
    
    void stop () {
      println("getting ready to close shop.");
      physical_output.stop();  
      freq_bands_obj.stop();
      println("closed minim.");
      super.stop();  
    }
    
    
    void controlEvent(ControlEvent theEvent) {
//        println("EVENT RECEIVED IN MAIN APP");
        user_interface.controlEvent(theEvent); 
    }
    
    void serialEvent(Serial newPort) {
        physical_output.serialEvent(newPort);
    }
    
    void keyPressed() {
        freq_bands_obj.toggle_realtime_mode();
    }

}

