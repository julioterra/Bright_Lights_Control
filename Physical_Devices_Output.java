import processing.core.PApplet;
import java.util.HashMap;
import java.util.ArrayList;
import processing.serial.*;


public class Physical_Devices_Output extends Bright_Element implements Bright_Constants {

    Serial myPort;
    boolean connection_established = false;
    boolean reading_msg_flag = false;
    byte msg_type = 0;
    ArrayList<Byte> msg_body;
    boolean serial_connected = false;

    Physical_Devices_Output() {
        msg_body = new ArrayList<Byte>();
    }
  
    public boolean connect_serial(String serial_device_name) {
        String serial_list [] = Serial.list();
        processing_app.println("\n** SERIAL CONNECTION **");
        processing_app.println(serial_list);

        processing_app.println("\n** connection status **");
    
        int serial_num = -1;
        for(int i = (serial_list.length - 1); i >= 0; i--){     
            if (serial_list[i].contains(serial_device_name)) {
                try{
                    serial_num = i;
                    processing_app.println("Found port... Trying to connect...");
                    myPort = new Serial(processing_app, serial_list[serial_num], 57600);
                    processing_app.delay(3000);
                    myPort.buffer(1);
                    myPort.write('\n');
                    processing_app.delay(2000);
                    serial_connected = true;  
                } catch(Exception e) {
                    serial_connected = false;  
                }
            }
        }    
    
        if (serial_connected) processing_app.println("SUCCESS: connected to port: " + serial_list[serial_num]);
        else processing_app.println ("ERROR: connection not established");
        
        return serial_connected;
    }
    
    public int connect_serial_obj(String serial_device_name) {
       String serial_list [] = Serial.list();
        processing_app.println(serial_list);
    
        int serial_num = -1;
        for(int i = (serial_list.length - 1); i >= 0; i--){     
            if (serial_list[i].contains(serial_device_name)) {
                try{
                    serial_num = i;
                    myPort = new Serial(processing_app, serial_list[serial_num], 57600);
                    processing_app.delay(2000);
                    myPort.buffer(1);
                    myPort.write('\n');
                    processing_app.delay(2000);
                    serial_connected = true;  
                } catch(Exception e) {
                    serial_connected = false;  
                }
            }
        }    
    
        processing_app.println("\n** connection status **");
        if (serial_connected) processing_app.println("found serial: " + serial_list[serial_num]);
        else processing_app.println ("ERROR: serial NOT found");
        
        return serial_num;
    }

    public boolean connected() {
      return connection_established; 
    }
    
    public void serialEvent(Serial myPort) {
        connection_established = true;
        while (myPort.available() > 0) {
             byte new_byte = (byte)(myPort.read());
              
             if (new_byte == CONNECT_CONFIRM) {
                 myPort.write(STATUS_MSG);
                 msg_body = new ArrayList<Byte>();
                 processing_app.println("\nstatus requested");
             } 
    
             if (connection_established) {
                 processing_app.print((int)(new_byte) + ", ");
                 read_serial_bytes(new_byte);
             }
        }
    }
    
    public void read_serial_bytes(byte _new_byte) {
        // MESSAGE START: if this byte is equal to or greater then 129 then we know that this is the start of a new message
        if ((int)(_new_byte) > 128 && (int)(_new_byte) < 255) {
            msg_type = _new_byte;
            reading_msg_flag = true;
            msg_body = new ArrayList<Byte>();
        } 
        
        // READ MESSAGE: if reading_msg_flag is set to true then read message
        if (reading_msg_flag) {
        
            // MESSAGE END: if this byte is equal to 128 then we know that this is end of a message
            if (_new_byte == MSG_END) {
                controller.parse_serial_msg(msg_type, msg_body);
                reading_msg_flag = false;
            }
    
            // MESSAGE BODY: f a reading_msg_flag is set to true, and the byte count is smaller than longest possible message, 
            // and the value of the byte is lower than 128 (all message bytes have a value that is less than 127).
            else if ((int)(_new_byte) < 128) {
                msg_body.add(_new_byte);  
            }
    
        }
    }

    public void send_serial_byte(byte new_msg) {
        if (serial_connected) {
            myPort.write(msg_type);
        }
    }    
    
    public void stop() {
      if (serial_connected) {
          myPort.stop();  
          processing_app.println("closed serial.");
      }
    }
    
    // Methods that should be part of the serial_output/physical_output/abstract_output class    
    public void send_serial_msg(byte msg_type, byte[] msg_body) {
        if (serial_connected) {
            processing_app.print("sending serial: " + (int)msg_type + " [");
            myPort.write(msg_type);
            for(int i = 0; i < msg_body.length; i++) {
                myPort.write(msg_body[i]);
                processing_app.print((int)msg_body[i] + ", ");
            }
            myPort.write(MSG_END);
            processing_app.println("] " + (int)MSG_END);
        }
         else {
            processing_app.println("trying to send message but having serial issues"); 
         }
    }
    
    public void send_serial_msg_arraylist(byte msg_type, ArrayList<Byte> msg_body) {
        if (serial_connected) {
            processing_app.print("sending serial: " + (int)msg_type + ", ");
            myPort.write(msg_type);
            for(int i = 0; i < msg_body.size(); i++) {
                byte current_byte = msg_body.get(i);
                if (current_byte > 127) processing_app.println("** realtime msg issue, byte value: " + (int)(current_byte));
                myPort.write(current_byte);
            }
            myPort.write(MSG_END);
        }
         else {
            processing_app.println("trying to send message but having serial issues"); 
         }
    }
}
