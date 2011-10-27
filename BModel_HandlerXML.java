import processing.core.PApplet;
import processing.core.PVector;
import processing.xml.XMLElement;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.ArrayList;

public class BModel_HandlerXML extends Bright_Element implements Bright_Constants {

	// takes a reosource name along with a hashmap that contains that resources attributes
	BModel_ActiveRec new_record;

	public BModel_HandlerXML (String xml_file) {		

		new_record = new BModel_ActiveRec();

	  	XMLElement xml = new XMLElement(processing_app, xml_file);
		new_record.name = xml.getChild("name").getContent();
		loadSpecs(xml.getChild("specifications"));
		loadResources(xml.getChild("resources"));

	}

	void loadResources(XMLElement resources_xml) {

		new_record.resource_names = get_names(resources_xml);
		new_record.attr_names = get_attribute_names(resources_xml);
		new_record.attr_types = get_attribute_types(resources_xml);
		new_record.resources = get_content(resources_xml);

		if(debug_code) {
			processing_app.println();
		 	processing_app.println("loadResources(): \nnew resource named " + new_record.name + 
								   " has " + new_record.specs.size() + " elements:");
			Iterator it = new_record.resources.entrySet().iterator();  // Get an iterator
			while (it.hasNext()) {
				Map.Entry me = (Map.Entry)it.next();
				processing_app.print("key: " + me.getKey() + " value: " + me.getValue());
				String[] attribute_names = new_record.attr_names.get(String.valueOf(me.getKey()));
				processing_app.print("\n    attr names: ");
				for (int i = 0; i < attribute_names.length; i++) {
					processing_app.print(attribute_names[i] + " ");					
					if (attribute_names[i].contains("raw")) {

					}
				}
				processing_app.println("\n    datatype: " + String.valueOf(new_record.attr_types.get(String.valueOf(me.getKey()))));
			}			
			processing_app.println();
		}
	}

	void loadSpecs(XMLElement specs_xml) {

		new_record.spec_names = get_names(specs_xml);
		new_record.spec_attr_names = get_attribute_names(specs_xml);
		new_record.spec_attr_types = get_attribute_types(specs_xml);
		new_record.specs = get_content(specs_xml);

		if(debug_code) {
			processing_app.println();
		 	processing_app.println("loadSpecs(): \nnew_record.specs named " + new_record.name + 
								   " has " + new_record.specs.size() + " elements:");
			Iterator it = new_record.specs.entrySet().iterator();  // Get an iterator
			while (it.hasNext()) {
				Map.Entry me = (Map.Entry)it.next();
				processing_app.print("key: " + me.getKey() + " value: " + me.getValue());
				String[] attribute_names = new_record.spec_attr_names.get(String.valueOf(me.getKey()));
				processing_app.print("\n    attr names: ");
				for (int i = 0; i < attribute_names.length; i++) {
					processing_app.print(attribute_names[i] + " ");					
				}
				processing_app.println("\n    datatype: " + String.valueOf(new_record.spec_attr_types.get(String.valueOf(me.getKey()))));
			}
			processing_app.println();
		}
	}
			
	public String[] get_names (XMLElement resources_xml) {
		return resources_xml.listChildren();
	}

	public HashMap<String, String[]> get_attribute_names (XMLElement resources_xml) {
		HashMap<String, String[]> attributes_names = new HashMap<String, String[]>();
		String [] resource_names = resources_xml.listChildren();
		for (int i = 0; i < resource_names.length; i++) {
			XMLElement resource_xml = resources_xml.getChild(resource_names[i]);
			attributes_names.put(resource_xml.getName(), resource_xml.listChildren());			
			boolean debug_code = false;
			if (debug_code) {
				processing_app.println(resource_names[i] + ": added a " + 
								   		resource_xml.listChildren().length + 
										" attr array for this spec.");			
			}
		}
		return attributes_names;
	}

	public HashMap<String, HashMap> get_attribute_types (XMLElement resources_xml) {
		HashMap<String, HashMap> attributes_types = new HashMap<String, HashMap>();
		String [] resource_names = resources_xml.listChildren();
		for (int i = 0; i < resource_names.length; i++) {
			XMLElement resource_xml = resources_xml.getChild(resource_names[i]);
			HashMap <String, String> attr_datatype_hash = new HashMap <String, String>();

			// loop through each resource/spec attribute to create the content hash
			String [] children_array = resource_xml.listChildren();
			for (int j = 0; j < children_array.length; j++) {
				XMLElement attr_xml = resource_xml.getChild(children_array[j]);
				String datatype = attr_xml.getString("datatype");
				attr_datatype_hash.put(attr_xml.getName(), datatype);
			}
			attributes_types.put(resource_names[i], attr_datatype_hash);
		}
		return attributes_types;
	}

	public HashMap<String, HashMap> get_content (XMLElement resources_xml) {
		HashMap<String, HashMap> content = new HashMap<String, HashMap>();
		String [] resource_names = resources_xml.listChildren();
		String name = resources_xml.getName();

		for (int i = 0; i < resource_names.length; i++) {
			XMLElement resource_xml = resources_xml.getChild(resource_names[i]);
			HashMap <String, Object> attr_content_hash = new HashMap <String, Object>();

			// loop through each resource/spec attribute to create the content hash
			String [] children_array = resource_xml.listChildren();
			for (int j = 0; j < children_array.length; j++) {
				XMLElement attr_xml = resource_xml.getChild(children_array[j]);				
				String datatype = new_record.get_type_resource(resources_xml.getName(), resource_names[i], children_array[j]);				

				if(name.contains("resources")) {
					boolean contains_raw = children_array[j].contains("raw");
					if(!contains_raw) {
						add_resources(datatype, attr_xml.getName(), attr_content_hash);
					} 
					else if(contains_raw){
						Integer max_raw_count = new_record.raw_count();
						for (int k = 0; k < max_raw_count; k++) {
							add_resources(datatype, attr_xml.getName()+k, attr_content_hash);
						}
					}	
				}		

				else if(name.contains("specification")) {
					add_resources_init(datatype, attr_xml.getName(), attr_xml.getContent(), attr_content_hash);					
				}	
			}
			content.put(resource_names[i], attr_content_hash);
		}
		return content;
	}

	void add_resources(String datatype, String attr_name, HashMap<String, Object> active_hash) {
		boolean debug_code = false;
		if(datatype.contains("str")) {
			if (debug_code) processing_app.println("string: " + " ");
			active_hash.put(attr_name, new String(" "));
		}
		else if(datatype.contains("float")) {
			if (debug_code) processing_app.println("float: " + 0f);
			active_hash.put(attr_name, new Float(0.0));
		}
		else if(datatype.contains("int")) {
			if (debug_code) processing_app.println("integer: " + 0);
			active_hash.put(attr_name, new Integer(0));
		}
		else if(datatype.contains("byte")) {
			if (debug_code) processing_app.println("byte: (byte)0");
			active_hash.put(attr_name, (byte)0);
		}
	}

	void add_resources_init(String datatype, String attr_name, String attr_value, HashMap<String, Object> active_hash) {
		boolean debug_code = false;
		if(datatype.contains("str")) {
			if (debug_code) processing_app.println("string: " + attr_value);
			active_hash.put(attr_name, new String(attr_value));
		}
		else if(datatype.contains("float")) {
			if (debug_code) processing_app.println("float: " + Float.parseFloat(attr_value));
			active_hash.put(attr_name, Float.parseFloat(attr_value));
		}
		else if(datatype.contains("int")) {
			if (debug_code) processing_app.println("integer: " + Integer.parseInt(attr_value));
			active_hash.put(attr_name, Integer.parseInt(attr_value));
		}
		else if(datatype.contains("byte")) {
			if (debug_code) processing_app.println("byte: (byte)0 " + Byte.parseByte(attr_value));
			active_hash.put(attr_name, Byte.parseByte(attr_value));
		}
	}

}
