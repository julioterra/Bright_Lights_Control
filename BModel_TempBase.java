import processing.core.PApplet;
import processing.core.PVector;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.ArrayList;

public class BModel_TempBase {
	
	public String name = "BModel_TempBase";

	public final String[] resources = {"color", "strobe", "scroll", "realtime"};

	public final String[][] resource_attributes = {  {"hue", "saturation", "brightness"},
								  		       	     {"speed"},
								  			         {"speed", "direction", "width"},
								  			         {"raw"}};
}
