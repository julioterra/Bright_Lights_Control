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
	BModel_TempControl data_model;

	public BModel_HandlerXML () {		

		data_model = new BModel_TempControl();
		new_record = new BModel_ActiveRec();

	  	XMLElement xml = new XMLElement(processing_app, "BModel_TempPhysicalBW.xml");
		XMLElement specs_xml = xml.getChild("specifications");
		XMLElement resources_xml = xml.getChild("resources");		

		loadSpecs(specs_xml);

		// NEW_RECORD.SPEC_NAMES
		// update the array with specification names only
		//%%%%%%%%%%%%%%%%%%%%%%%%%%%
		new_record.resource_names = resources_xml.listChildren();
		//%%%%%%%%%%%%%%%%%%%%%%%%%%%

		// NEW_RECORD.SPECT_ATTR_NAMES
		// update the HashMap with specification attribute names
		for (int i = 0; i < new_record.resource_names.length; i++) {
			XMLElement resource_xml = resources_xml.getChild(new_record.resource_names[i]);

			//%%%%%%%%%%%%%%%%%%%%%%%%%%%
			new_record.spec_attr_names.put(resource_xml.getName(), resource_xml.listChildren());			
			//%%%%%%%%%%%%%%%%%%%%%%%%%%%
			
			if (debug_code) {
				processing_app.println(new_record.resource_names[i] + ": added a " + 
								   resource_xml.listChildren().length + "-attr array for this spec.");			
			}
		}

		// NEW_RECORD.SPEC_ATTR_TYPES
		// update the HashMap with attributes types
		for (int i = 0; i < new_record.resource_names.length; i++) {
			XMLElement resource_xml = resources_xml.getChild(new_record.resource_names[i]);
			HashMap <String, String> attr_datatype_hash = new HashMap <String, String>();
			// loop through each resource/spec attribute to create the content hash
			String [] children_array = resource_xml.listChildren();
			for (int j = 0; j < children_array.length; j++) {
				XMLElement attr_xml = resource_xml.getChild(children_array[j]);
				String datatype = attr_xml.getString("datatype");
				attr_datatype_hash.put(attr_xml.getName(), datatype);
			}
			
			//%%%%%%%%%%%%%%%%%%%%%%%%%%%
			new_record.attr_types.put(new_record.resource_names[i], attr_datatype_hash);
			//%%%%%%%%%%%%%%%%%%%%%%%%%%%
		}		
		
		// HashMap<String, Integer>
		
		// NEW_RECORD.RESOURCES
		// update the HashMap with specification content
		for (int i = 0; i < new_record.resource_names.length; i++) {
			XMLElement resource_xml = resources_xml.getChild(new_record.resource_names[i]);
			HashMap <String, Object> attr_content_hash = new HashMap <String, Object>();
			// loop through each resource/spec attribute to create the content hash
			String [] children_array = resource_xml.listChildren();
			for (int j = 0; j < children_array.length; j++) {
				XMLElement attr_xml = resource_xml.getChild(children_array[j]);
				
				// CONVERT 
				String datatype = new_record.get_type_resource(new_record.resource_names[i], children_array[j]);
				
				// processing_app.println("datatype " + datatype);
				// String data_attr = new_record.get_attribute_resource(new_record.resource_names[i], children_array[j]);
				// processing_app.println("attribute " + data_attr);

				if(children_array[j].contains("raw")) {
					processing_app.println("creating iterator: " + children_array[j]);
					// attr_content_hash.put(attr_xml.getName(), new Integer(0));
					Integer columns = Integer.valueOf((String)new_record.specs.get("layout").get("columns"));
					Integer rows = Integer.valueOf((String)new_record.specs.get("layout").get("rows"));
					processing_app.println("columns: " + columns + " rows " + rows);
					for (int k = 0; k < (rows*columns*3) ; k++) {
						add_resources(datatype, attr_xml.getName(), attr_content_hash);
					}
				} 
				else {
					add_resources(datatype, attr_xml.getName(), attr_content_hash);
				}				
			}

			//%%%%%%%%%%%%%%%%%%%%%%%%%%%
			new_record.resources.put(new_record.resource_names[i], attr_content_hash);
			//%%%%%%%%%%%%%%%%%%%%%%%%%%%
		}				
		
		// 
		if(debug_code) {
		 	processing_app.println("BModel_HandlerXML(): new_record.resources has " + new_record.resources.size() + " elements:");

			for (int i = 0; i < new_record.resource_names.length; i++) {			
			// Iterator it = new_record.resources.entrySet().iterator();  // Get an iterator
			// while (it.hasNext()) {
			// Map.Entry me = (Map.Entry)it.next();
				processing_app.println("key: " + new_record.resource_names[i] + 
									 " value: " + new_record.resources.get(new_record.resource_names[i]));

				// String[] attribute_names = new_record.attr_names.get(new_record.resource_names[i]);
				// processing_app.print("\n    attr names: " + attribute_names);
				// for (int j = 0; j < attribute_names.length; j++) {
				// 	processing_app.print(attribute_names[j] + " ");					
				// }
				// processing_app.println("\n    datatype: " + String.valueOf(new_record.attr_types.get(new_record.resource_names[i])));
			}
			
			processing_app.println();
			processing_app.println();
		}				

		// if (debug_code) {
			// processing_app.println("Specs from XML:");
			// readXMLElement(specs_xml, "++");
			// processing_app.println("Resources from XML:");
			// readXMLElement(resources_xml, "--");
			// 
			// processing_app.print("BModel_Handler ******** NEW Active Record ");
			// processing_app.println("Record Template: " + data_model.name);
		// }

	}
	
	void add_resources(String datatype, String attr_name, HashMap<String, Object> active_hash) {
		if(datatype.contains("str")) {
			processing_app.println("adding empty string: " + " ");
			active_hash.put(attr_name, " ");
		}
		else if(datatype.contains("float")) {
			processing_app.println("adding float: " + 0f);
			active_hash.put(attr_name, 0f);
		}
		else if(datatype.contains("int")) {
			processing_app.println("adding integer: " + 0);
			active_hash.put(attr_name, 0);
		}
		else if(datatype.contains("byte")) {
			processing_app.println("adding byte: (byte)0");
			active_hash.put(attr_name, (byte)0);
		}
	}
	

	void loadSpecs(XMLElement specs_xml) {
		// NEW_RECORD.SPEC_NAMES
		// update the array with specification names only
		new_record.spec_names = specs_xml.listChildren(); 

		// NEW_RECORD.SPECT_ATTR_NAMES
		// update the HashMap with specification attribute names
		for (int i = 0; i < new_record.spec_names.length; i++) {
			XMLElement resource_xml = specs_xml.getChild(new_record.spec_names[i]);
			new_record.spec_attr_names.put(resource_xml.getName(), resource_xml.listChildren());
			processing_app.println(new_record.spec_names[i] + ": added a " + resource_xml.listChildren(). length + 
								   "-attr array for this spec.");			
		}
		// NEW_RECORD.SPEC_ATTR_TYPES
		// update the HashMap with attributes types
		for (int i = 0; i < new_record.spec_names.length; i++) {
			XMLElement resource_xml = specs_xml.getChild(new_record.spec_names[i]);
			HashMap <String, String> attr_datatype_hash = new HashMap <String, String>();
			// loop through each resource/spec attribute to create the content hash
			String [] children_array = resource_xml.listChildren();
			for (int j = 0; j < children_array.length; j++) {
				XMLElement attr_xml = resource_xml.getChild(children_array[j]);
				String datatype = attr_xml.getString("datatype");
				attr_datatype_hash.put(attr_xml.getName(), datatype);
			}
			new_record.spec_attr_types.put(new_record.spec_names[i], attr_datatype_hash);
		}		
		
		// NEW_RECORD.SPECS
		// update the HashMap with specification content
		for (int i = 0; i < new_record.spec_names.length; i++) {
			XMLElement resource_xml = specs_xml.getChild(new_record.spec_names[i]);
			HashMap <String, String> attr_content_hash = new HashMap <String, String>();
			// loop through each resource/spec attribute to create the content hash
			String [] children_array = resource_xml.listChildren();
			for (int j = 0; j < children_array.length; j++) {
				XMLElement attr_xml = resource_xml.getChild(children_array[j]);
				attr_content_hash.put(attr_xml.getName(), attr_xml.getContent());
			}
			new_record.specs.put(new_record.spec_names[i], attr_content_hash);
		}				

		// 
		if(debug_code) {
		 	processing_app.println("BModel_HandlerXML(): new_record.specs has " + new_record.specs.size() + " elements:");
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
			processing_app.println();
		}
	}
		



	void readXMLElement(XMLElement element, String prefix) {
		int sub_elements = element.getChildCount();
	  	for (int i = 0; i < sub_elements; i++) {
			XMLElement xmlChild = element.getChild(i);
		    String name = xmlChild.getName(); 		
			int children = xmlChild.getChildCount();
		  	processing_app.print(prefix + "-" + name);
			if (children > 0) {
			    processing_app.println(); 
				readXMLElement(xmlChild, prefix + "  ");
			}
			else {
				String content = xmlChild.getContent();
			    processing_app.println(": " + content);    			
			}
		}
	}


	// boolean create_resource_attr(String _resource, Float _value) {
	// 	try {
	// 		HashMap<String, Float> new_hash = new HashMap<String, Float>();
	// 		for (int j = 0; j < new_record.attr_names.get(_resource).length; j++) {
	// 			new_hash.put(new_record.attr_names.get(_resource)[j], _value);
	// 		}
	// 		new_record.resources.put(_resource, new_hash);
	// 		
	// 		if (debug_code) {
	// 			HashMap<String, Float> print_hash = new_record.resources.get(_resource);
	// 			processing_app.println("create_resource_attr(), new resource: " + _resource + ", number of attributes: " + print_hash.size() );
	// 			for (int j = 0; j < print_hash.size(); j++) {
	// 				processing_app.print("\t" + j + ". " + new_record.attr_names.get(_resource)[j] + ": ");
	// 				processing_app.println(print_hash.get(new_record.attr_names.get(_resource)[j]) + ", ");
	// 			}
	// 			processing_app.println();
	// 		}			
	// 	}
	// 	catch (Exception e) {
	// 		processing_app.println("create_resource_attr(), ERROR creating new resource: " + _resource);
	// 		return false;
	// 	}
	// 	return true;
	// }

	boolean create_resource_iterator(String _resource, Integer _value) {
		try {
			HashMap<Integer, Byte> new_hash = new HashMap<Integer, Byte>();
			Float columns = (Float) new_record.resources.get("dimensions").get("columns");				
			Float rows = (Float)  new_record.resources.get("dimensions").get("rows");
			Integer color_ctrs = new_record.resources.get("color").size();				
			for (int j = 0; j < columns * rows * color_ctrs; j++) {
				new_hash.put(j, _value.byteValue());
			}
			new_record.resources.put(_resource, new_hash);

			if (debug_code) {
				processing_app.println("create_resource_iterator(), new resource: " + _resource + 
									   " iterator size: " + new_record.resources.get(_resource).size() );
			}
		} 
		catch(Exception e) {
			processing_app.println("create_resource_iterator() ERROR");
			return false;
		}
		return true;
	}


	Byte[] get_iterator(String _resource) {
		String [] new_string = (String[]) new_record.attr_names.get(_resource);
		Byte [] new_bytes;
		if (!new_string[0].contains("raw")) {
			new_bytes = new Byte[0];
		}
		else {
			HashMap<Integer, Byte> int_hash = new_record.resources.get(_resource);
			new_bytes = new Byte[int_hash.size()];
			for (int i = 0; i < int_hash.size(); i++) {
				new_bytes[i] = int_hash.get(i);
			}
		}
		return new_bytes;
	}

}
