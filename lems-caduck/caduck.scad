head=20;
res=20;
hull() { 
    scale([1,1,.9]) sphere(head, $fn=res); //head
    translate([head,0,-head*1.2]) difference() {
        scale([2,1.4,1]) sphere (head, $fn=res); //body
        translate([0,0,-head*1-6]) cube([head,head*3,head*2], center=true); //triming
    }
}
translate([-head*.9,0,-head/4]) color("red") scale([2, 1.5,.7]) sphere(head/4, $fn=res); //beak
difference (){
    translate([-head*.9,0,-head/4]) color("red") scale([2, 1.5,1.4]) sphere(head/4, $fn=res); //beak
    translate([-head*.9,0,head/4]) cube (head, center = true);
    }
translate([-head+head/7,head/3,head/4]) color("black") sphere(head/10, $fn=res); //eye
translate([-head+head/7,-head/3,head/4]) color("black") sphere(head/10, $fn=res); //eye