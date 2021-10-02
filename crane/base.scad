//OpenSCAD version 2021.01
//Mount for curtain rod spool holder for lack table 3d printer setup
//Simon Pilepich 2021-09-16

rod_diameter=25.7;

circle_resolution=20; //drop for faster renders when devving. 100 prints well
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







//middle_follower();
//socket(closeable=true);
main_follower();


//crane_base();
//sockets();

module main_follower() {
    socket(for_base=false, closeable=true);
    translate([z_rail_spacing*0.5+od/2+rod_diameter/2,0,0]) rotate([-90,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder();
    translate([-z_rail_spacing*0.5-od/2-rod_diameter/2,0,0]) rotate([-90,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder();
    middle_follower();
}



module old_follower(rod_diameter) {

    translate([plate_width/2+rod_diameter/2+z_rail_spacing/2,-thickness-nema_width-rod_diameter/2-thickness,-plate_width/2+(2*od)+rod_diameter/2]) rotate([270,180,0]) crane_base();
    difference() {
        hull() {
            color("red") translate([nema_width/2,-thickness-nema_width-rod_diameter/2-thickness,-plate_width+(2*od)+rod_diameter/2]) cube([plate_width-rod_diameter/2,thickness,nema_width]);
            //translate([plate_width/2+rod_diameter/2+z_rail_spacing/2,-thickness-nema_width-rod_diameter/2-thickness,-plate_width/2+(2*od)+rod_diameter/2]) rotate([270,180,0]) sockets(b=false);
            translate([nema_width*0.5+od/2,0,0]) rotate([-90,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder(base_only=true);
        }
        hull() translate([plate_width/2+rod_diameter/2+z_rail_spacing/2,-thickness-nema_width-rod_diameter/2-thickness,-plate_width/2+(2*od)+rod_diameter/2]) rotate([270,180,0]) sockets(b=false);
    }
    mirror ([1,0,0]) {    
        difference() {
            hull() {
                color("red") translate([nema_width/2,-thickness-nema_width-rod_diameter/2-thickness,-plate_width+(2*od)+rod_diameter/2]) cube([plate_width-rod_diameter/2,thickness,nema_width]);
                //translate([plate_width/2+rod_diameter/2+z_rail_spacing/2,-thickness-nema_width-rod_diameter/2-thickness,-plate_width/2+(2*od)+rod_diameter/2]) rotate([270,180,0]) sockets(b=false);
                translate([nema_width*0.5+od/2,0,0]) rotate([-90,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder(base_only=true);
            }
            hull() translate([plate_width/2+rod_diameter/2+z_rail_spacing/2,-thickness-nema_width-rod_diameter/2-thickness,-plate_width/2+(2*od)+rod_diameter/2]) rotate([270,180,0]) sockets(b=false);
        }
    }
    translate([nema_width*0.5+od/2,0,0]) rotate([-90,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder();
    translate([-nema_width*0.5-od/2,0,0]) rotate([-90,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder();
    translate([(-z_rail_spacing-od)/2,0,0]) cube([z_rail_spacing+od,z_rail_spacing+2*rod_diameter,rod_diameter]);
    
    middle_follower();




    translate([-nema_width*0.5-od/2,0,0]) rotate([-90,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder();
}

module z_slide_bp() {
}

module middle_follower() {
    difference() {
        hull() middle_follower_bearings(base_only=true);
        translate([0,(z_rail_spacing+rod_diameter)/2,0]) cylinder(h=100,d=8);
    }
    //mirror([0,0,1]) hull() middle_follower_bearings(base_only=true);
    middle_follower_bearings();
    //mirror([0,0,1]) middle_follower_bearings();
    
}

module middle_follower_bearings(base_only=false) {
    rotate([-90-120,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder(base_only);
    //rotate([-90+120,0,0]) translate([0,0,-rod_diameter/2])  bearing_holder(base_only);
    translate([.5*z_rail_spacing,z_rail_spacing+rod_diameter,0]) mirror([0,1,0]) rotate([-90-120,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder(base_only);
    // translate([.5*z_rail_spacing,z_rail_spacing+rod_diameter,0]) mirror([0,1,0]) rotate([-90+120,0,0]) translate([0,0,-rod_diameter/2])  bearing_holder(base_only);
    translate([-.5*z_rail_spacing,z_rail_spacing+rod_diameter,0]) mirror([0,1,0]) rotate([-90-120,0,0]) translate([0,0,-rod_diameter/2]) bearing_holder(base_only);
    // translate([-.5*z_rail_spacing,z_rail_spacing+rod_diameter,0]) mirror([0,1,0]) rotate([-90+120,0,0]) translate([0,0,-rod_diameter/2])  bearing_holder(base_only);
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


module nema_17_plate(open_top=false,thickness=thickness,screw_hole=3.5) {
    screw_spacing=nema_screw_spacing;
    
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


//socket
//closing_tab(clearance=true);
module socket(closeable=false,closing_bolt=6, for_base=true) {
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
            if (closeable==true) {
                 translate([-plate_width/2,-1.5*thickness,0]) {closing_tab(clearance=true);}
            };
        }
        if (closeable==true) {
            translate([-plate_width/2,-1.5*thickness,0]) closing_tab(closing_bolt);
        }
        }
    //socket for tube
    translate([0,0,0]) cylinder(socket_length, d=rod_diameter, $fn = circle_resolution);
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