import processing.core.PApplet;
import java.util.HashMap;
import java.util.ArrayList;

public class Bright_Element implements Bright_Constants {
  
    static PApplet processing_app;
    static Bright_Controller controller;
    
    static void register_applet (PApplet _processing_app) {
        processing_app = _processing_app;  
    }
  
    static void register_controller (Bright_Controller _controller) {
        controller = _controller;
    }
}
