// model of and supporting models for a (micro) servo
// author: Christophe VG <contact@christophe.vg>

$fn = 50;

// examples:
// KY66 SG90 Micro Servo Motor        : 23   x 12.2 x 29   mm
// KY61 MG90S Metal Micro Servo Motor : 22.8 x 12.2 x 28.5 mm
// Tower Pro SG90 Digital             : 23   × 12.2 x 29   mm

// see image drawing dimensions for information
// about measurements a through f to configure the modules

// Kuman MG 90S (=Tower Pro SG90)
$a  = 32.70;  // height bottom to top of spline
$b  = 23.90;  // length short side to side
$cb = 22.50;  // height of body
$ct =  5.96;  // height of turret
$d  = 12.70;  // width long side to side
$e  = 32.60;  // length, including wings
$f  = 18.30;  // height bottom to underside of wings
// wings - to check
$wt =  2.80;        // thinkness of wings
$wd =  2.00;        // diameter of screw holes
$wc =  2.00;        // distance from wing border
// spline
$sd =  4.80;       // diameter

function servo_top() = $a;
function servo_wing_to_top() = $a - $f;

// servo - the 3d model of the servo
// centered around vertical axis through middle of spline
// and leveled around the mounting wings
// default: top-mounted, bottom-mounted via "bottom" parameter/flag
module servo(bottom=false, clearance=0, with_screw_holes=true) {
  x = $d + 2*clearance;
  y = $b + 2*clearance;
  
  translate([-x/2, -(y-x/2), -$f + (bottom ? -$wt : 0) ]) {
    // main body
    cube( [x, y, $cb] );
    // wings
    translate([0, -($e - y)/2, $f]) {
      difference() {
        cube( [x, $e, $wt] );
        // screw holes
        if(with_screw_holes) {
          translate([x/2, $wc, 0])    { cylinder( $wt, d=$wd ); }
          translate([x/2, $e-$wc, 0]) { cylinder( $wt, d=$wd ); } 
        }
      }
    }
    // "turret"
    translate([x/2, y-x/2, $cb ]) {
      cylinder($ct, d=$d);
    }
    // spline
    translate([x/2, y-x/2, $cb + $ct ]) {
      cylinder($a - $cb - $ct, d=$sd);
    }
  }
}

module servo_bottom_mount_inset(clearance=0) {
  x = $d + 2*clearance;
  y = $b + 2*clearance;
  
  translate([-x/2, -(y-x/2), -($cb+$ct) ]) {
    // main body
    cube( [x, y, $cb+$ct] );
    // wings
    translate([0, -($e - y)/2, 0]) {
      difference() {
        cube( [x, $e, $f+$wt] );
      }
    }
  }
}

spline_height = $a - $cb - $ct;
turret_top = $a - spline_height;
top_wings_to_top_turret = turret_top - ($f + $wt);

// translate([0,0,-top_wings_to_top_turret]) {
//   color("red") { servo(bottom=true, clearance=0.2); }
// }
// servo_bottom_mount_inset(clearance=0.2);

// servo_mount - the cutout that can hold the servo
// centered around vertical axis through middle of spline
module servo_mount(t=$a) {
  translate([-$d/2, -($b-$d/2), 0]) {
    // main body
    cube( [$d, $b, t] );
    // screw holes
    translate([0, -($e - $b)/2, 0]) {
      translate([$d/2, $wc, 0])    { cylinder( t, d=$wd ); }
      translate([$d/2, $e-$wc, 0]) { cylinder( t, d=$wd ); } 
    }
  }
}

module demo() {
  difference() {
    cube([ 70, 50, 5 ] );
    translate([25, 25, 0]) { servo_mount(t=5); }
    translate([50, 25, 0]) { servo_mount(t=5); }
  }
  translate([25, 25, 5]) { color("red") { servo(); } }
  // the servo and mount are centered around the spline
  translate([25, 25, -40]) { color("blue") { cylinder(80, d=1); } }
  
  // mount_inset demo
  translate([-25, 25, 0]) {
    translate([0,0,-top_wings_to_top_turret]) {
      color("red") { servo(bottom=true, clearance=0.2); }
    }
    servo_bottom_mount_inset(clearance=0.2);
  }
}

$vpt = [ 16.87, 20.88, 16.90 ];
$vpr = [ 71.10, 0.00, 27.10 ];
$vpd = 310;
demo();
