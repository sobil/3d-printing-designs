

inner_radius=6;






module plate(inner_width,inner_length,top_dome=0,height=2) {
    hull() {
        translate([inner_radius,inner_radius,0])cylinder(height,r=inner_radius);
        translate([inner_width-inner_radius,inner_radius,0]) cylinder(height,r=inner_radius);
        translate([inner_width-inner_radius,inner_length-inner_radius,0]) cylinder(height,r=inner_radius);
        translate([inner_radius,inner_length-inner_radius,0]) cylinder(height,r=inner_radius);
        if (top_dome>0) {
            translate([inner_width/2,inner_length-inner_radius,0]) scale([1,(inner_radius+top_dome)*2/inner_width,1]) cylinder(height,r=inner_width/2);
        }
    }
}

module tube(od,id,height) {
    difference() {
        cylinder(h=height,d=od);
        cylinder(h=height,d=id);
    }
}

wall=4;

width=82;
height=133;
 difference() {
    plate(width+wall*2,height+wall*2,height=7);
    translate([wall,wall,0]) plate(width,height,2,height=7);
 }

translate([19.5,67.5,0]) tube(10,4,10);
translate([(width+2*wall)-19.5,67.5,0]) tube(10,4,10);

empty_width=40;
empty_height=90;
difference() {
    translate([wall,wall,0]) plate(width,133,2,height=2);
    translate([(width+2*wall)/2-empty_width/2,(height/2)-(empty_height/2),0]) cube([empty_width,empty_height,5]);
}

translate([15,15,0]) tube(10,5,5);
translate([(width+2*wall)-15,15,0]) tube(10,5,5);

translate([15,100,0]) tube(10,5,5);
translate([(width+2*wall)-15,100,0]) tube(10,5,5);
//72-4.5
 
 