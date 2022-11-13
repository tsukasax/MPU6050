// シリアルライブラリを取り入れる
import processing.serial.*;

float a, b, c, d, e, f;
PFont myFont, myFont_2, myFont_3, myFont_4, myFont_5, myFont_6;
float valax, valay, valaz, valgx, valgy, valgz;
boolean mouse = true;

//フレームレート、最大目盛の設定
int FRATE = 60;
float maxRange = 4;
float maxRange2 = 500;

// Serial通信、グラフ描画用のインスタンス作成
Serial myPort;
graphMonitor accGraph;
graphMonitor2 gyrGraph;

void setup() {
  size(1360, 800);
  frameRate(FRATE);
  smooth();
  myPort = new Serial(this, "/dev/tty.usbmodem11301", 115200);
  
  myFont_6 = createFont("Meiryo", 50);
  myFont = loadFont("Serif-40.vlw");
  myFont_2 = loadFont("Athelas-BoldItalic-18.vlw");
  myFont_3 = loadFont("Arial-BoldMT-24.vlw");
  myFont_4 = loadFont("Arial-BoldMT-18.vlw");
  myFont_5 = loadFont("Arial-BoldMT-14.vlw");
  
  accGraph = new graphMonitor(100, 50, 1000, 300);
  gyrGraph = new graphMonitor2(100, 400, 1000, 300);
}


void draw() {
  background(#015F0D);

  a = valax;
  b = valay;
  c = valaz;
  d = valgx;
  e = valgy;
  f = valgz;
  accGraph.graphDraw(a, b, c);
  gyrGraph.graphDraw2(d, e, f);
}

class graphMonitor2 {
  int X2_POSITION, Y2_POSITION;
  int X2_LENGTH, Y2_LENGTH;
  float [] y11, y21, y31;
  
  graphMonitor2(int _X2_POSITION, int _Y2_POSITION, int _X2_LENGTH, int _Y2_LENGTH) {
    X2_POSITION = _X2_POSITION;
    Y2_POSITION = _Y2_POSITION;
    X2_LENGTH   = _X2_LENGTH;
    Y2_LENGTH   = _Y2_LENGTH;
    y11 = new float[X2_LENGTH];
    y21 = new float[X2_LENGTH];
    y31 = new float[X2_LENGTH];
    for (int i = 0; i < X2_LENGTH; i++) {
      y11[i] = 0;
      y21[i] = 0;
      y31[i] = 0;
    }
  }
  
  void graphDraw2(float _y11, float _y21, float _y31) {
    y11[X2_LENGTH - 1] = _y11;
    y21[X2_LENGTH - 1] = _y21;
    y31[X2_LENGTH - 1] = _y31;
    for (int i = 0; i < X2_LENGTH - 1; i++) {
      y11[i] = y11[i + 1];
      y21[i] = y21[i + 1];
      y31[i] = y31[i + 1];
    }
    pushMatrix();

    translate(X2_POSITION, Y2_POSITION);
    fill(0);
    stroke(130);
    strokeWeight(1);
    rect(0, 0, X2_LENGTH, Y2_LENGTH);
    line(0, Y2_LENGTH / 2, X2_LENGTH, Y2_LENGTH / 2);
    line(0, Y2_LENGTH / 4, X2_LENGTH, Y2_LENGTH / 4);
    line(0, Y2_LENGTH / 4 * 3, X2_LENGTH, Y2_LENGTH / 4 * 3);
    line(X2_LENGTH / 2, 0, X2_LENGTH / 2 , Y2_LENGTH);
    line(X2_LENGTH / 4, 0, X2_LENGTH / 4 , Y2_LENGTH);
    line(X2_LENGTH / 4 * 3, 0, X2_LENGTH / 4 * 3, Y2_LENGTH);
      
    //タイトル表示
    textFont(myFont_6);
    textSize(30);
    fill(#FFFFCC);
    textAlign(LEFT, BOTTOM);
    text("角速度波形", 20, -5);
    
    //チーム名表示
    textFont(myFont_2);
    textSize(18);
    fill(255);
    text("YumeLabo Team.", 1120, 400);
      
    //Y軸名表示
    textFont(myFont_3);
    textSize(18);
    fill(#CCCCCC);
    textAlign(RIGHT);
    text(0, -5, Y2_LENGTH / 2);
    text(nf((maxRange2 / 2), 0, 0), -5, 18);
    text(nf(-(maxRange2 / 2), 0, 0), -5, Y2_LENGTH);
    text(nf((maxRange2 / 4), 0, 0), -5, Y2_LENGTH / 4);
    text(nf(-(maxRange2 / 4), 0, 0), -5, Y2_LENGTH / 4 * 3);

    //X軸名表示
    textFont(myFont_3);
    textSize(18);
    textAlign(RIGHT);
    text(FRATE + "FPS", X2_LENGTH,  340);
    text(0 + "S", X2_LENGTH,  320);

    translate(0, Y2_LENGTH / 2);
    scale(1, -1);
    strokeWeight(1);
      
    for (int i = 0; i < X2_LENGTH - 1; i++) {
      fill(255);
      stroke(255, 255, 0);
      //line(i, y1[i] * (Y_LENGTH / 2) / maxRange, i + 1, y1[i + 1] * (Y_LENGTH / 2) / maxRange);
      line(i, y11[i] * (Y2_LENGTH) / maxRange2, i + 1, y11[i + 1] * (Y2_LENGTH) / maxRange2);
        
      stroke(255, 0, 255);
      //line(i, y2[i] * (Y_LENGTH / 2) / maxRange, i + 1, y2[i + 1] * (Y_LENGTH / 2) / maxRange);
      line(i, y21[i] * (Y2_LENGTH) / maxRange2, i + 1, y21[i + 1] * (Y2_LENGTH) / maxRange2);
        
      stroke(255, 255, 255);
      //line(i, y3[i] * (Y_LENGTH / 2) / maxRange, i + 1, y3[i + 1] * (Y_LENGTH / 2) / maxRange);
      line(i, y31[i] * Y2_LENGTH / maxRange2, i + 1, y31[i + 1] * Y2_LENGTH / maxRange2);
        
      }
      //値の表示
      scale(1, -1);
      textFont(myFont_4);
      textSize(18);        
      translate(0, Y2_LENGTH);
      fill(0);
      stroke(0);
      rect(350, -480, 100, 25);
      rect(550, -480, 100, 25);
      rect(750, -480, 100, 25);
        
      //補足線
      stroke(255, 255, 0);
      line(260,-460,330,-460);
      stroke(255, 0, 255);
      line(460,-460,530,-460);
      stroke(255, 255, 255);
      line(660,-460,730,-460);
        
      fill(255);
      text(nf(d, 0, 0), 420, -460);
      text(nf(e, 0, 0), 620, -460);
      text(nf(f, 0, 0), 820, -460);
      textFont(myFont_6);
      textSize(14);
      text("X軸角速度",330,-470);
      text("Y軸角速度",530,-470);
      text("Z軸角速度",730,-470);        
      scale(1, -1);
        
      popMatrix();
  }

}
class graphMonitor {
    String TITLE;
    int X_POSITION, Y_POSITION;
    int X_LENGTH, Y_LENGTH;
    float [] y1, y2, y3;
    
    graphMonitor(int _X_POSITION, int _Y_POSITION, int _X_LENGTH, int _Y_LENGTH) {
      X_POSITION = _X_POSITION;
      Y_POSITION = _Y_POSITION;
      X_LENGTH   = _X_LENGTH;
      Y_LENGTH   = _Y_LENGTH;
      y1 = new float[X_LENGTH];
      y2 = new float[X_LENGTH];
      y3 = new float[X_LENGTH];
      for (int i = 0; i < X_LENGTH; i++) {
        y1[i] = 0;
        y2[i] = 0;
        y3[i] = 0;
      }
    }

    void graphDraw(float _y1, float _y2, float _y3) {
      y1[X_LENGTH - 1] = _y1;
      y2[X_LENGTH - 1] = _y2;
      y3[X_LENGTH - 1] = _y3;
      for (int i = 0; i < X_LENGTH - 1; i++) {
        y1[i] = y1[i + 1];
        y2[i] = y2[i + 1];
        y3[i] = y3[i + 1];
      }
      pushMatrix();

      translate(X_POSITION, Y_POSITION);
      fill(0);
      stroke(130);
      strokeWeight(1);
      rect(0, 0, X_LENGTH, Y_LENGTH);
      line(0, Y_LENGTH / 2, X_LENGTH, Y_LENGTH / 2);
      line(0, Y_LENGTH / 4, X_LENGTH, Y_LENGTH / 4);
      line(0, Y_LENGTH / 4 * 3, X_LENGTH, Y_LENGTH / 4 * 3);
      line(X_LENGTH / 2, 0, X_LENGTH / 2 , Y_LENGTH);
      line(X_LENGTH / 4, 0, X_LENGTH / 4 , Y_LENGTH);
      line(X_LENGTH / 4 * 3, 0, X_LENGTH / 4 * 3, Y_LENGTH);
      
      //タイトル表示
      textFont(myFont_6);
      textSize(30);
      fill(#FFFFCC);
      textAlign(LEFT, BOTTOM);
      //text("ラズパイPico & MPU6050 加速度センサーの実験波形", 20, -5);
      text("加速度波形", 20, -5);
      
      //Y軸名表示
      textFont(myFont_3);
      textSize(18);
      fill(#CCCCCC);
      textAlign(RIGHT);
      text(0, -5, Y_LENGTH / 2);
      text(nf((maxRange / 2), 0, 0), -5, 18);
      text(nf(-(maxRange / 2), 0, 0), -5, Y_LENGTH);
      text(nf((maxRange / 4), 0, 0), -5, Y_LENGTH / 4);
      text(nf(-(maxRange / 4), 0, 0), -5, Y_LENGTH / 4 * 3);

      //X軸名表示
      textFont(myFont_3);
      textSize(18);
      textAlign(RIGHT);
      text(FRATE + "FPS", X_LENGTH, 340);
      text(0 + "S", X_LENGTH, 320);

      translate(0, Y_LENGTH / 2);
      scale(1, -1);
      strokeWeight(1);
      
      for (int i = 0; i < X_LENGTH - 1; i++) {
        fill(255);
        stroke(255, 255, 0);
        //line(i, y1[i] * (Y_LENGTH / 2) / maxRange, i + 1, y1[i + 1] * (Y_LENGTH / 2) / maxRange);
        line(i, y1[i] * (Y_LENGTH) / maxRange, i + 1, y1[i + 1] * (Y_LENGTH) / maxRange);
        
        stroke(255, 0, 255);
        //line(i, y2[i] * (Y_LENGTH / 2) / maxRange, i + 1, y2[i + 1] * (Y_LENGTH / 2) / maxRange);
        line(i, y2[i] * (Y_LENGTH) / maxRange, i + 1, y2[i + 1] * (Y_LENGTH) / maxRange);
        
        stroke(255, 255, 255);
        //line(i, y3[i] * (Y_LENGTH / 2) / maxRange, i + 1, y3[i + 1] * (Y_LENGTH / 2) / maxRange);
        line(i, y3[i] * Y_LENGTH / maxRange, i + 1, y3[i + 1] * Y_LENGTH / maxRange);
        
      }
        //値の表示
        scale(1, -1);
        textFont(myFont_4);
        textSize(18);        
        translate(0, Y_LENGTH);
        fill(0);
        stroke(0);
        rect(350, -480, 100, 25);
        rect(550, -480, 100, 25);
        rect(750, -480, 100, 25);
        
        //補足線
        stroke(255, 255, 0);
        line(260,-460,330,-460);
        stroke(255, 0, 255);
        line(460,-460,530,-460);
        stroke(255, 255, 255);
        line(660,-460,730,-460);
        
        fill(255);
        text(nf(a, 0, 0), 420, -460);
        text(nf(b, 0, 0), 620, -460);
        text(nf(c, 0, 0), 820, -460);
        textFont(myFont_6);
        textSize(14);
        text("X軸加速度",330,-470);
        text("Y軸加速度",530,-470);
        text("Z軸加速度",730,-470);        
        scale(1, -1);
        
      popMatrix();
    }
}

void serialEvent(Serial myPort) {
  String RxData = myPort.readStringUntil('\r');
  
  // RxDataが空か確認
  if(RxData != null){
    // 改行文字を削除
    RxData = trim(RxData);
    
    // カンマ区切りで配列に代入
    float val[] = float(split(RxData,','));
    
    // 配列が6個の場合のみ最終変数(valx,valy,valz,valgx,valgy,valgz)に代入
    if(val.length == 6){
      valax = val[0];
      valay = val[1];
      valaz = val[2];
      valgx = val[3];
      valgy = val[4];
      valgz = val[5];
    }
    println(valax, valay, valaz, valgx, valgy, valgz);
  }
}

void mousePressed(){  //マウスボタンを押すと実行
  if(mouse) {
    noLoop();
    mouse = false;
  }else {
    loop();
    mouse = true;
  }
}
