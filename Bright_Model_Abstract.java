import processing.core.PApplet;
import processing.core.PVector;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;

public class Bright_Model_Abstract extends Bright_Element implements Bright_Constants {

	// PVector led_layout;
	int led_count;
	int color_attributes;

	// takes a reosource name along with a hashmap that contains that resources attributes
	public HashMap<String, HashMap> resources;
	public HashMap<String, String[]> resource_attrs;
	public String[] resource = {};
	private String[] resource_new = {"dimensions", "color", "strobe", "scroll", "realtime"};
	public String[][] resource_attrs_array = {  {"width", "height"},
												{"hue", "saturation", "brightness"},
								  				{"speed"},
								  				{"speed", "direction", "width"},
								  				{"iterator"}};
	
	public Bright_Model_Abstract () {		

		for (int i = 0; i < resource_new.length; i++) {
			resource = processing_app.append(resource, resource_new[i]);
		}

		// load the resource attribute hashmap
		resource_attrs = new HashMap<String, String[]>();
		for (int i = 0; i < resource.length && i < resource_attrs_array.length; i++) {
			resource_attrs.put(resource[i], resource_attrs_array[i]);
		}

		// load the resource attribute hashmap
		resources = new HashMap<String, HashMap>();
		for (int i = 0; i < resource.length && i < resource_attrs_array.length; i++) {
			if(resource_attrs_array[i][0].contains("iterator")) {
				handle_iterator(resource[i]);
			} else {
				handle_attributes(resource[i]);
			}
		}
			
		if (debug_code) {
			processing_app.println("** NEW ABSTRACT MODEL number of resources available: " + resource_attrs.size());
			for (int i = 0; i < get_resources().length; i++) {
				processing_app.println("r" + i + " - name: " + resource[i] + "\t content size: " + get_resource_attrs(resource[i]).length);
				for (int j = 0; j < get_resource_attrs(resource[i]).length; j++) {
					processing_app.println("\tattr " + j + " " + get_resource_attrs(resource[i])[j]);
				}			
			}
		}

	}


	// method that should be defined by sub-classes
	void handle_iterator(String resource_name) {	
	}

	void handle_attributes(String resource_name) {
		HashMap<String, Float> new_hash = new HashMap<String, Float>();
		for (int j = 0; j < resource_attrs.get(resource_name).length; j++) {
			new_hash.put(resource_attrs.get(resource_name)[j], 0f);
		}
		resources.put(resource_name, new_hash);
	}

	String[] get_resources() {
		return resource;
	}
	
	String[] get_resource_attrs(String resource_name) {
		String [] new_string = (String[]) resource_attrs.get(resource_name);
		return new_string;
	}

	Byte[] get_iterator(String resource_name) {
		String [] new_string = (String[]) resource_attrs.get(resource_name);
		Byte [] new_bytes;
		if (!new_string[0].contains("iterator")) {
			new_bytes = new Byte[0];
		}
		else {
			HashMap<Integer, Byte> int_hash = resources.get(resource_name);
			new_bytes = new Byte[int_hash.size()];
			for (int i = 0; i < int_hash.size(); i++) {
				new_bytes[i] = int_hash.get(i);
			}
		}
		return new_bytes;
	}

}
