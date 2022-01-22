// A base box for the switch box for a Bridgeport mill 
circle_resolution = 50;
o = 0;
origin = o;
x = 172.5;
y = 130.7;
wall  = 3;
z=40;
post_offset = 15;
post_od = 10;
post_id = 5;
edge_radius=10;

difference() {
    //main box
    box(z = z,x = x,y = y,r = edge_radius);
    //make hollow
    translate([wall,wall,0]) box(z = z,x = x-2*wall,y = y-2*wall,r = edge_radius-wall);
    //Top lip
    translate([wall*.5,wall*.5,z-wall]) box(z = z,x = x-wall,y = y-wall,r = edge_radius-wall*.5);
}
//corner supports
translate([post_offset-post_od/2,post_offset-post_od/2,0]) 4_posts(x=x-post_od-post_offset, y=y-post_od-post_offset, z=z, od=post_od, id=post_id, supports=true);
//center post
translate([x/2,y/2,0]) {
    difference() {
        union() {
            translate([-x/2,-wall/2,0]) cube([x,wall,10]);
            translate([-wall/2,-y/2,0]) cube([wall,y,10]);
        }
        cylinder(d=post_od,h=10);
    }
    tube(od=post_od, id=post_id, h=z);
    post_support();
    rotate([0,0,180]) post_support();
    //centerpost brace
}



module box(x, y, z, r) {
    x=x-r;
    y=y-r;
    hull() {
        4_posts(x=x, y=y, z=z, od=r*2, id=0, supports = false);
    }    
}

module 4_posts(x, y, z, od, id, supports=false) {
    r=od/2;
    translate([r,r,0]) {
        tube(od=od, id=id, h=z);
        if (supports == true) post_support();
    }
    translate([x,r,0]) {
        tube(od=od, id=id, h=z);
        if (supports == true) rotate([0,0,90]) post_support();
    };
    translate([r,y,0]){
        tube(od=od, id=id, h=z);
        if (supports == true) rotate([0,0,270]) post_support();
    }
    translate([x,y,0]) {
        tube(od=od, id=id, h=z);
        if (supports == true) rotate([0,0,180]) post_support();
    }
}

module post_support() {
    difference() {
        translate([-post_offset+wall/2,-post_offset+wall/2,0]) cube([post_offset,post_offset,z-wall]);
        translate([-post_offset+wall/2,-post_offset+wall/2,0]) cube([post_offset-wall,post_offset-wall,z]);
        tube(od=post_od, id=0, h=z);
    }
}

module tube(od=10, id=5, h) {
    difference() {
        cylinder(h, r = od / 2, $fn = circle_resolution);
        cylinder(h, r = id / 2, $fn = circle_resolution);
    }
}