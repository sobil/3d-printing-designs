
//Speedo drive ring for the Yamaha TTR 250 with the analoge speedo
//By simon.pilepich@gmail.com Jan 2020
//https://www.youtube.com/watch?v=sA4e6sW0mGw
//
//Please use or modify this however you like without credit or liability

diameter_rd=31; //outer diameter of the the ring
diameter_id=22; //doesn't actually get used.
diameter_sd=26.1; //step diameter (the step has the the flats on it.)
diameter_md=28.5; //inner diameter of the tube.
face_distance=24.3; //                                       


width = (diameter_rd - diameter_sd)/2;
cutback = (diameter_md - diameter_sd)/2;
lip = 1.7;
height = lip*2;
tab_width = 5;
tab_length = 3;
tab_height = lip*2;
o = diameter_sd/2;

module tab() {
rotate([0, 0, 0])
    translate ([o+(width/2),0-(tab_width/2),height-tab_height])
        cube(size=[tab_length+(width/2),tab_width,tab_height]);
}

module internal_face() {
    translate ([face_distance/2,0-(tab_width),height-lip])
        cube(size=[width,tab_width*2,lip]);
}


union(){
    //This is the basic shape
    rotate_extrude($fn = 80)
        polygon( points=[[o+cutback,0],[o+width,0],[o+width,height],[o,height],[o,height-lip],[o+cutback,height-lip]]);
    
    //Add 3 tabs ad different angles
    tab();
    rotate([0, 0, 120])
        tab();
    rotate([0, 0, 240])
        tab();
    
    // Add the internal flat bits
    internal_face();
    rotate([0, 0, 180])
        internal_face();   
}
