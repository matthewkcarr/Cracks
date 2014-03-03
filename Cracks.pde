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
	println( "clicked at (x,y) (" + currMouseX + "," + currMouseY + ")" );
	RRect rect = new RRect( new RPoint(0, 0), new RPoint( currMouseX, currMouseY ) );
	println("rect p0 is (x,y) (" + rect.p0.x + "," + rect.p0.y + ")");
	println("rect p3 is (x,y) (" + rect.p3.x + "," + rect.p3.y + ")");
  acrack = new Crack( rect );
  acrack.display();
}
 
class Crack {

	ArrayList<CrackLine> crackLineList;
	RRect bCrackRect;
	final int numCrackLines = 1;

  Crack(RRect bcr) {
		bCrackRect = bcr;
		crackLineList = new ArrayList<CrackLine>();
		createCrackLines();
	}

	void createCrackLines() {
	  for( int i = 0; i < numCrackLines; i++ ) {
			CrackLine cline = new CrackLine(bCrackRect);
			crackLineList.add( cline );
		}
	}

  void display() {
	  for( int i = 0; i < crackLineList.size(); i++ ) {
			crackLineList.get(i).display();
		}
  }
}
 
 
class CrackLine {
  
  
	ArrayList<RVector> vectorList;
	ArrayList<RVector> displayList;
	RRect igrid;
	int sections = 2;

  CrackLine(RRect initial_grid) {
		igrid = initial_grid;
		//create 2 vectors 
		//"a crack"
		vectorList = new ArrayList<RVector>();
		displayList = new ArrayList<RVector>();
		makeVectorList();
		crackVectors();
  }
	void crackVectors() {
	  for( int i = 0; i < vectorList.size(); i++ ) {
			RVector vec = vectorList.get(i);
			RRect rec = new RRect( vec.p1, vec.p2 );
			//get random point in rec
			RPoint rpoint = rec.randPointInRect(); 
			// add two vectors with points from three vectors we have
			RVector v1 = new RVector( vec.p1, rpoint ); 
			RVector v2 = new RVector( rpoint, vec.p2 ); 
			displayList.add(v1);
			displayList.add(v2);
		}
	}

	void makeVectorList() {
		ArrayList<RPoint> points = igrid.cvector.sectionify(sections);
		println("points size is " + points.size() );
		for(int i = 0; i < points.size() + 1; i++ )  {
			RVector vec;
			if( i == 0 ) {
				RPoint sp1 = igrid.p0;
				RPoint sp2 = points.get(i);
				vec = new RVector( sp1, sp2);
			} else if( i == points.size() ) {
				RPoint sp1 = points.get(i-1);
				RPoint sp2 = igrid.p3;
				vec = new RVector( sp1, sp2);
			} else {
				RPoint sp1 = points.get(i);
				RPoint sp2 = points.get(i + 1);
				vec = new RVector( sp1, sp2);
			}
		  //println("vector p1 points are (x,y) (" + igrid.cvector.p1.x + "," + igrid.cvector.p1.y + ")");
		  //println("vector p2 points are (x,y) (" + igrid.cvector.p2.x + "," + igrid.cvector.p2.y + ")");
		  //println(i + " (x,y) (" + cpoint.x + "," + cpoint.y + ")"); 
			println("points size - " + points.size() + " adding i -" + i);
			vec.print();
			vectorList.add(vec);
		}
	}
  
  void display() { 
	  for( int i = 0; i < displayList.size(); i++ ) {
			RVector dvec = displayList.get(i);
			line( dvec.p1.x, dvec.p1.y, dvec.p2.x, dvec.p2.y);
		}
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

class RVector {

  RPoint p1;
  RPoint p2;
  float slope;
  float magnitude;

  RVector( RPoint rp1, RPoint rp2) {
		if( rp1.x + rp1.y <= rp2.x + rp2.y ) {
			p1 = rp1;
			p2 = rp2;
		} else {
			p1 = rp2;
			p2 = rp1;
		}
    calculateSlope();
    calculateMagnitude();
  }
  
	//dividing into 2 means we get a midpoint
	ArrayList<RPoint> sectionify(int t) {
		ArrayList<RPoint> points = new ArrayList<RPoint>();
		for( int i = 0; i < t; i++ ) {
			float x = p1.x * (i/(1-t)) + p2.x * i/t;
			float y = p1.y * (i/(1-t)) + p2.y * i/t; 
			println("sectioned (x,y) (" + x  + "," + y + ")" );
			RPoint r = new RPoint(x, y);
			if( i != 0 )
				points.add(r);
		}
		return points;
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
	void print() { 
		println( "(x1,y1) (" +  p1.x + "," + p1.y + ")");
		println( "(x2,y2) (" +  p2.x + "," + p2.y + ")");
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

class RPoint {

  float x;
  float y;

  RPoint( float nx, float ny ) {
    x = nx;
    y = ny;
  }

}


