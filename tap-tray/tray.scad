//OpenSCAD version 2021.01
//Tray for ebay tap and die set https://www.ebay.com.au/itm/402929867350
//Simon Pilepich 2021-09-19

circle_resolution=100;
drill_diameter=20;
handle_diameter=7;
tray_radius=2;
tap_clearance=0.2;
spacing=8;

taps = [
[3,47],
[4,55.2],
[5,56],
[6,60.3],
[8,60.7]
];

tray_length=addoffsets(taps,(len(taps)-1))+2*drill_diameter+len(taps)*spacing+2*spacing;

tray_size=[tray_length,105,15];



difference() {
  //tray  
  base(tray_size[0],tray_size[1],tray_size[2],tray_radius);
  //tool cut out
  translate([30,4,tray_size[2]]) rotate([-90,90,0]) driver();
  translate([9,19,tray_size[2]]) mirror([0,0,1]) base(23,15,drill_diameter/2,2);
  //taps cutout
  translate([50,35,tray_size[2]]) taps();
}

module base(x,y,z,radius) {
    module post() {
    cylinder(z-radius,r=radius,$fn=circle_resolution);
    translate([0,0,z-radius]) sphere(radius, $fn=circle_resolution);
    }
    hull() {
        translate([0+radius,0+radius,0]) post();
        translate([0+radius,y-radius,0]) post();
        translate([x-radius,0+radius,0]) post();
        translate([x-radius,y-radius,0]) post();
    }
}

function addoffsets(array,pos,sum=0) = 
    pos <= -1 ?
        sum : 
        addoffsets(array,pos-1, sum+array[pos][0]);

module taps() {
    for (i=[0:len(taps)-1]) {  
        tap_size=taps[i];
        translate([-spacing/2,0,0]) mirror([0,0,1]) base(addoffsets(taps,i)+spacing*i+spacing/2,10,drill_diameter/2,2);
        translate([addoffsets(taps,i)+spacing*i-tap_size[0],0,0]) {
            rotate([-90,0,0]) tap(tap_size[1], tap_size[0]);
        }
    }
}

module driver() {
  cylinder(h=97,d=drill_diameter,$fn=circle_resolution);//body
  translate([0,drill_diameter/2+11,21]) rotate([90,0,0,]) cylinder(h=100,d=handle_diameter,$fn=circle_resolution);//handle
}

module tap(length, diameter) {
    cylinder(h=length, d=diameter+tap_clearance,$fn=circle_resolution);
}