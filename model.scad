// model of and supporting models for a (micro) servo
// author: Christophe VG <contact@christophe.vg>

$fn = 50;

// examples:
// KY66 SG90 Micro Servo Motor        : 23   x 12.2 x 29   mm
// KY61 MG90S Metal Micro Servo Motor : 22.8 x 12.2 x 28.5 mm
// Tower Pro SG90 Digital             : 23   × 12.2 x 29   mm

// see image drawing dimensions for information
// about measurements a through f to configure the modules

// Tower Pro SG90 Digital
$a = 34.5;
$b = 22.8;
$c = 26.7;
$d = 12.6;
$e = 32.5;
$f = 16.0;

// wings - to check
$wt = 2.0;         // thinkness
$wd = 2.0;         // diameter of screw holes
$wc = ($e - $b)/4; // distance from wing border (for now centered in wing)

// spline - to check
$sd = 5.0;         // diameter
$sc = 15.0;        // distance from side

function servo_top() = $a;

// servo - the 3d model of the servo
// centered around vertical axis through middle of spline and leveled around the mounting wings
// be default top-mounted, bottom-mounted via "bottom" parameter/flag
module servo(mounted=true,bottom=false) {
  translate([-$d/2, -$sc, (mounted ? -$f + (bottom ? -$wt : 0) : 0) ]) {
    // main body
    cube( [$d, $b, $c] );
    // wings
    translate([0, -($e - $b)/2, $f]) {
      difference() {
        cube( [$d, $e, $wt] );
        // screw holes
        translate([$d/2, $wc, 0])    { cylinder( $a - $c, d=$wd ); }
        translate([$d/2, $e-$wc, 0]) { cylinder( $a - $c, d=$wd ); } 
      }
    }
    // spline
    translate([$d/2, $sc, $c ]) {
      cylinder($a - $c, d=$sd);
    }
  }
}

// servo_mount - the cutout that can hold the servo
// centered around vertical axis through middle of spline
module servo_mount(t=$a) {
  translate([-$d/2, -$sc, 0]) {
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
    translate([25, 25, 0]) { servo_mount(t=10); }
    translate([50, 25, 0]) { servo_mount(t=10); }
  }
  translate([25, 25, 5]) { color("red") { servo(); } }
}

$vpt = [ 34.08, 24.46, 2.75 ];
$vpr = [ 67.60, 0.00, 40.40 ];
demo();
