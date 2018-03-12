int SAMPLES = 4096; //must be the amount of lines in the file, just use sublime or notepad++.

boolean makePic = true;

String[] info = new String[SAMPLES];
float[] data = new float[SAMPLES];

String[] Increment = new String[1];
int inc;

int w = 5;
int h = 3;

float highest = 0.0;
  int hx = 0;
  int hy = 0;
  int c = 0;
float lowest = 10000000.0;
  int lx = 0;
  int ly = 0;
  
float scroll = 0.0;

void setup()
{
  frameRate(10);
  size(1200,1024);
  background(#FFFFFF);
  textSize(9);
  info = loadStrings("outputPy.txt");
  
  Increment = loadStrings("Inc.txt");
  inc = int(Increment[0]);
  
  
  for(int i = 0; i < SAMPLES-1; i++)
  { 
    data[i] = float(info[i]);    
  }
}


void draw()
{
  background(#FFFFFF);
  
  colorMode(HSB);
  noStroke();
  
  for(int j = 0; j < SAMPLES/256; j++) //nested for loops go through all values in the inputted file, ending at 256 and then going to the next line
  {                                    //due to the galileo having 256 sets. This is basically a a two dimensional array without such an implementation.
    if(j >= -scroll && j <= -scroll+1000)   
    {
      for(int i = 0; i < 256; i++)
      {                
        if(c == 0 && data[(j*256)+i] > highest && data[(j*256)+i] <= 65534) //calculating highest amount.
        {
          highest = data[(j*256)+i];
          hx = j;
          hy = i;
        }
        
        if(c == 0 && data[(j*256)+i] < lowest) //lowest 
        {
          lowest = data[(j*256)+i];
          lx = j;
          ly = i;
        }
        
    /*    if(data[(j*256)+i] > 0) //just some mucking around with some values
        {
          fill(0,190,(1-((data[(j*256)+i]/highest)))*255);
        }
        else if(data[(j*256)+i] <= 0)
        {
          fill(180,190,(1-((data[(j*256)+i]/highest)))*255);
        } */
        
        fill(0,190,(1-((data[(j*256)+i]/highest)))*255); //drawing the rectangles
        
        rect(100+(j*w)+scroll,868-(i*h)-h,w,h);      
      }
    }
    
  }
  
  colorMode(RGB);
  stroke(0); 
  
  fill(0);
  line(100,100,100,868);
  line(100,868,100+(SAMPLES),868);
  
  for(int i = 0; i <= 256; i+=8)
  {
    fill(0);
    textAlign(CENTER, CENTER);
    text(i, 80, 868-(i*h));
    line(100, 868-(i*h), 95, 868-(i*h));
  }
  
  for(int i = 0; i <= SAMPLES; i+=25)
  {
    if(i >= -scroll && i <= -scroll+1000)
    {
      fill(0);
      text(i, 100+i*w+scroll, 878);
      line(100+i*w+scroll, 868, 100+i*w+scroll, 873); 
    }         
  }
  
  text("X: "+mouseX, 30,20); //this section should show the access times specifically where the mouse is
  text("Y: "+mouseY, 70,20); //however is meaningless once the python script has analysed the results.
  text("Set: "+(868-(mouseY/3)-579), 120,20);
  text("Sample: "+(mouseX-100+-scroll), 185,20);
  text("Scroll: "+-scroll, 185,40);
  
  int set = (868-(mouseY/3)-579);
  int sample = (mouseX-100);
  
  if(set >= 0 && set <= 256 && sample >= 0 && sample < SAMPLES/256)
  {
    text("Value: "+(int)data[((868-(mouseY/3)-579)+((mouseX-100+-(int)scroll)*256))], 270,20);
    text("Index: "+((868-(mouseY/3)-579)+((mouseX-100+-(int)scroll)*256)), 330,20);
    
    colorMode(HSB);
    fill(0,190,(1-(data[((868-(mouseY/3)-579)+((mouseX-100+-(int)scroll)*256))]/highest))*256);    
    rect(50,50,330,25);
  }
  
  
  if(c == 0)
  {
    print("Highest Value (Less than 10000): "+highest+" | Sample: "+hx+" Set: "+hy);
    print("\nLowest Value: "+lowest+" | Sample: "+lx+" Set: "+ly);
    if(makePic == true)
    {
      save("heatmap-"+inc+".jpg");
      inc++;
    }
    
    c++;
    
    Increment[0] = str(inc);
    saveStrings("Inc.txt", Increment);   
  } 
}

void mouseWheel(MouseEvent event) 
{ 
    scroll = scroll + event.getCount()*100;
    if(scroll > 0)
    {
     scroll = 0; 
    }
}

void keyReleased()
{
  if(key == 'b')
  {
    scroll = 0; 
  }
  else if(key == 'e')
  {
    scroll = -(SAMPLES); 
  }  
}