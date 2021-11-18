//OpenSCAD version 2021.01
//Bracket for mounting a single BMG extruder to Makerbot Dual Extruder carriage
//Simon Pilepich 2021-09-16



h=17; //Height to raise the bracket by

mount_hole_spacing=73.3;
mount_hole_diameter=3;
mount_hole_nut=5.5;
w=12.5; // width of attachment square
carriage_width = 130; // Overall carrier width
mount_hole_nut_radius=mount_hole_nut/2/sin(30)/sin(60); //Calculate diameter for nut
y_offset = 21.5-4; // Back spacing




one_side();
mirror([1,0,0]) one_side();

module one_side() {
    //NEMA bracket riser
    nbr=[carriage_width/2,40,h];
    difference() {
        //NEMA base block
        cube([nbr[0]/2,nbr[1],nbr[2]]);
        translate([0,w/2,0]) {
            //space saving hole
            cube([nbr[0]/2-10,nbr[1],nbr[2]]);
            //arch
            scale([((nbr[0]/2)-10)/(h-w/2),1,1]) translate([0,0,h]) rotate([90,0,0]) cylinder(r=h-w/2,h=w/2);
        }
        //NEMA bracker mount screw 
        translate([nbr[0]/2-5,5,0]) cylinder(d=3,h=h,$fn=30);
        translate([nbr[0]/2-5,nbr[1]/2,0]) cylinder(d=3,h=h,$fn=30);
        translate([nbr[0]/2-5,nbr[1]-5,0]) cylinder(d=3,h=h,$fn=30);

    }
    //Connecting brace
    translate([mount_hole_spacing/2-w/2,+w/2-y_offset,0]) {
        difference() {
            cube([w,nbr[1],w/2]);
            //Connecting brace holes
            translate([+w/2,5,0]) cylinder(d=3,h=h,$fn=30);
            translate([+w/2,nbr[1]/2,0]) cylinder(d=3,h=h,$fn=30);
            translate([+w/2,nbr[1]-5,0]) cylinder(d=3,h=h,$fn=30);
        }
    }
    //mount post
    translate([mount_hole_spacing/2-w/2,-w/2-y_offset,]) {
        difference() {
            cube([w,w,h+3]);
            //Through hole
            translate([w/2,w/2,0]) cylinder(d=3.2,h=h+3,$fn=30);
            // Nut hex (d=6.25 for 5.5mm nut)
            translate([w/2,w/2,0]) cylinder(d=mount_hole_nut_radius,h=h/2,$fn=6);
        }
    }
}