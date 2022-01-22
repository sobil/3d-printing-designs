// OpenSCAD version 2021.01
// Throttle CAM
// Simon Pilepich 2021-10-02

hex = 22;
hex_od = hex / 2 / sin(30) / sin(60);  echo("Hex OD=",hex_od);
// Calculate diameter for nut
t = 5;
thickness = t;
res = 50;
circle_resoluition = res;
min_diamater = hex_od + 5;
step=1;
start_height = 05;
end_height = 8;
degrees = 120;
cable_diameter = 1;
cable_end_diameter = 4;
guide_length = .3; // 70%


main();


module cam(start_height, end_height, degrees, thickness = t) {
    A=5;
    step=(end_height-start_height)/degrees;
    translate([0,0,-t/2]) difference() {
        hull() {
            for(i=[0:A:degrees-1]) {
                h1=min_diamater/2+start_height+i*step;
                h2=min_diamater/2+start_height+(i+1)*step;
                c_over_sin_C=h1/sin(90);
                width=c_over_sin_C*sin(A);
                b=sqrt(pow(h1,2)-pow(width,2))-(start_height-end_height)*(i/120);
                rotate([0,270,i]) {
                    wedge(thickness,h1,h2,width);
                    // polyhedron(
                    //     points=[
                    //     [0,0,0], //0
                    //     [t,0,0], //1
                    //     [t,h1,0], //2
                    //     [0,h1,0], //3
                    //     [0,h2,a], //4
                    //     [t,h2,a]], //5
                    //     faces=[
                    //     [0,1,2,3], //A
                    //     [5,4,3,2], //B
                    //     [0,4,5,1], //C
                    //     [0,3,4],  //D
                    //     [5,2,1]]); //E
                }
            }
        }
        cylinder(d=min_diamater, h=t);
    }
}

module wedge(t,h1,h2,width) {
    polyhedron(
        points=[
            [0,0,0], //0
            [t,0,0], //1
            [t,h1,0], //2
            [0,h1,0], //3
            [0,h2,width], //4
            [t,h2,width]], //5
            faces=[
            [0,1,2,3], //A
            [5,4,3,2], //B
            [0,4,5,1], //C
            [0,3,4],  //D
            [5,2,1]
        ]
    ); //E
}


module guide(height, angle) {
    cam(height, height, angle, thickness/3);
    translate([0,0,thickness*2/3])cam(height, height, angle, thickness/3);
}


module main() {
    difference() {
        union() {
            cylinder(d = min_diamater, h = t, center = true, $fn = res);
            guide(height=start_height+5,angle=degrees*guide_length);
            cam(start_height, end_height, degrees);
        }
        // hex
        cylinder(d = hex_od, h = t, center = true, $fn = 6);
         // step
        translate([ 0, 0, t / 2 - step ]) cylinder(d = hex_od, h = t, $fn = res);
        a = 360 / ((min_diamater + start_height) * PI / (cable_end_diameter)) ;
        echo(str("Variable = ", a));
        rotate([0,0,a]) translate([0,min_diamater/2+start_height+cable_diameter,-t/2]) 
            {
                cylinder(d=cable_end_diameter, h=t, $fn = res);
                translate([-cable_diameter/2,0,t/3]) cube([cable_diameter,10,5]);
            }   
    }
}