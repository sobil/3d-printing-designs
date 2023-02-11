
// Constants

rod_diameter = 25.7;
y_rail_spacing = 600;
y_length = 600;

x_rail_spacing = 70;
x_rail_vertical_offset = 100;
x_length = y_rail_spacing;

z_rail_spacing = 70;
z_rail_offset_from_x_axis = rod_diameter * 2;
z_rail_vertical_offset = x_rail_vertical_offset;
z_length = 200;

color("green", alpha = 0.05) Y_rails();
color("red", alpha = 0.05) X_rails();
color("blue", alpha = 0.05) Z_rails();
color("pink", alpha = 0.2) Y_carriages();

module
Y_rails()
{
    translate([ -y_rail_spacing / 2, 0 ]) rotate([ 0, 90, 90 ])
        cylinder(h = y_length, d = rod_diameter, center = true);
    translate([ y_rail_spacing / 2, 0 ]) rotate([ 0, 90, 90 ])
        cylinder(h = y_length, d = rod_diameter, center = true);
}

module
X_rails()
{
    translate([ 0, 0, x_rail_vertical_offset ]) rotate([ 90, 0, 90 ])
        cylinder(h = x_length, d = rod_diameter, center = true);
    translate([ 0, 0, x_rail_vertical_offset + x_rail_spacing ])
        rotate([ 90, 0, 90 ])
            cylinder(h = x_length, d = rod_diameter, center = true);
}

module
Z_rails()
{
    z_offset = x_rail_vertical_offset + x_rail_vertical_offset / 2;
    translate([ -z_rail_spacing / 2, z_rail_offset_from_x_axis, z_offset ])
        rotate([ 0, 0, 0 ])
            cylinder(h = z_length, d = rod_diameter, center = true);
    translate([ z_rail_spacing / 2, z_rail_offset_from_x_axis, z_offset ])
        rotate([ 0, 0, 0 ])
            cylinder(h = z_length, d = rod_diameter, center = true);
}

module Bearing(id, od, width)
{
    difference()
    {
        cylinder(h = width, d = od, center = true);
        cylinder(h = width, d = id, center = true);
    }
}

module Bearing_pack(id, od, width, rod_diameter, number)
{
    angular_seperation = 360 / number;
    for (i = [0:number - 1]) {
        echo(str("b = ", i));
        rotate([ 0, angular_seperation * i, 0 ])
            translate([ 0, 0, rod_diameter / 2 + od / 2 ]) rotate([ 0, 90, 0 ])
                Bearing(id = id, od = od, width = width);
    }
}

module Bearing_holder(base_only = false)
{
    translate([ 0, 0, -1.5 * od ])
    {
        difference()
        {
            union()
            {
                difference()
                {
                    hull()
                    {
                        translate(
                            [ -od / 2, -thickness - bearing_width / 2, 0 ])
                            cube([
                                od,
                                thickness * 2 + bearing_width,
                                thickness
                            ]);
                        if (base_only == false) {
                            translate(
                                [ 0, (thickness * 2 + bearing_width) / 2, od ])
                                rotate([ 90, 0, 0 ])
                                    cylinder(h = thickness * 2 + bearing_width,
                                             d = id + (od - id) / 2);
                        }
                    }
                    translate([
                        0,
                        bearing_width * (1 + bearing_clearance_precentage) / 2,
                        od
                    ]) rotate([ 90, 0, 0 ])
                        cylinder(h = bearing_width *
                                     (1 + bearing_clearance_precentage),
                                 d = od * (1 + bearing_clearance_precentage));
                }
                if (base_only == false) {
                    difference()
                    {
                        translate(
                            [ 0, (thickness * 2 + bearing_width) / 2, od ])
                            rotate([ 90, 0, 0 ])
                                cylinder(h = thickness * 2 + bearing_width,
                                         d = id + (od - id) / 4);
                        translate([ 0, (bearing_width) / 2, od ])
                            rotate([ 90, 0, 0 ]) cylinder(
                                h = bearing_width, d = id + (od - id) / 2);
                    }
                }
            }
            translate([ 0, (thickness * 2 + bearing_width) / 2, od ])
                rotate([ 90, 0, 0 ])
                    cylinder(h = thickness * 2 + bearing_width, d = id);
        }
    }
}

module
Y_carriages()
{
    translate([ -y_rail_spacing / 2, 0, 0 ]) Y_carriage();
}

module
Y_carriage()
{
    bearing_seperation = 100;
    bearing_od = 22;
    bearing_id = 8;
    bearing_width = 7;
    translate([ 0, -bearing_seperation / 2, 0 ])
    {
        Bearing_pack(od = bearing_od,
                     id = bearing_id,
                     width = bearing_width,
                     rod_diameter = rod_diameter,
                     number = 3);
        translate([ 0, 0, rod_diameter / 2 + bearing_od / 2 ])
        {
            translate([ -bearing_width, 0, 0 ])
                cube([ bearing_width, bearing_od, bearing_od ], center = true);
            translate([ +bearing_width, 0, 0 ])
                cube([ bearing_width, bearing_od, bearing_od ], center = true);
        }
    }
    translate([ 0, bearing_seperation / 2, 0 ])
        Bearing_pack(od = bearing_od,
                     id = bearing_id,
                     width = bearing_width,
                     rod_diameter = rod_diameter,
                     number = 3);
}