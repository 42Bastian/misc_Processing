// -*-c-*-

int scale = 4;
PFont f;


int [] lynx_pal = new int[32];

void plot(int x, int y, int col)
{
  col &= 15;
  int r = (lynx_pal[col+16] & 15)<<4;
  int g = lynx_pal[col] << 4;
  int b = lynx_pal[col+16] & 0xf0;
  
  fill(r, g, b);
  stroke(r, g, b);
  rect(x*scale, y*scale, scale, scale);
}

void settings()
{
  size(160*scale, 102*scale);
  noSmooth();
}

int fp = 32;
int [] si_co = new int[256];
int [] scaler = new int[256];

void singen()
{
  int a=128;
  int  y = 0;
  int zp = 0;
  do{
    a -= 2;
    zp = (zp+a);
    int q = (zp>>7);
    si_co[y/2] = q;
    si_co[y/2+64] = -q;
    si_co[y/2+128] = q;  
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
  for (int i = 0; i < 128; ++i) {
    si_co[i] = int(sin(i*PI/64)*fp+fp);
  }
  **/
  /**
  for(int i = 0; i < 128; ++i){
    print(si_co[i]," ");
    if ( (i & 15) == 15 )println();
  }
  **/
  for(int i = 0; i < 32; ++i){
    lynx_pal[i] = si_co[i] & 0xfff;
  }
  int q = 0;
  for(int i = 0; i < 256; ++i){
    scaler[i] = q/256;
    q += 160;
  }
    
}

int x(int a)
{
  return scaler[a & 255];
}

int si(int a)
{
  return 32+si_co[x(a) & 127];
}
int co(int a)
{
  return 32+si_co[(x(a)+32) & 127];
}

int n = 24;
int frame = 0;

void draw()
{
  int i,j,i0;
  int u,v;
  
  fill(0, 0, 0);
  stroke(0, 0, 0);
  rect(0, 0, 160*scale, 102*scale);
  
   u = v = 0;
   
  for (i0 = 0,i = 0; i < n; ++i, i0 += fp) {
    for (j = 0; j < n; ++j) {
      int p0 = i0/4;
      int p1 = i0;
      p0 += v+frame;
      p1 += u;
      u = si(p0);
      v = co(p0);
      u += si(p1);
      v += co(p1);
      int x = 40+int(scaler[v & 255]*1.);
      int y = 4+int(scaler[u & 255]*1.);
      plot(x, y,  j+i);
    }
  }
  frame += 1;
  frame &= 255;
}
