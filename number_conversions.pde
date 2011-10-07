byte[] int2bytes_127(int int_val) {
    byte[] byte_vals = {0,0,0};
    byte_vals[0] = byte(int_val >> 8);          // most significant byte
    byte_vals[1] = byte(int_val >> 1);
    byte_vals[2] = byte(int_val << 6);          // least significant byte
    
    // shift all byte values over by one, so that values will range between 0 - 127 only
    for (int i = 0; i < 3; i ++) {
        int temp_int = int(byte_vals[i]);
        byte_vals[i] = byte(temp_int >> 1);
    }

    return byte_vals;
}

int bytes2int_127(byte[] byte_vals) {
    // shift all byte values over by one in preparation to convert back to int
    for (int i = 0; i < 3; i ++) {
        byte_vals[i] = byte(int(byte_vals[i] << 1)); 
    }
    
    int new_int = ((int(byte_vals[2]) >> 6) +       // least significant byte
                   (int(byte_vals[1]) << 1) + 
                   (int(byte_vals[0]) << 8));      // most significant byte

    return new_int;      
}
