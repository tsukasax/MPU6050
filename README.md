# Processing MPU6050センサー用

## 加速度、角速度のグラフ表示テスト用
マイコンからシリアル信号を受信し、折れ線グラフを表示。

## 通信仕様
・ I2Cの通信速度：400kHz<br>
・ I2Cマイコン側ピン：SCL（13ピン）、SDA（12ピン）<br>
・ シリアル通信速度：115.2k<br>
・ 以下のパソコン側のポート指定は使用機種によるので使用環境で変更<br>
myPort = new Serial(this, "/dev/tty.usbmodem11301", 115200);

## マイコンからのシリアル信号仕様
・　直は文字列として受信<br>
・　末尾に改行コード付加（"\r"）<br>
・ 文字間は「,」（カンマ）区切り<br>
・　データは、ax, ay, az, gx, gy, gzの6個<br>

