//OpenSCAD version 2021.01
//Mount for curtain rod spool holder for lack table 3d printer setup
//Simon Pilepich 2021-09-16

rod_diameter=25.4;

circle_resolution=50; //drop for faster renders when devving. 100 prints well
plate_width=50.5; //square plate width
hole=5; //screw holes (and relative corner radius)
thickness=5; //base and gerneral wall thickness
socket_length=rod_diameter; // how far to stick out
motor_offset=11;
z_rail_spacing=42.3;





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

module sockets() {
    socket();
    translate([z_rail_spacing+rod_diameter,0,0]) socket();   
}


module nema_17_plate(open_top=false,thickness=thickness,screw_hole=3.5) {
    nema_width=42.3;
    screw_spacing=31;
    nema_boss_diameter=22;
    nema_length=57.3;
    
    difference() {
        base(nema_width,nema_length,radius=hole,hole=screw_hole,thickness=thickness);
        //cube([nema_width,nema_width,thickness]);
        translate([nema_width/2,nema_width/2,0]) cylinder(h=thickness,d=nema_boss_diameter);
        if (open_top == true) {
            translate([nema_width/2-nema_boss_diameter/2,nema_width/2,0]) cube([nema_boss_diameter,nema_width/2,thickness]);
        }
        translate([nema_width/2-(screw_spacing+screw_hole)/2,nema_width/2-(screw_spacing+screw_hole)/2,0])
        screw_holes(screw_hole,0,thickness,screw_spacing+screw_hole,screw_spacing+screw_hole);
    }
}

//socket
module socket() {
    difference () {
    union () {
      //smoothed reinforced block
      hull() {
        translate([plate_width/2,plate_width/2,thickness]) scale([.5,1,1]) cylinder(socket_length, d1=plate_width,d2=rod_diameter+2*thickness, $fn = circle_resolution);
        translate([plate_width/2,plate_width/2,thickness]) scale([1,.5,1]) cylinder(socket_length, d1=plate_width,d2=rod_diameter+2*thickness, $fn = circle_resolution);
        translate([plate_width/2,plate_width/2,thickness]) tube(od=rod_diameter+2*thickness,id=rod_diameter,length=socket_length);
      }
    }
    //socket for tube
    translate([plate_width/2,plate_width/2,thickness]) cylinder(socket_length, d=rod_diameter, $fn = circle_resolution);
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