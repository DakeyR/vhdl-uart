import serial;

ser = serial.Serial('/dev/ttyUSB0', 9600)

while True:
    choice = ord(input()) % 2
    ser.write(bytes([choice]))
    d = ser.read()
    print(str(ord(d)) + ' cm')
