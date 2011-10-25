import processing.core.PApplet;
import processing.core.PVector;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.ArrayList;

public class BModel_TempControl extends BModel_TempBase {

	public String[] specs = {"media", "layout"};

	public String[][] specs_attributes = {  {"type", "port"},
								  			{"width", "height"}};


	//////////////////////////////////////////
	// SLATED FOR DELETION IN THE NEAR FUTURE
	public Boolean[] resources_active = {true, true, true, true, true};
	
	public String[][] resource_attributes_types = { {"float", "float"},
												    {"float", "float", "float"},
								  				    {"float"},
								  			  	    {"float", "float", "float"},
								  				    {"iterator"}};
	
	public PVector[][] resource_attributes_ranges = { {new PVector(0f,1f), new PVector(0f,1f)},
												      {new PVector(0f,1f), new PVector(0f,1f), new PVector(0f,1f)},
								  				      {new PVector(0f,1f)},
								  			  	      {new PVector(0f,1f), new PVector(0f,1f), new PVector(0f,1f)},
								  				      {new PVector(0,127)}};

	// SLATED FOR DELETION IN THE NEAR FUTURE
	//////////////////////////////////////////

	public BModel_TempControl() {
		name = "BModel_TempSample";
	}

}
