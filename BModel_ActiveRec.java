import processing.core.PApplet;
import processing.core.PVector;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.ArrayList;

public class BModel_ActiveRec extends Bright_Element {

	public String name;
	
	// takes a reosource name along with a hashmap that contains that resources attributes
	public String[] resource_names;
	public HashMap<String, String[]> attr_names;	

	public HashMap<String, HashMap> resources;
	public HashMap<String, Object> resource;
	public HashMap<String, HashMap> attr_types;
	public HashMap<String, String> attr_type;

	public HashMap<String, HashMap> attr_ranges;
	public HashMap<String, PVector> attr_range;

	public String[] spec_names;
	public HashMap<String, String[]> spec_attr_names;	
	public HashMap<String, HashMap> specs;
	public HashMap<String, HashMap> spec;
	public HashMap<String, HashMap> spec_attr_types;
	public HashMap<String, String> spec_attr_type;
	
	BModel_ActiveRec() {
		name = "";
		
		resource_names = new String[0];
		attr_names = new HashMap<String, String[]>();
		resources = new HashMap<String, HashMap>();
		resource = new HashMap<String, Object>();
		attr_types = new HashMap<String, HashMap>();
		attr_type = new HashMap<String, String>();
		attr_ranges = new HashMap<String, HashMap>();		
		attr_range = new HashMap<String, PVector>();		

		spec_names = new String[0];
		spec_attr_names = new HashMap<String, String[]>();
		specs = new HashMap<String, HashMap>();		
		spec = new HashMap<String, HashMap>();
		spec_attr_types = new HashMap<String, HashMap>();
		spec_attr_type = new HashMap<String, String>();

		debug_code = false;
	}
	
	public String get_type_resource(String category, String resource, String attribute) {
		attr_type = new HashMap<String, String>();
		if (category.contains("resource")) {
			attr_type = attr_types.get(resource);
		} else {
			attr_type = spec_attr_types.get(resource);			
		}

		if (debug_code) {
			processing_app.println("get_type_resource(): get_type_resource - " + attr_type.get(attribute));
		}
		return attr_type.get(attribute);
	}

	public Integer raw_count() { 
		Integer columns;
		Integer rows;
		Integer raw_ctrls;
		try {
			columns = Integer.parseInt(String.valueOf(specs.get("layout").get("columns")));
			rows = Integer.parseInt(String.valueOf(specs.get("layout").get("rows")));
			raw_ctrls = 3;
		}
		catch (Exception e) {
			columns = 0;
			rows = 0;
			raw_ctrls = 3;
		}
		
		if (debug_code) {
			processing_app.println("columns: " + columns + " rows: " + rows + " controls: " + raw_ctrls);
		}
		
		return columns * rows * raw_ctrls;
	}
}