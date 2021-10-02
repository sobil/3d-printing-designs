//OpenSCAD version 2021.01
//Mount for curtain rod spool holder for lack table 3d printer setup
//Simon Pilepich 2021-10-02

circle_resolution=30;
t=2;
tooth_depth=.7;


inner_z_clearance=5;

tube(15,12,10);
translate([0,0,7]) tube(15.5,12,3);
tube(34,30,inner_z_clearance);
translate([0,0,-t]) tube(34,0,t);
translate([-25,-inner_z_clearance,-t]) cube([10,10,inner_z_clearance+t]);
rotate([0,0,0]) translate([-12/2,0,0]) cube([tooth_depth,tooth_depth,10,]);
rotate([0,0,90]) translate([-12/2,0,0]) cube([tooth_depth,tooth_depth,10,]);
rotate([0,0,180]) translate([-12/2,0,0]) cube([tooth_depth,tooth_depth,10,]);
rotate([0,0,270]) translate([-12/2,0,0]) cube([tooth_depth,tooth_depth,10,]);


//a hollow cylider   
module tube(od, id, length) {
    difference() {
        cylinder(length, r = od / 2, $fn = circle_resolution);
        cylinder(length, r = id / 2, $fn = circle_resolution);
    }
}

module roundbox(x,y,z) {
    }