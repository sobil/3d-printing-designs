//OpenSCAD version 2021.01
//Bracket for mounting a single BMG extruder to Makerbot Dual Extruder carriage
//Simon Pilepich 2021-09-16

//Works pankake stepper motor

h=17; //Height to raise the bracket by

mount_hole_spacing=73.3;
mount_hole_diameter=3;
mount_hole_nut=5.5;
w=12.5; // width of attachment square
carriage_width = 130; // Overall carrier width
mount_hole_nut_radius=mount_hole_nut/2/sin(30)/sin(60); //Calculate diameter for nut
y_offset = 21.5-4; // Back spacing
circle_resolution = 20; res = circle_resolution;
nema_bracket_thickness= 2.5;
nema_length = 24;




// comment each out to export discrete stls
guide();
riser();
translate([0,0,0]) rotate([180,0,180]) color("orange") nema_bkt();



module guide() {
    translate([mount_hole_spacing/2-w/2,+w/2-y_offset,-w/2]) {    
        thickness = 2;
        difference() {
        cube([w,nema_length+2.5,w/2]);
        translate([+w/2,5,0]) cylinder(d=3,h=h,$fn=res);
        translate([+w/2,(nema_length+2.5)/2,0]) cylinder(d=3,h=h,$fn=res);
        translate([+w/2,(nema_length+2.5)-5,0]) cylinder(d=3,h=h,$fn=res);
         translate([thickness,0,-thickness]) cube([w-thickness*2,nema_length+nema_bracket_thickness+y_offset-(w/2),w/2]);
        }
}
}



module riser() {
  one_side();
  mirror([1,0,0]) one_side();
}

module one_side() {
    //NEMA bracket riser
    nbr=[carriage_width/2,nema_length+2.5,h];
    difference() {
        //NEMA base block
        cube([nbr[0]/2,nbr[1],nbr[2]]);
        translate([0,w/2,0]) {
            //space saving hole
            cube([nbr[0]/2-10,nbr[1],nbr[2]]);
            //Plastic saving arch
            scale([((nbr[0]/2)-10)/(h-w/2),1,1]) translate([0,0,h]) rotate([90,0,0]) cylinder(r=h-w/2,h=w/2, $fn=res);
        }
        //NEMA bracker mount screw 
        translate([nbr[0]/2-5,nbr[1]/4,0]) cylinder(d=3,h=h,$fn=res);
        translate([nbr[0]/2-5,nbr[1]/2,0]) cylinder(d=3,h=h,$fn=res);
        translate([nbr[0]/2-5,nbr[1]/4*3,0]) cylinder(d=3,h=h,$fn=res);

    }
    //Connecting brace
    translate([mount_hole_spacing/2-w/2,+w/2-y_offset,0]) {
        difference() {
            cube([w,nema_length+nema_bracket_thickness+y_offset-(w/2),w/2]);
            //Connecting brace holes
            translate([+w/2,5,0]) cylinder(d=3,h=h,$fn=res);
            translate([+w/2,nbr[1]/2,0]) cylinder(d=3,h=h,$fn=res);
            translate([+w/2,nbr[1]-5,0]) cylinder(d=3,h=h,$fn=res);
        }
    }
    //mount post
    translate([mount_hole_spacing/2-w/2,-w/2-y_offset,]) {
        difference() {
            cube([w,w,h+3]);
            //Through hole
            translate([w/2,w/2,0]) cylinder(d=3.2,h=h+3,$fn=res);
            // Nut hex (d=6.25 for 5.5mm nut)
            translate([w/2,w/2,0]) cylinder(d=mount_hole_nut_radius,h=h/2,$fn=6);
        }
    }
}


module nema_bkt() {
    nema_length = 24;
    thickness = 2.5;
    clearance = 0;
    nema_width=42.3;
    wing_width=8;
    nema_screw_hole=4;
    nema_screw_spacing=31;
    base_screw_hole=3;
    mount_hole_spacing=15;
    nema_boss_size=23;
    translate([-wing_width-thickness-clearance-nema_width/2,0,0]) {
        translate([wing_width,0,0]) {
            difference() {
                cube([nema_width+clearance+thickness*2,nema_length+thickness,nema_width+thickness]);
                translate([thickness, thickness, thickness]) cube([nema_width,nema_length+thickness,nema_width]);
                translate([thickness+clearance/2+nema_width/2, thickness, nema_width/2+thickness]) {
                    rotate([90,0,0]) cylinder(d=nema_boss_size,h=thickness);
                    translate([-nema_screw_spacing/2,0,nema_screw_spacing/2]) rotate([90,0,0]) cylinder(d=nema_screw_hole,h=thickness,$fn=res);
                    translate([nema_screw_spacing/2,0,nema_screw_spacing/2]) rotate([90,0,0]) cylinder(d=nema_screw_hole,h=thickness,$fn=res);
                    translate([-nema_screw_spacing/2,0,-nema_screw_spacing/2]) rotate([90,0,0]) cylinder(d=nema_screw_hole,h=thickness,$fn=res);
                    translate([+nema_screw_spacing/2,0,-nema_screw_spacing/2]) rotate([90,0,0]) cylinder(d=nema_screw_hole,h=thickness,$fn=res);
                }
                angle = atan(nema_length/nema_width);
                translate([0,nema_length+thickness,thickness]) rotate([angle,0,0]) cube([nema_width+clearance+2*thickness+2*wing_width+thickness,nema_width*2,nema_width*2]);
            }
        }
        wing_midpoint=(nema_length+thickness)/2;
        difference() {
            cube([nema_width+(2*wing_width)+(2*thickness)+clearance,nema_length+thickness,thickness]);
            translate([wing_width/2,wing_midpoint/2*3,0]) cylinder(d=base_screw_hole,h=thickness,$fn=res);
            translate([wing_width*1.5+nema_width+thickness*2,wing_midpoint/2*3,0]) cylinder(d=base_screw_hole,h=thickness,$fn=res);
            translate([wing_width/2,wing_midpoint/2,0]) cylinder(d=base_screw_hole,h=thickness,$fn=res);
            translate([wing_width*1.5+nema_width+thickness*2,wing_midpoint/2,0]) cylinder(d=base_screw_hole,h=thickness,$fn=res);
        }
    }
}
