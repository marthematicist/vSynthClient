import processing.net.*; 

Client c; 
String input;
int data[]; 
int numChannels = 8;

boolean[] channelStatus;
color[] channelColor;
PVector[] channelPosition;
float[] channelSize;

float xRes;
float yRes;

void setup() { 
  size(800, 600);
  xRes = float(width);
  yRes = float(height);
  background(0);
  noStroke();
  rectMode( CENTER );
  
  // set the channelStatus and channelColor
  channelStatus = new boolean[numChannels];
  channelColor = new color[numChannels];
  channelPosition = new PVector[numChannels];
  channelSize = new float[numChannels];
  for( int i = 0 ; i < numChannels ; i++ ) {
    channelStatus[i] = false;
    channelColor[i] = hsvColor( 320*i/numChannels , 1 , 1 , 128 );
    channelPosition[i] = new PVector( random( 0.1*width , 0.9*width ) , random( 0.1*height , 0.9*height ) );
    channelSize[i] = random( 0.8*height , 1.7*height );
  }
  
  // Connect to the server’s IP address and port­
  c = new Client(this, "127.0.0.1", 12345); // Replace with your server’s IP and port
} 

void draw() { 
  noStroke();
  fill( 0 , 0 , 0 , 20 );
  rect( 0.5*width , 0.5*height , width , height );
  //background( 0 );

 // Receive data from server
  int numBytes = c.available();
  if ( numBytes > 0 ) {
    byte[] byteBuffer = new byte[16];
    c.readBytes( byteBuffer );
    for( int i = 0 ; i < numBytes ; i++ ) {
      int d = int( byteBuffer[i] ) ;
      int ch = d % 16;
      int cmd = ( d - ch ) / 16;
      boolean on = false;
      if( cmd == 1 ) { 
        on = false; 
        channelStatus[ch] = false;
      }
      if( cmd == 2 ) { 
        on = true; 
        channelStatus[ch] = true;
      }
      Event e = new Event( "onOff" , on , 0 , ch );
      println( "cmd: " + cmd + "    ch: " + ch + "      " + e.print() );
    }
  }
  
  for( int i = 0 ; i < numChannels ; i++ ) {
    if( channelStatus[i] ) {
      fill( red(channelColor[i]) , green(channelColor[i]), blue(channelColor[i]) , 10 );
      PVector offset = PVector.random2D();
      offset.mult(1);
      noStroke();
      rect( channelPosition[i].x + offset.x , channelPosition[i].y + offset.y , channelSize[i] , channelSize[i] );
      noFill();
      stroke( channelColor[i] );
      strokeWeight( 30);
      float a = float(i) / float(numChannels);
      float d = 0.1*yRes*(1-a) + 1.2*yRes*(a);
      ellipse( 0.5*width + offset.x , 0.5*height + offset.y , d , d );
    }
  }
  
  
}