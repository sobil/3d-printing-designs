//OpenSCAD version 2021.01
//Mount for curtain rod spool holder for lack table 3d printer setup
//Simon Pilepich 2021-09-16

rod_diameter=22.5;

circle_resolution=100; //drop for faster renders when devving. 100 prints well
plate_width=50.5; //square plate width
hole=5; //screw holes (and relative corner radius)
thickness=4; //base and gerneral wall thickness
socket_length=rod_diameter; // how far to stick out


//base plate
base(plate_width,radius=hole, hole=hole, thickness=thickness);
//socket
intersection() {
  difference () {
    union () {
      //smoothed reinforced block
      hull() {
        translate([plate_width/2-thickness-rod_diameter/2,plate_width/2-thickness-rod_diameter/2+(rod_diameter+2*thickness)/2,thickness]) cube([rod_diameter+2*thickness,rod_diameter/2,socket_length]);
        translate([plate_width/2,plate_width/2,thickness]) scale([.5,1,1]) cylinder(socket_length, d1=plate_width,d2=rod_diameter+2*thickness, $fn = circle_resolution);
        translate([plate_width/2,plate_width/2,thickness]) scale([1,.5,1]) cylinder(socket_length, d1=plate_width,d2=rod_diameter+2*thickness, $fn = circle_resolution);
        translate([plate_width/2,plate_width/2,thickness]) tube(od=rod_diameter+2*thickness,id=rod_diameter,length=socket_length);
      }
    }
    //socket for tube
    translate([plate_width/2,plate_width/2,thickness]) cylinder(socket_length, d=rod_diameter, $fn = circle_resolution);
    //open top
    translate([plate_width/2-rod_diameter/2,plate_width/2,thickness]) cube([rod_diameter,rod_diameter,socket_length]);
    //translate([0,plate_width/2+rod_diameter/2+0,thickness]) cube([plate_width,plate_width,socket_length]);
  }
  //smooth the top half
  union() {
    //keep lower half
    cube([plate_width,plate_width/2+socket_length/2, socket_length/2+thickness]);
    //keep bottom half
    cube([plate_width,plate_width/2, socket_length*2]);
    //keep a radius edge
    color("red") translate([0,,plate_width/2,socket_length/2+thickness]) rotate([0,90,0]) scale([1,1,1]) cylinder(plate_width,d=socket_length);
  }
}


//a plate with holes in it
module base (width, radius,hole,thickness) {
    difference () {
        hull() screw_holes(2*radius,hole,thickness,width,width);
        translate([thickness/4,thickness/4,0]) screw_holes(2*radius,0,thickness,width-thickness/2,width-thickness/2);
    }
    translate([thickness/4,thickness/4,0]) screw_holes(2*radius,hole,thickness,width-thickness/2,width-thickness/2);
}

//rectangular spaces screw holes
module screw_holes(post_diameter, screw_diameter, length,x,y) {
    od = post_diameter;
    r = post_diameter/2;
    o=0;
    translate([r, r, o]) tube(od, screw_diameter, length);
    translate([x - r, y - r, o]) tube(od, screw_diameter, length);
    translate([x - r, o + r, o]) tube(od, screw_diameter, length);
    translate([o + r, y - r, o]) tube(od, screw_diameter, length);
}

//a hollow cylider   
module tube(od, id, length) {
    difference() {
        cylinder(length, r = od / 2, $fn = circle_resolution);
        cylinder(length, r = id / 2, $fn = circle_resolution);
    }
}