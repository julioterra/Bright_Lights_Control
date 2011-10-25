import processing.core.PApplet;
import java.util.HashMap;
import java.util.ArrayList;

public class Bright_Element implements Bright_Constants {
  
    static PApplet processing_app;
    static Bright_Controller controller;
	static HashMap<String, BModel_ActiveRec> devices;
    boolean debug_code = true;

	
    static void register_applet (PApplet _processing_app) {
        processing_app = _processing_app;  
    }
  
    static void register_controller (Bright_Controller _controller) {
        controller = _controller;
    }

    static void init_models_hash () {
		devices = new HashMap<String, BModel_ActiveRec>();
    }

    static void register_model (String name, BModel_ActiveRec new_model) {
		devices.put(name, new_model);		
    }

}
