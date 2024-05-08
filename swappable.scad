module Pick() {
	difference() {
		cube([20, 20, 5]);
		translate([0, 1.5, 0]) {
			cube([20, 17, 3.5]);
			translate([0, 1.5, 0]) {
				cube([20, 14, 5]);
			}
		}
	}

}

module Circle(dia) { circle(d=dia, $fn=10);
}
module Circle1() {
	Circle(4);
}
module Circle2() {
	Circle(1.5);
}
module Circle3() {
	Circle(1.7);
}
module BaseHoles() {
	Circle1();
	translate([-3.81, 2.54, 0]) {
		Circle2();
	}
	translate([2.54, 5.08, 0]) {
		Circle2();
	}
	translate([5.08, 0, 0]) {
		Circle3();
	}
	translate([-5.08, 0, 0]) {
		Circle3();
	}
}
module SwitchBase () {
	thickness = 3;
	wire_thickness = 0.7;
	diode_length = 4;
	diode_thickness = 2;

	// TODO: replace Path and Path2 to Path3.
	module Path(length) {
		cube([length, wire_thickness, wire_thickness]);
	}
	module Path2(length) {
		cube([length, wire_thickness, wire_thickness], true);
		children();
	}
	module Path3(length) {
		translate([length/2, 0, wire_thickness/2]) {
			cube([length, wire_thickness, wire_thickness], true);
		}
		children();
	}
	module DiodeWirePath(length) {
		translate([length/2, 0, diode_thickness/2]) {
			Path2(length);
		}
		translate([length/2, 0, wire_thickness/2]) {
			Path2(length);
		}
		children();
	}
	module Diode() {
		translate([diode_length/2 + 1.4, 0, diode_thickness/2]){
			cube([diode_length, diode_thickness + 0.7, diode_thickness], true);
		}
	}

	difference() {
		linear_extrude(thickness) {
			difference() {
				square(14, false);
				translate([7, 7, 0]) {
					BaseHoles();
					translate([-2, -7, 0]) {
						square([4, 7]);
					}
				}
			}
		}

		translate([7, 7, 0]) {
			translate([0, 0, thickness]) {
				mirror([0, 0, 1]) {
					translate([2.54, 5.08, 0]) {
						rotate([0, 0, -85]) {
							DiodeWirePath(7.5) {
								translate([7.5, 0, 0]) linear_extrude(5) Circle(1);
							};
							Diode();
						}
						rotate([0, 0, 180]) Path3(3) {
							translate([3, 0, 0]) linear_extrude(3) Circle(1);
						}
							
					}

					translate([5, -2.5, 0]) Path3(10) linear_extrude(5) Circle(1);

					translate([-3.81, 2.54 - wire_thickness/2, 0]) {
						mirror([1, 0, 0])
							Path(5);
					}

					translate([-3.81 - wire_thickness/2, 2.54, 0]) {
						rotate([0, 0, 90]) {
							mirror([0, 1, 0]) {
								Path(5);
							}
						}
					}
				}
			}
		}
	}
}

render() SwitchBase();

// translate([0, 0, 1.5]) {
// 	render() Pick();
// }
// linear_extrude(1.5) {
// 	difference() {
// 		square(20);
// 		translate([3, 3, 0]) {
// 			square(14);
// 		}
// 	}
// 	translate([3, 3, 0])
// 		SwitchBase();
// }
echo(concat([1, 2], [0]));
