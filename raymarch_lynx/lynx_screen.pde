color[] col = new color[16];
int[] screen = new int[160*102];

void lupdate()
{
  int p = 0;
  for (int y = 0; y < 102; ++y) {
    for (int x = 0; x < 160; ++x) {
      plot(x, y, col[screen[p]]);
      ++p;
    }
  }
}

void lplot(int x, int y, int c)
{
  c = abs(c);
  if ( c > 31 ) c = 31;
  if ( c > 15 ){
    c = 31-c;
  }
  if ( c > 15 ) {
    c = 15;
  }
  if ( x >= 0 && x <= 159 && y >= 0 && y <= 101 ) {
    screen[x+y*160] = c;
  }
}
