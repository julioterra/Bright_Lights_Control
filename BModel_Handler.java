// import processing.core.PApplet;
// import processing.core.PVector;
// import java.util.HashMap;
// import java.util.Iterator;
// import java.util.Map;
// import java.util.ArrayList;
// 
// public class BModel_Handler extends Bright_Element implements Bright_Constants {
// 
// 	// takes a reosource name along with a hashmap that contains that resources attributes
// 	BModel_ActiveRec new_record;
// 	BModel_TempControl data_model;
// 
// 	public BModel_Handler () {		
// 
// 		data_model = new BModel_TempControl();
// 		new_record = new BModel_ActiveRec();
// 
// 		processing_app.print("BModel_Handler ******** NEW Active Record ");
// 		processing_app.println("Record Template: " + data_model.name);
// 
// 		// load the resource attribute hashmap
// 		for (int i = 0; i < data_model.resources.length; i++) {
// 			new_record.resource_names = processing_app.append(new_record.resource_names, data_model.resources[i]);
// 			new_record.resources_active.put(new_record.resource_names[i], data_model.resources_active[i]);
// 
// 			if (new_record.resources_active.get(new_record.resource_names[i])) {
// 				new_record.attr_names.put(new_record.resource_names[i], data_model.resource_attributes[i]);
// 				// new_record.attr_types.put(new_record.resource_names[i], data_model.resource_attributes_types[i]);
// 				new_record.attr_ranges.put(new_record.resource_names[i], data_model.resource_attributes_ranges[i]);
// 			}
// 		}
// 
// 		// load the resources hashmap
// 		for (int i = 0; i < data_model.resources.length; i++) {
// 			if (new_record.resources_active.get(new_record.resource_names[i])) {
// 				if(!data_model.resource_attributes[i][0].contains("raw")) {
// 					create_resource_attr(data_model.resources[i], 0f);
// 				} 
// 
// 				else if(data_model.resource_attributes[i][0].contains("raw")) {
// 					create_resource_iterator(data_model.resources[i], 0);
// 				} 
// 			}
// 		}			
// 	}
// 
// 
// 
// 	boolean create_resource_attr(String _resource, Float _value) {
// 		try {
// 			HashMap<String, Float> new_hash = new HashMap<String, Float>();
// 			for (int j = 0; j < new_record.attr_names.get(_resource).length; j++) {
// 				new_hash.put(new_record.attr_names.get(_resource)[j], _value);
// 			}
// 			new_record.resources.put(_resource, new_hash);
// 			
// 			if (debug_code) {
// 				HashMap<String, Float> print_hash = new_record.resources.get(_resource);
// 				processing_app.println("create_resource_attr(), new resource: " + _resource + ", number of attributes: " + print_hash.size() );
// 				for (int j = 0; j < print_hash.size(); j++) {
// 					processing_app.print("\t" + j + ". " + new_record.attr_names.get(_resource)[j] + ": ");
// 					processing_app.println(print_hash.get(new_record.attr_names.get(_resource)[j]) + ", ");
// 				}
// 				processing_app.println();
// 			}			
// 		}
// 		catch (Exception e) {
// 			processing_app.println("create_resource_attr(), ERROR creating new resource: " + _resource);
// 			return false;
// 		}
// 		return true;
// 	}
// 
// 	boolean create_resource_iterator(String _resource, Integer _value) {
// 		try {
// 			HashMap<Integer, Byte> new_hash = new HashMap<Integer, Byte>();
// 			Float columns = (Float) new_record.resources.get("dimensions").get("columns");				
// 			Float rows = (Float)  new_record.resources.get("dimensions").get("rows");
// 			Integer color_ctrs = new_record.resources.get("color").size();				
// 			for (int j = 0; j < columns * rows * color_ctrs; j++) {
// 				new_hash.put(j, _value.byteValue());
// 			}
// 			new_record.resources.put(_resource, new_hash);
// 
// 			if (debug_code) {
// 				processing_app.println("create_resource_iterator(), new resource: " + _resource + 
// 									   " iterator size: " + new_record.resources.get(_resource).size() );
// 			}
// 		} 
// 		catch(Exception e) {
// 			processing_app.println("create_resource_iterator() ERROR");
// 			return false;
// 		}
// 		return true;
// 	}
// 
// 
// 	Byte[] get_iterator(String _resource) {
// 		String [] new_string = (String[]) new_record.attr_names.get(_resource);
// 		Byte [] new_bytes;
// 		if (!new_string[0].contains("raw")) {
// 			new_bytes = new Byte[0];
// 		}
// 		else {
// 			HashMap<Integer, Byte> int_hash = new_record.resources.get(_resource);
// 			new_bytes = new Byte[int_hash.size()];
// 			for (int i = 0; i < int_hash.size(); i++) {
// 				new_bytes[i] = int_hash.get(i);
// 			}
// 		}
// 		return new_bytes;
// 	}
// 
// }
