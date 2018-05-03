import serial;

ser = serial.Serial('/dev/ttyUSB0', 9600)

while True:
    d = ser.read()
    print(chr(ord(d) + 48))
