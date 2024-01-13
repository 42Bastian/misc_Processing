// -*-c-*-

int scale = 4;
PFont f;


void plot(int x, int y, color c)
{
  fill(c);
  stroke(c);
  rect(x*scale, y*scale, scale, scale);
}

void settings()
{
  size(160*scale, 102*scale);
  noSmooth();
}

int [] si_co = new int[256];

void singen()
{
  int a = 129;
  int y = 0;
  int zp = 0;
  do {
    a -= 2;
    zp = zp+a;
    int q = zp>>3;
    si_co[y/2] = q;
    si_co[y/2+64] = -q;
    ++y;
  } while ( zp != 0 );
}

void setup()
{
  surface.setLocation(1520, 48);
  rectMode(CORNER);
  fill(0, 0, 0);
  stroke(0, 0, 0);
  rect(0, 0, 160*scale, 102*scale);
  frameRate(15);
  f = createFont("Monaco", 20);
  textFont(f);
  textAlign(LEFT, CENTER);
  translate(0, 0);
  fill(255, 0, 0);

  singen();
  /**
   for (int i = 0; i < 256; ++i) {
   print(si_co[i], " ");
   if ( (i & 15) == 15 )println();
   }
   **/
  for (int i = 0; i < 16; ++i) {
    col[i] = color(i<<4, i<<4, i<<4);
  }
  //col[0] = color(255,0,0);
}


int si(int a)
{
  return si_co[a & 127];
}
int co(int a)
{
  return si_co[(a+32) & 127];
}

int n = 20;
int frame = 0;

float l(float x, float y, float z)
{
  return sqrt(x*x+y*y+z*z);
}
float s(float x, float y, float z)
{
  //return y+cos(4./(x*x+z*z)+frame/6.)/2.4+1.5;
  return y+cos(sqrt(x*x+z*z)*1.8+frame/6.)/3.0+1.5;
  
}

int rot = 80;
float si_rot = sin(rot*PI/180);
float co_rot = cos(rot*PI/180);

void draw()
{
  int x, y;
  float z = -1;
  for (y = 0; y < 102; ++y) {
    for (x = 0; x < 160; ++x) {
      int c = 0;
      float xf=(x/160.-0.5);
      float yf=(y/102.-1.1)*102./160;
      float vl=l(xf, yf, z);
      float vx=xf/vl;
      float vy=yf/vl;
      float vz=z/vl;
      float p=0;
      float px = 0, py = 0, pz = 0, tx, ty, tz;
      int i;
      for (i = 0; i < 20; ++i) {
        px=p*vx;
        py=p*vy;
        pz=4+p*vz;
        ty = py;
        tz = pz;
        py = (si_rot*ty+co_rot*tz);
        pz = (-co_rot*ty+si_rot*tz);
        float d = s(px, py, pz);
        if ( d < 0.01 ) break;
        if ( p > 10 ) break;
        p += d;
      }
      if ( p > 10 ) {
        c = 0;
      } else {
        c = 1+abs(int(4*(px))^int(4*pz));
      }
      lplot(x, 102-y, c);
    }
  }
  lupdate();
  ++frame;
}
