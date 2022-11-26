import processing.opengl.*;
import processing.serial.*;

PShape duck;
Serial SerialPort;

float []rxdata = new float [6];
float yaw_data = 0;

import com.jogamp.opengl.GLProfile;
{
  GLProfile.initSingleton();
}

void setup() {
  lights();
  size(500, 500, P3D);
  
  //myPort = new Serial(this, "COM6", 115200); // Windows用
  SerialPort = new Serial(this, "/dev/tty.usbmodem1301", 115200);
  
  duck = loadShape("rubber_duck.obj");
  duck.scale(7.0);
}

void draw() {
  background(#003366);

  translate(width / 2, 400, 0);
  camera(0,80,90, 0,70,70, 0,0,1);
  
  yaw_data += ((-rxdata[2] * PI) / 180) + 0.0005;  // yawは累積
  println(nf(rxdata[0],3,3),nf(-rxdata[1],3,3),nf(-yaw_data,3,3));
  
  rotateX(radians(rxdata[0]));
  rotateZ(radians(-rxdata[1]));
  rotateY(radians(-yaw_data));
  
  shape(duck);
}

void serialEvent(Serial p) {
  String rxString = SerialPort.readStringUntil('\r');
  if (rxString != null) {
    rxString = trim(rxString);
    rxdata = float(split(rxString, ','));
  }
}
