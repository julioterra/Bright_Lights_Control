import processing.core.PApplet;
import processing.core.PVector;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;

public class Bright_Model extends Bright_Model_Abstract {

	PVector led_layout;
	int led_count;
	int color_attributes;
	private String[] resource_new = {};
	private String[][] resource_attrs_array_new = {};
	// private String[] resource_new = {"other"};
	// private String[][] resource_attrs_array_new = {{"width", "height"}};

	public Bright_Model (int _sizex, int _sizey) {		
		super();

		// ****************
		// create method that adds new resources to list
		for (int i = 0; i < resource_new.length; i++) {
			resource = processing_app.append(resource, resource_new[i]);
		}
		// ****************

		// ****************
		// create method updates all hashmaps with appropriate new resources and attributes
		// resource_attrs.put(resource_new[0], resource_attrs_array_new[0]);
		led_layout = new PVector(_sizex, _sizey);
		led_count = (int)(led_layout.x * led_layout.y);
		// ****************

		if (debug_code) {
			processing_app.println("**NEW DATA MODEL width: " + led_layout.x + " by " + led_layout.y + 
							   " total leds " + led_count);
			processing_app.println("number of resources available: " + resource.length);
			for (int i = 0; i < get_resources().length; i++) {
				processing_app.println("r" + i + " - name: " + resource[i] + "\t content size: " + get_resource_attrs(resource[i]).length);
			}
		}


	}

	void handle_iterator(String resource_name) {
		HashMap<Integer, Byte>  new_hash = new HashMap<Integer, Byte>();				
		for (int j = 0; j < led_count*resource_attrs.get("color").length; j++) {
			new_hash.put(j, (byte)0);
		}
		resources.put(resource_name, new_hash);
	}
}