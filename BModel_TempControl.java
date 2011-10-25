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

	public BModel_TempControl() {
		name = "BModel_TempSample";
	}

}
