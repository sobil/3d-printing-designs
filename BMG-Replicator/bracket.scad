//OpenSCAD version 2021.01
//Bracket for mounting a single BMG extruder to Makerbot Dual Extruder carriage
//Simon Pilepich 2021-09-16


mount_hole_spacing=73.3;
mount_hole_diameter=3;


w=12.5;
d=16;
h=15;
// cube([w,w,16]);

a();
mirror([1,0,0]) a();

module a() {
    y_offset = 21.5;
    //nema bracket riser
    nbr=[65,40,15];
    difference() {
        cube([nbr[0]/2,nbr[1],nbr[2]]);
        translate([0,40/2-20/2,0]) {
            //space saving hole
            cube([nbr[0]/2-10,nbr[1]-10,nbr[2]]);
        }
        translate([nbr[0]/2-5,5,0]) cylinder(d=3,h=h,$fn=30);
        translate([nbr[0]/2-5,nbr[1]/2,0]) cylinder(d=3,h=h,$fn=30);
        translate([nbr[0]/2-5,nbr[1]-5,0]) cylinder(d=3,h=h,$fn=30);

    }
    translate([mount_hole_spacing/2-w/2,+w/2-y_offset,0]) {
        cube([w,nbr[1],h/2]);
    }
    translate([mount_hole_spacing/2-w/2,-w/2-y_offset,]) {
        difference() {
            cube([w,w,h+3]);
            translate([w/2,w/2,0]) cylinder(d=3.2,h=h+3,$fn=30);
            translate([w/2,w/2,0]) cylinder(d=6,h=h/2,$fn=6);
        }
    }
}