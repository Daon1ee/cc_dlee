
//variable
color topCol; //yellowish color
color midCol; //background color
color bottomCol; //bluish color


color[] palette = {
  #345580, // deep blue
  #D8CBBB, // beige
  #D57A72, // salmon
  #EFB934, // yellow
  #BB302E, // red
  #338197  // teal
};


long shapeSeed;
long colorSeed; // if using either randomseed(long) -> mix up color & shape  


//setup
void setup() {
  size(1200, 800);
  background(225,217,206);
  noStroke();

  //blendMode(MULTIPLY);
  smooth(); // anti-alliasing
  noLoop();
  
  topCol = color(223, 212, 143, 100);
  midCol = color(225, 217, 206, 0);
  bottomCol = color(140, 187, 195, 100);


  generatePalette();
  shapeSeed = (long)random(1<<30);
 }

 
 
 //draw ===========================================================================
void draw() {
  randomSeed(shapeSeed);  //always on the top!!!!!
  background(225, 217, 206);
  
  
  
  //background color gradient height
  int gradTop = 200;
  int gradBottom = 200;
  int flatMid = height - gradTop - gradBottom; //making middle color(background c)
  
  // gradient 1) Top to Mid
   for (int y = 0; y< gradTop; y++) {
    float inter = map (y, 0, gradTop, 0, 1);
    color c = lerpColor(topCol, midCol, inter);
    stroke(c);
    line(0, y, width, y);
  }
  
  // gradient 2) mid color
  for (int y = gradTop; y < gradTop + flatMid; y++) {
    stroke(midCol);
    line(0, y, width, y);
  }
     
   // gradient 3) mid to bottom
   for (int y = 0; y < gradBottom; y++) {
    float inter = map (y, 0, gradBottom, 0, 1);
    color c = lerpColor(midCol, bottomCol, inter);
    stroke(c);
    int yy = gradTop + flatMid + y;
    line(0, yy, width, yy);
   }
   
   
   //center isoceles triangle
   drawCenterTriangle();
   
   //Triangles
   for (int i=0; i<5; i++) {
     drawBackTriangle();
   }
   
   // circles with halo
   int count = (int)random(2, 5);
    drawRandomCircles(count);
    
    
    // crossing lines
    for (int i=0; i<3; i++) {
    drawShapes();
    }
    
    
    //smallTriangleElements
    int smallCount = (int)random(20, 40);
    for (int i = 0; i < smallCount; i++) {
      drawSmallTriangle();
    }
   
   //semicircles sequence
    drawSemiCircles(6, 40, 100, height/2); //(number, radius, x position, y position)

   //smallCircles
   drawSmallCircles(30);
 
   //BigHaloCircle
   float R = 100;
   float M = 80;
   drawBigHaloCircle(R + M, R + M, R);
 
 
 
 
 //checkerboard
   float boardSide = 300;
    float cellSize = 24;                         //
    float margin = 40;
    float cx = width - margin - boardSide/2;
    float cy = margin + boardSide/2;
    
    drawCheckerboard(
      width - 200, 100, 400, 150, 24,
      PI/-6         //e.g. PI/4 = 45degree
     
     );
 
 //hashboard
 drawHashBoard(
  width/4, height *2/3, //location
  300, 150);
 
 //waveline
     fill(0);
     float wx = random(width);
     float wy = random(height);
     float angle = random(-PI/3, PI/3); 
     float len    = random(150, 500);        // length of wave line
     float amp    = random(30, 50);         // size..?
     float localStartX = -len/2.0;
     float localStartY = 0;
  
    pushMatrix();
    translate(wx, wy);   
    rotate(angle);       
    drawWave(localStartX, localStartY, len, amp);  
    popMatrix();
 
 
}
//=================================================================================



 



// randomly pick one color from palette - color ordering
color pick(color[] pal) {
  return pal[(int)random(pal.length)];
}


void drawBackTriangle() {
     //center point
     float cx = random(width);
     float cy = random(height);
     
     //base line and height
     float baseLn = random (50, 450);
     float h = random (50,1000);
     
     //rotate triangle
     float angle = random (TWO_PI);
     
     //baseline points
     PVector A = new PVector(-baseLn/2, 0);
     PVector B = new PVector(baseLn/2, 0);
     
     //Apex
     PVector C = new PVector(0, -h);
     
     //rotate
     A.rotate(angle);
     B.rotate(angle);
     C.rotate(angle);
     
     A.add(cx, cy);
     B.add(cx, cy);
     C.add(cx, cy);
     
     // color from palette
     color fc = pick(palette);
     fill(fc, 120);             
     stroke(0, 150);
     strokeWeight(1);
   
   
   
   triangle(A.x, A.y, B.x, B.y, C.x, C.y);
   
}


// Random Big Circles + outside gradient halo
void drawRandomCircles(int count) {
  for (int i = 0; i < count; i++) {
    // 1)size, location, color random
    float r = random(100, 200);  
    float halo = random(r * 0.1, r * 0.5); // always propotional to circles (10-50%)  
    float x = random(r + halo, width - (r + halo));  
    float y = random(r/2, height - (r + halo)); 

  
   color c = pick(palette);
    int guard = 0;
    while (c == #D8CBBB && guard < 5)  {  ///?
      c = pick(palette);
      guard++;
    }

  // outside halo
  int steps = 60;
  noStroke();
  for (int k=0; k<steps; k++) {
    float t = k/(float)(steps-1);          // 0~1
    float rr = r + t * halo;                 // current radius
    float a = lerp(10, 0, t);             // gradually transparent
    fill(c, a);
    ellipse(x, y, rr*2, rr*2);
  }

    // circle color
    color innerC = pick(palette);
    fill(innerC, 100);  
    stroke(0, 150);
    strokeWeight(1);
    ellipse(x, y, r * 2, r * 2);
  }
}    
  void drawShapes(){
    // simple lines  
      float x1 = random(width);
      float y1 = random(height);
      float x2 = random(width);
      float y2 = random(height);
      stroke (0, 150);
      strokeWeight (random(1,3));
      
      line(x1, y1, x2, y2);
    
   // lines to out canvas
     float x = random(width);
     float y = random(height);
     float angle = random(TWO_PI);
     float L = max(width, height) * 2;
     float x3 = x + cos(angle) * L;
     float y3 = Y + sin(angle) * L;
     stroke (0, 150);
     strokeWeight (random(1,3));
    
     line(x, y, x3, y3);
     
     //arc
     float cx = random(width);
     float cy = random(height);
     float r = random(50, 200);
     float a1 = random(TWO_PI);
     float a2 = a1 + random (PI/6, PI/2);
     noFill();
     stroke(0, 255);
     strokeWeight(random(1,2));
     arc(cx, cy, r*2, r*2, a1, a2); 
   
   
   //Hatching lines
   int hatchCount = (int)random(3, 7);   
  float len = random(40,500);                       // line length
  float step = random(2,12);                      // line space
  float angle2 = random(TWO_PI);         // line angle

        // center point
  float centerX = random(width);
  float centerY = random(height);

  pushMatrix();
  translate(centerX, centerY);
  rotate(angle2);

  stroke(0, 100);   
  strokeWeight(1);
  for (int i = 0; i < hatchCount; i++) {
    float y4 = i * step;
    line(-len/2, y4, len/2, y4);
  }

  popMatrix();

  }
  
void drawSmallTriangle() {
     //center point
     float cx = random(width); // same using "cx"-in drawBackTriangle- is ok, 
     float cy = random(height);
     float size = random(12, 42);
     float angle = random (TWO_PI);
     
     //baseline points
     PVector TA = new PVector(-size/2, size/2);
     PVector TB = new PVector(size/2, size/2);
     PVector TC = new PVector(0, -size/2);
     
     
     //rotate
     TA.rotate(angle);
     TB.rotate(angle);
     TC.rotate(angle);
     
     TA.add(cx, cy);
     TB.add(cx, cy);
     TC.add(cx, cy);
     
     // color from palette
     color fc = pick(palette);
     fill(fc, 120);             
     noStroke();  // Already have basic outline, remove outline -> add noStroke function. 
     
   
   
   
   triangle(TA.x, TA.y, TB.x, TB.y, TC.x, TC.y);
   
} 


//repeated semicircles
void drawSemiCircles(int n, float r, float startX, float startY) {
  noFill();
  stroke(0);
  strokeWeight(2);
  
  for (int i = 0; i < n; i++) {
    float cx = startX + i * 2 * r; 

      arc(cx + r, startY, 2*r, 2*r, 0, PI);
      fill(pick(palette), 200);
  }
}
  //smallCircles
  void drawSmallCircles(int count) {
    for (int i = 0; i < count; i++) {
      float r = random(5, 20);              
      float x = random(width);             
      float y = random(height);        
      color c = pick(palette);           

      noStroke();
      fill(c, 180);                     
      ellipse(x, y, r*2, r*2);
    }
  }  
  
  
  
  // left big circle + halo + inner purple color
void drawBigHaloCircle(float cx, float cy, float r) {
  // 1) red halo gradient 
  float halo = 100;    //halo size
  int steps = 70;    
  for (int k = 0; k < steps; k++) {
    float t = k / (float)(steps - 1);   
    float rr = r + t * halo;            
    float a = lerp(20, 0, t);          
    noStroke();
    fill(187, 48, 46, a);    // #BB302E -> rgb            
    ellipse(cx, cy, rr*2, rr*2);
  }

  // 2) inner purple color
  color purple = color(102, 84, 134);   
  noStroke();
  fill(purple);
  ellipse(cx, cy, 2*r, 2*r);

  // 3) thick outline (black)
  stroke(0);            
  strokeWeight(70);     
  noFill();
  ellipse(cx, cy, 2*r, 2*r);
  
}  
  
  
  
 // Center Isosceles Triangle
void drawCenterTriangle() {
  float H = height;            
  float L = width/3;         
  float cx = width/2;        
  
  //apex coordinates
  float ax = cx,        ay = 0;         // apex (top)
  float bx = cx - L/2,  by = height;    // base left
  float cx2 = cx + L/2, cy2 = height;   // base right

  // 1) inner color (pink)
  noStroke();
  for (int y = int(ay); y <= int(by); y++) {
    float t = map(y, ay, by, 0, 1);  // 0(top) -> 1 (bottom)
    // top: pink -> bottom: clear
    color c = lerpColor(color(187, 48, 46, 150), color(187, 48, 46, 0), t);
    stroke(c);

    
    float xLeft  = lerp(ax, bx, t);
    float xRight = lerp(ax, cx2, t);

    line(xLeft, y, xRight, y);
  }
  
  // 2) lines
  stroke(0);          
  strokeWeight(2);    
  line(ax, ay, bx, by);     // left side
  line(ax, ay, cx2, cy2);   // right side

}



  void drawCheckerboard(float cx, float cy, float w, float h, float cell, float angle) {
                         
                        
       pushMatrix();         /*save the current transformation state 
                              translate, rotate, scale
                              popMatrix -> restore the saved coordinate system
                              so, the transformation don't affect the rest. */
       translate(cx, cy);
       rotate(angle);
       
       int nx = ceil(w / cell); //why should I use this function??
       int ny = ceil(h / cell);       // cell size divide in side length
       float startX = -w / 2;
       float startY = -h / 2;
       
       
       rectMode(CORNER);
       
       
       // coloring only left side
       float leftSideColor = startX + w/3;
       
       for (int iy = 0; iy < ny; iy++) {
         for (int ix = 0; ix < nx; ix++) {
           float x = startX + ix * cell;
           float y = startY + iy * cell;
           
           if (x < leftSideColor) {
             // fill left side if inside 1/3 of the cell 
             fill(pick(palette));   /* problem : still fill in the other side 
                                     */
             stroke(0);
             strokeWeight(1);                        
                                     
           } else { 
             // 2/3 side - remain checkerboard & no color inside
             noFill();
             stroke(0);
             strokeWeight(1);                        
             
           }
     
          rect(x, y, cell, cell); 
         
         }
       }
                        
     popMatrix();                                      
    }
    
  
   void drawHashBoard (float cx, float cy, float w, float h) {
                       
      pushMatrix();
      translate(cx, cy);
      noStroke();
     
      float startX = -w/ 2;
      float startY = -h/ 2;
      
      
    //randomly fill hashboard
      int cols = 4, rows = 4;           
      float cellW = w / cols;
      float cellH = h / rows;
    
      int alpha = 160; 
      
       noStroke();
      for (int iy = 0; iy < rows; iy++) {
        for (int ix = 0; ix < cols; ix++) {
          if (ix >=1 && ix <=2 && iy >=1 && iy <=2) {   // only center 4 cells fill
          float x = startX + ix * cellW;
          float y = startY + iy * cellH;
          color c = pick(palette);
          fill(red(c), green(c), blue(c), alpha);
          rect(x, y, cellW, cellH);
      }
    }
  }
      
      
      
   stroke(0);
   strokeWeight(1.5);
   
   // vertical line
      line(startX + w/4, startY, startX + w/4, startY + h);
      line(startX + w/2, startY, startX + w/2, startY + h);
      line(startX + 3*w/4, startY, startX + 3*w/4, startY + h);
   
                       
   // horizontal line
     line(startX, startY + h/4, startX + w, startY + h/4);
     line(startX, startY + h/2, startX + w, startY + h/2);
     line(startX, startY + 3*h/4, startX + w, startY + 3*h/4);
   
   popMatrix();

 }
                       
  //waveline                     
  void drawWave(float wx, float wy, float len, float amp) {
  int steps = 100;                
  float thickStart = 20;          
  float thickEnd = 2;             

  beginShape(QUAD_STRIP);
  for (int i = 0; i <= steps; i++) {
    float t = i / float(steps);
    float x = wx + t * len;
    float y = wy + sin(TWO_PI * t * 2) * amp;  
    float w = lerp(thickStart, thickEnd, t);       

    
    float angle = atan2(cos(TWO_PI * t * 2) * amp * TWO_PI * 2 / len, 1);
    float nx = cos(angle + HALF_PI);
    float ny = sin(angle + HALF_PI);

    vertex(x + nx * w/2, y + ny * w/2);
    vertex(x - nx * w/2, y - ny * w/2);
  }
  endShape();
}




void mousePressed() {
  shapeSeed = (long)random(1<<30);
  redraw();
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    generatePalette(); 
    redraw();          
  }
}

color[] basePalette = {
  #345580, #D8CBBB, #D57A72, #EFB934, #BB302E, #338197
};



void generatePalette() {
  palette = new color[basePalette.length];
  for (int i=0; i<palette.length; i++) {
    palette[i] = basePalette[(int)random(basePalette.length)];
  }
}




// adding twist lines, checker board, ark with oneside thick line
// mousePress function & keyPress Function (necessary!!)
