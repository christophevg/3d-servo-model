// model of and supporting models for a (micro) servo
// author: Christophe VG <contact@christophe.vg>

$fn = 50;

// examples:
// KY66 SG90 Micro Servo Motor        : 23   x 12.2 x 29   mm
// KY61 MG90S Metal Micro Servo Motor : 22.8 x 12.2 x 28.5 mm
// Tower Pro SG90 Digital             : 23   × 12.2 x 29   mm

// see image drawing dimensions for information
// about measurements a through f to configure the modules

// Kuman MG 90S
$a  = 32.70;
$b  = 23.90;
$cb = 22.50;
$ct =  5.96;
$d  = 12.70;
$e  = 32.60;
$f  = 18.30;

// wings - to check
$wt =  2.80;        // thinkness
$wd =  2.10;        // diameter of screw holes
$wc =  2.00;        // distance from wing border

// spline
$sd =  4.80;       // diameter

function servo_top() = $a;

// servo - the 3d model of the servo
// centered around vertical axis through middle of spline
// and leveled around the mounting wings
// default: top-mounted, bottom-mounted via "bottom" parameter/flag
module servo(bottom=false) {
  translate([-$d/2, -($b-$d/2), -$f + (bottom ? -$wt : 0) ]) {
    // main body
    cube( [$d, $b, $cb] );
    // wings
    translate([0, -($e - $b)/2, $f]) {
      difference() {
        cube( [$d, $e, $wt] );
        // screw holes
        translate([$d/2, $wc, 0])    { cylinder( $wt, d=$wd ); }
        translate([$d/2, $e-$wc, 0]) { cylinder( $wt, d=$wd ); } 
      }
    }
    // "turret"
    translate([$d/2, $b-$d/2, $cb ]) {
      cylinder($ct, d=$d);
    }
    // spline
    translate([$d/2, $b-$d/2, $cb + $ct ]) {
      cylinder($a - $cb - $ct, d=$sd);
    }
  }
}

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
}

$vpt = [ 34.08, 24.46, 2.75 ];
$vpr = [ 67.60, 0.00, 40.40 ];
$vpd = 146.615;
demo();
