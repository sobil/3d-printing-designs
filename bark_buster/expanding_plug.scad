circle_resolution=360;

module tube(od=10, id=5, h) {
    difference() {
        cylinder(h, r = od / 2, $fn = circle_resolution);
        cylinder(h, r = id / 2, $fn = circle_resolution);
    }   
}

step=5;
length=26;
id=8.1;
od=20.5;
plug_od=13.5;

difference() {
    union() {
        tube(od, 8, step);
        tube(plug_od, 8, 26);
    }
    union() {
        translate([0,0,(length/2)+step+step]) cube([2,13.5,length], center=true);
        rotate([0,0,90]) translate([0,0,(length/2)+step+step]) cube([2,13.5,length], center=true);
    }
    translate([0,0,length-step]) cylinder(h = step, r1 = id/2, r2 = plug_od/2, $fn = circle_resolution);
}