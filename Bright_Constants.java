public interface Bright_Constants {
  
    // CONSTANTS: message syntax constants
    final static byte MSG_END =           (byte)(128);
    
    // CONSTANTS: receiving message header constants
    final static byte CONNECT_CONFIRM =   (byte)(255);              
    final static byte STATUS_MSG =         (byte)(254);              
    final static byte MODE_MSG_realtime =  (byte)(253);
    final static byte MODE_MSG_off =       (byte)(252);
    final static byte SET_MSG_hsb =        (byte)(129);
    final static byte MODE_MSG_color_hsb = (byte)(192);
    final static byte MODE_MSG_scroll =    (byte)(193);
    final static byte MODE_MSG_strobe =    (byte)(194);
    
    final static int SLIDER_RANGE = 1000;
}
