int currMouseX;
int currMouseY;
int x_screen_size = 300;
int y_screen_size = 300;

//to use this look at
//http://www.processing.org/discourse/beta/num_1233971698.html

static CGeometry Geom = CGeometry.getInstance();
 
void setup() {
  background(255);
  size(x_screen_size, y_screen_size);
  //acrack = new Crack( int(10 + random(100)), 1, 1);
 
}
 
void display() {
 
 // acrack.display();
}
 
void draw() {
  display();
}
 
/*void mouseMoved() {
    int mouseNormX = mouseX;
    int mouseNormY = mouseY;
    //float mouseVelX = (mouseX - pmouseX);
    //float mouseVelY = (mouseY - pmouseY);
    println("pmouse x: " + pmouseX);
    println("pmouse y: " + pmouseY);
    println("mouse x: " + mouseX);    println("mouse y: " + mouseY);
    acrack = new Crack( int(10 + random(100)), 1, 1);
    //addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY);
}*/
 
//maybe use two clicks and make mouse x,y, 0,0 a dead spot
void mouseClicked() {
  currMouseX = mouseX;
  currMouseY = mouseY;
  Crack acrack;
  acrack = new Crack( 100, 1, 1);
  acrack.display();
}
 
class Crack {
  CrackLine acrackLine;
  CrackLine bcrackLine;
  CrackLine ccrackLine;
//this should be a list of crack vectors
  
  int len;
  float cdx;
  float cdy;
  
  Crack(int ilen, float idx, float idy) {
    len = ilen;
    cdx = idx;
    cdy = idy;
    
    /*acrackLine = new CrackLine(cdx, cdy, 0, 0, len);
    CrackPoint acp = acrackLine.randomPointOnLine();
    bcrackLine = new CrackLine(4, 1, acp.x, acp.y, (len/4));
    acp = acrackLine.randomPointOnLine();
    ccrackLine = new CrackLine(1, 4, acp.x, acp.y, (len/4));
*/
  
}
  
  void display() {
//    acrackLine.display();
    //draw subline
//    bcrackLine.display();
//    ccrackLine.display();
  }
}
 
 
class CrackLine {
  
  
	ArrayList<RVector> vectorList;
	RRect igrid;

  CrackLine(RRect initial_grid) {
		igrid = initial_grid;
		RRect r1 = new RRect( igrid.p0.x, igrid.p1.y, );
		//create four vectors based on random point in 2 rect
		//"a crack"
  }
  
  void display() { 
  }
}
 
class CrackVector {

  RVector v1;
  RVector v2;

  CrackVector( RVector rv1, RVector rv2 ) {
    v1 = rv1;
    v2 = rv2;
  }
	void display() {
		v1.display();
		v2.display();
	}
}

/*
class CrackPoint {
  RPoint cp;
  CrackVector v;
  
  CrackPoint( int nx, int ny, CrackVector cv ) {
    cp = new RPoint(nx, ny);
    v = cv;
  }
}*/


class RVector {

  RPoint p1;
  RPoint p2;
  float slope;
  float magnitude;

  RVector( RPoint rp1, RPoint rp2) {
		if( rp1.x + rp1.y >= rp2.x + rp2.y ) {
			p1 = rp1;
			p2 = rp2;
		} else {
			p1 = rp2;
			p2 = rp1;
		}
    calculateSlope();
    calculateMagnitude();
  }
  
	ArrayList<RPoint> sectionify(int t) {
		ArrayList<RPoint> points = new ArrayList<RPoint>();
		for( int i = 0; i < t; i++ ) {
			float x = p1.x * (1-t) + p2.x * t;
			float y = p1.y * (1-t) + p2.y * t; 
			RPoint r = new RPoint(x, y);
			points.add(r);
		}
	}

  private void calculateMagnitude() {
    float d = 0;
    float a = sq( p2.x - p1.x);
    float b = sq( p2.y - p1.y);
    magnitude = sqrt(a + b);
  }
       
  private void calculateSlope() {
    slope = 0;
    float x = p1.x - p2.x;
    float y = p1.y - p2.y;
    slope = y / x;
  }

  boolean pointIsBetween(RPoint c) {
    float crossproduct = (c.y - p1.y) * (p2.x - p1.x) - (c.x - p1.x) * (p2.y - p1.y);
    if(abs(crossproduct) > EPSILON) 
      return false;   // (or != 0 if using integers)

    float dotproduct = (c.x - p1.x) * (p2.x - p1.x) + (c.y - p1.y)*(p2.y - p1.y);
    if(dotproduct < 0) 
      return false;

    float squaredlengthba = (p2.x - p1.x)*(p2.x - p1.x) + (p2.y - p1.y)*(p2.y - p1.y);
    if(dotproduct > squaredlengthba )
      return false;

    return true;
  }

  /*CrackPoint randomPointOnLine() {
    
    float rand_l = random(len);
    float rand_x;
    float rand_y;
    if ( x_mult >= y_mult) {
      rand_x = rand_l;
      rand_y = (rand_x * x_mult) / y_mult;
      //float rand_y = rand_x * ( x_mult / y_mult);
    }
    else {
      rand_y = rand_l;
      rand_x = (rand_y * y_mult) / x_mult;
    }
    float real_x = rand_x + x_start;
    float real_y = rand_y + y_start;
    //these are reversed because we solved for each.
    println("(rx, ry) -> (" + real_x + ", " + real_y + ")" );
    acp = new CrackPoint( int(real_x), int(real_y));
    return acp;
  }*/

	void display() {
		line( p1.x, p1.y, p2.x, p2.y);
	}
}

//Given a imaginary horizontal line between two points, find the rect

class RRect {

  RPoint p0;
  RPoint p1; //zeroed y value
  RPoint p2; //zeroed x value
  RPoint p3;
	RVector cvector;

  //use lesser valued points for the base number
  RRect( RPoint rp0, RPoint rp3 ) {
    if( (rp0.x + rp0.y) <= ( rp3.x + rp3.y) ) {
      p0 = rp0;
      p3 = rp3;
    } else {
      p0 = rp3;
      p3 = rp0;
    }
		cvector = new RVector(p0, p3);
    findPoints();
  }

  //Generate other two rectangle points
  void findPoints() {
    p1 = new RPoint( p0.x + p3.x, p3.y);
    p2 = new RPoint( p3.x, p0.y + p3.y);
  }

  boolean pointIsInRect( RPoint np ) {
    if( (np.x >= p0.x && np.x <= p3.x ) &&
        (np.y >= p0.y && np.y <= p3.y ) ) {
      return true;
    }
    return false;
  }
  
  RPoint randPointInRect() {
    float rx = p0.x + random( p3.x );
    float ry = p0.y + random( p3.y );
    return new RPoint( rx, ry);
  }

}

class RPoint {

  float x;
  float y;

  RPoint( float nx, float ny ) {
    x = nx;
    y = ny;
  }

}

