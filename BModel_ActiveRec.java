import processing.core.PApplet;
import processing.core.PVector;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.ArrayList;

public class BModel_ActiveRec extends Bright_Element {

	// takes a reosource name along with a hashmap that contains that resources attributes
	public String[] resource_names;
	public HashMap<String, String[]> attr_names;	
	public HashMap<String, HashMap> resources;
	public HashMap<String, Object> resource;
	public HashMap<String, HashMap> attr_types;
	public HashMap<String, String> attr_type;
	public HashMap<String, PVector[]> attr_ranges;
	// public HashMap<String, Boolean> resources_active;	

	public String[] spec_names;
	public HashMap<String, String[]> spec_attr_names;	
	public HashMap<String, HashMap> specs;
	public HashMap<String, HashMap> spec;
	public HashMap<String, HashMap> spec_attr_types;
	public HashMap<String, String> spec_attr_type;
	
	// public HashMap<String, Boolean> spec_active;	
	
	BModel_ActiveRec() {
		resource_names = new String[0];
		attr_names = new HashMap<String, String[]>();
		resources = new HashMap<String, HashMap>();
		attr_types = new HashMap<String, HashMap>();
		attr_ranges = new HashMap<String, PVector[]>();		
		// resources_active = new HashMap<String, Boolean>();	

		resource = new HashMap<String, Object>();
		attr_type = new HashMap<String, String>();
		spec = new HashMap<String, HashMap>();
		spec_attr_type = new HashMap<String, String>();

		spec_names = new String[0];
		spec_attr_names = new HashMap<String, String[]>();
		specs = new HashMap<String, HashMap>();		
		spec_attr_types = new HashMap<String, HashMap>();

		debug_code = false;
		// spec_active = new HashMap<String, Boolean>();	
	}
	
	public String get_type_resource(String resource, String attribute) {
		attr_type = new HashMap<String, String>();
		attr_type = attr_types.get(resource);
		if (debug_code) {
			processing_app.println("get_type_resource(): get_type_resource - " + attr_type.get(attribute));
		}
		return attr_type.get(attribute);
	}

	// public String get_attribute_resource(String resource, String attribute) {
	// 	String[] attr_name = attr_names.get(resource);
	// 	String attribute 
	// 	for
	// 	if (debug_code) {
	// 		processing_app.println("get_type_resource(): get_type_resource - " + attr_name.get(attribute));
	// 	}
	// 	return attr_name.get(attribute);
	// }
	
}