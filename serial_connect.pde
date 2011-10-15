int connect_serial(String serial_device_name) {
    boolean serial_found = false;
    String serial_list [] = Serial.list();
    println(serial_list);

    int serial_num = -1;
    for(int i = (serial_list.length - 1); i >= 0; i--){     
        if (serial_list[i].contains(serial_device_name)) {
          serial_found = true;
          serial_num = i;
          myPort = new Serial(this, serial_list[serial_num], 57600);
          myPort.buffer(1);
        }
    }    

    println("\n** connection status **");
    if (serial_found) println("found serial: " + serial_list[serial_num]);
    else println ("ERROR: serial NOT found");
    
    return serial_num;
}

