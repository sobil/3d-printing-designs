//OpenSCAD version 2021.01
//Mount for curtain rod spool holder for lack table 3d printer setup
//Simon Pilepich 2021-09-16

rod_diameter=25.7;

circle_resolution=100; //drop for faster renders when devving. 100 prints well
plate_width=50.5; //square plate width
hole=5; //screw holes (and relative corner radius)
thickness=5; //base and gerneral wall thickness
socket_length=rod_diameter; // how far to stick out
motor_offset=11;
z_rail_spacing=42.3;
closeable=true;
bearing_width=7;
id=8;
od=22;
bearing_clearance_precentage=.1;
nema_width=42.3;
nema_screw_spacing=31;
nema_boss_diameter=22;
nema_length=57.3;
nema_screw_diameter=3.5;
r_rail_spacing= z_rail_spacing+rod_diameter+od+thickness;


//middle_follower();
//socket(closeable=true);
//main_follower();
// middle_follower();
//crane_base();
//sockets();


// follower_belt_mount();
//main_follower();

//rails();
//old_middle_follower();
// nema_idler();


module nema_idler() {
  nema_17_plate();
  translate([nema_width/2,nema_width/2]) {
    difference() {
      union() {
        cylinder(d=nema_boss_diameter,h=thickness, $fn=circle_resolution);
        cylinder(d1=nema_boss_diameter,d2=id+(od-id)/2,h=thickness*3, $fn=circle_resolution);
      }
      cylinder(d=8,h=thickness*3, $fn=circle_resolution);
    }
  }
}

module main_follower() {
  mf_lower();
  mirror([1,0,0]) mf_lower();
}



module mf_lower() {
  translate([-nema_width/2,-nema_width-rod_diameter/2-thickness/2-od/2,rod_diameter/2+thickness/2-thickness]) nema_17_plate(open_top=true);
  
  translate([r_rail_spacing/2,0,0]) {
    difference() {
    hull() {
      translate([0,+socket_length/2-rod_diameter/2-thickness/2-nema_width-od/2,rod_diameter+thickness/2]) rotate([90,0,180]) socket(for_base=false, closeable=false);
      translate([0,+od*1.5-nema_width-rod_diameter/2-thickness/2-od/2,0]) rotate([-90,0,0]) translate([0,0,0]) bearing_holder(base_only=true);
      translate([0,+od*1.5-nema_width-rod_diameter/2-thickness/2-od/2+socket_length-thickness,0]) rotate([-90,0,0]) translate([0,0,0]) bearing_holder(base_only=true);
      translate([-r_rail_spacing/2+nema_width/2,-nema_width-rod_diameter/2-thickness/2-od/2,rod_diameter/2+thickness/2-thickness]) cube([thickness,socket_length,thickness]);
      
    }
    hull() translate([0,+socket_length/2-rod_diameter/2-thickness/2-nema_width-od/2,rod_diameter+thickness/2]) rotate([90,0,180]) socket(for_base=false, closeable=false);
    }
    translate([0,+socket_length/2-rod_diameter/2-thickness/2-nema_width-od/2,rod_diameter+thickness/2]) rotate([90,0,180]) socket(for_base=false, closeable=true);
    translate([0,-rod_diameter/2,0]) rotate([-90,0,0]) translate([0,0,0]) bearing_holder();
  }
}

module z_slide_bp() {
}

module middle_follower() {
}

// old_middle_follower();



module follower_belt_mount() {
    gap=1.5;
    id=8;
    t=1;
    h=10;
    od=id+2*t;
    pitch=2;
    c=PI*2*od/2;
    n = (c-(c % pitch))/pitch;
    T =360/n;
    adjusted_od = n*pitch/PI;
    difference() {
      tube(id+t*2,id,h);
      for ( i = [0 : n-1] ){
        rotate( i * T, [0, 0, 1])
          translate([0, adjusted_od/2, 0]) {
          cylinder(r=.75,h=h,$fn=10);
          }
      }
    }
    //inner
    
    difference() {
        tube(id+4*t+2*gap,id+2*t+2*gap,10);
        translate([0,-2,3]) cube([id+4*t+gap,4,h]);
    }
    tube(id+4*t+2*gap,id,2*t);
    
}


module old_middle_follower() {
  difference() {
    hull() {
      old_middle_follower_bearings(base_only=true);
    }
    //bolt holes
    translate([(z_rail_spacing/2),(z_rail_spacing+rod_diameter)/2,0]) cylinder(h=100,d=8);
        mirror(1,0,0) translate([(z_rail_spacing/2),(z_rail_spacing+rod_diameter)/2,0]) cylinder(h=100,d=8);
  }
  old_middle_follower_bearings();
  
}

module old_middle_follower_bearings(base_only=false, rodholder=false) {
  if(base_only == false && rodholder==true) {
    translate([+r_rail_spacing/2,0,rod_diameter+thickness/2]) rotate([0,90,90]) socket(for_base=false, half=true);
    translate([-r_rail_spacing/2,0,rod_diameter]) rotate([0,90,270]) socket(for_base=false, half=true);
  }
  translate([.5*z_rail_spacing,0,0]) rotate([-90-120,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder(base_only);
  translate([-.5*z_rail_spacing,0,0]) rotate([-90-120,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder(base_only);
  translate([.5*z_rail_spacing,z_rail_spacing+rod_diameter,0]) mirror([0,1,0]) rotate([-90-120,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder(base_only);
  translate([-.5*z_rail_spacing,z_rail_spacing+rod_diameter,0]) mirror([0,1,0]) rotate([-90-120,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder(base_only);

}

module bearing_holder(base_only=false)
  {
  translate([0,0,-1.5*od]) {
    difference() {
      union () {
        difference() {
          hull() {
            translate([-od/2,-thickness-bearing_width/2,0]) cube([od,thickness*2+bearing_width,thickness]);
            if (base_only==false) {
              translate([0,(thickness*2+bearing_width)/2,od]) rotate([90,0,0]) cylinder(h=thickness*2+bearing_width,d=id+(od-id)/2);
            }
          }
          translate([0,bearing_width*(1+bearing_clearance_precentage)/2,od]) rotate([90,0,0]) cylinder(h=bearing_width*(1+bearing_clearance_precentage),d=od*(1+bearing_clearance_precentage));
        }
        if (base_only==false) {
          difference() {
            translate([0,(thickness*2+bearing_width)/2,od]) rotate([90,0,0]) cylinder(h=thickness*2+bearing_width,d=id+(od-id)/4);
            translate([0,(bearing_width)/2,od]) rotate([90,0,0]) cylinder(h=bearing_width,d=id+(od-id)/2);
          }
        }
      }
      translate([0,(thickness*2+bearing_width)/2,od]) rotate([90,0,0]) cylinder(h=thickness*2+bearing_width,d=id);
    }
  }
}

module crane_base() {
  //Sockets
  difference() {
    sockets();
    hull() translate([plate_width/2+rod_diameter/2,plate_width-0,thickness]) rotate([90,0,0]) nema_17_plate(open_top=true,thickness=plate_width,screw_hole=6);
  }

  //Nema mount
  translate([plate_width/2+rod_diameter/2,plate_width/2-motor_offset+thickness,thickness]) rotate([90,0,0]) nema_17_plate(open_top=true,thickness=thickness);
  difference () {
    intersection() {
      translate([plate_width/2+rod_diameter/2,plate_width-0,thickness]) rotate([90,0,0]) nema_17_plate(open_top=true,thickness=plate_width,screw_hole=6);
      sockets();
    }
    translate([plate_width/2+rod_diameter/2,plate_width/2-motor_offset+thickness,thickness]) rotate([90,0,0]) hull() nema_17_plate(open_top=true,thickness=plate_width,screw_hole=6);
  }

  //Base plate
  difference() {
    hull() {
      base(x=plate_width,radius=hole, hole=hole, thickness=thickness);
      translate([z_rail_spacing+rod_diameter,0,0]) base(x=plate_width,radius=hole, hole=hole, thickness=thickness);
    }
    hull() base(x=plate_width,radius=hole, hole=hole, thickness=thickness);
    hull() translate([z_rail_spacing+rod_diameter,0,0]) base(x=plate_width,radius=hole, hole=hole, thickness=thickness);
    translate([plate_width/2+rod_diameter/2,plate_width/2-motor_offset,0]) {
      hull() mirror([0,1,0]) nema_17_plate(open_top=true,thickness=thickness,screw_hole=0);
    }
  }
  difference() {
    base(x=plate_width,radius=hole, hole=hole, thickness=thickness);
    translate([plate_width/2,plate_width/2,0]) cylinder(d=rod_diameter/1.2,h=thickness);

  }
  difference() {
    translate([z_rail_spacing+rod_diameter,0,0]) base(x=plate_width,radius=hole, hole=hole, thickness=thickness);
    translate([z_rail_spacing+rod_diameter+plate_width/2,plate_width/2,0]) cylinder(d=rod_diameter/1.2,h=thickness);
  }
  translate([plate_width/2+rod_diameter/2,plate_width/2-motor_offset,0]) {
    mirror([0,1,0]) nema_17_plate(open_top=true,thickness=thickness,screw_hole=0);
  }
}


module sockets(a=true,b=true) {
  if(a == true) translate([0,0,thickness]) translate([plate_width/2,plate_width/2,socket_length/2]) socket(closeable=true);
  if(b == true)translate([z_rail_spacing+plate_width+rod_diameter,0,thickness])mirror([1,0,0]) translate([plate_width/2,plate_width/2,socket_length/2])  socket(closeable=true);   
}


module nema_17_plate(open_top=false,thickness=thickness,screw_hole=3.5,plate_radius=0) {
  screw_spacing=nema_screw_spacing;
  
  difference() {
    cube([nema_width,nema_width,thickness]);
    //cube([nema_width,nema_width,thickness]);
    translate([nema_width/2,nema_width/2,0]) cylinder(h=thickness,d=nema_boss_diameter);
    if (open_top == true) {
      translate([nema_width/2-nema_boss_diameter/2,nema_width/2,0]) cube([nema_boss_diameter,nema_width/2,thickness]);
    }
    translate([nema_width/2-(screw_spacing+screw_hole)/2,nema_width/2-(screw_spacing+screw_hole)/2,0]) {
      screw_holes(screw_hole,0,thickness,screw_spacing+screw_hole,screw_spacing+screw_hole);
    }
  }
}

module closing_tab(closing_bolt=6,clearance=false) {
    difference() {
      cube([plate_width/2,3*thickness,socket_length]);
      if (clearance==false) {
        translate([0,thickness,0]) cube([plate_width/2,thickness,socket_length]);
      }
      translate([closing_bolt,0,socket_length/2]) rotate([-90,0,0])cylinder(h=3*thickness,d=closing_bolt);
    }
    if (clearance==true) {
      translate([closing_bolt,-plate_width/2,socket_length/2]) rotate([-90,0,0]) cylinder(h=plate_width,d=2*closing_bolt);
    }
}


module socket(closeable=false,closing_bolt=6, for_base=true, clearance=false, half=false) {
  translate([0,0,-socket_length/2]) {
    difference () {
      union () {
      difference () {
        //smoothed reinforced block
        hull() {
          if (for_base== true) {
            translate([0,0,0]) scale([.5,1,1]) cylinder(socket_length, d1=plate_width,d2=rod_diameter+2*thickness, $fn = circle_resolution);
            translate([0,0,0]) scale([1,.5,1]) cylinder(socket_length, d1=plate_width,d2=rod_diameter+2*thickness, $fn = circle_resolution);
          }
          translate([0,0,0]) tube(od=rod_diameter+2*thickness,id=rod_diameter,length=socket_length);
        }
        if (closeable==true && clearance==false) {
          translate([-plate_width/2,-1.5*thickness,0]) closing_tab(clearance=true);
        };
      }
      if (closeable==true) {
        translate([-plate_width/2,-1.5*thickness,0]) closing_tab(closing_bolt);
        if (clearance==true) translate([-plate_width/2,-1.5*thickness,0]) closing_tab(clearance=true);

      }
    }
    //socket for tube
    if (clearance==false) translate([0,0,0]) cylinder(socket_length, d=rod_diameter, $fn = circle_resolution);
    if (half==true) translate([-rod_diameter/2-thickness,-rod_diameter-2*thickness,0]) cube(rod_diameter+thickness*2);
    }
  }
}

//a plate with holes in it
module base (x,y, radius,hole,thickness) {
  width=x;
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

module rails() {
    color("red",alpha=.05) R_rails();
    color("yellow",alpha=.05) Z_rails();
  
}
module Z_rails() {
  rotate([90,0,90]) cylinder(h=200,d=rod_diameter, center=true);
  translate([0,z_rail_spacing+rod_diameter,0]) rotate([90,0,90]) cylinder(h=200,d=rod_diameter, center=true);
}
module R_rails() {
  translate([(-r_rail_spacing)/2,0,rod_diameter+thickness/2]) rotate([90,90,0]) cylinder(h=200,d=rod_diameter, center=true);
  translate([(r_rail_spacing)/2,0,rod_diameter+thickness/2]) rotate([90,90,0]) cylinder(h=200,d=rod_diameter, center=true);
}

belt_pully();

module belt_pully() {
  t=1;
  translate([0,0,-t]) tube(od=od+4*t,id=od-3*t,length=t);
  tube(od=od+2*t,id=od, length=bearing_width);
  tube(od=od+2*t,id=od, length=bearing_width);
  translate([0,0,bearing_width]) tube(od=od+4*t,id=od,length=t);
}