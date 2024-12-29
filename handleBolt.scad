include <BOSL2/std.scad>;
include <BOSL2/screws.scad>;

/*
MIT NON-AI License

Copyright 2024, Hugh Kern

Permission is hereby granted, free of charge, to any person obtaining a copy of the software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions.

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

In addition, the following restrictions apply:

1. The Software and any modifications made to it may not be used for the purpose of training or improving machine learning algorithms,
including but not limited to artificial intelligence, natural language processing, or data mining. This condition applies to any derivatives,
modifications, or updates based on the Software code. Any usage of the Software in an AI-training dataset is considered a breach of this License.

2. The Software may not be included in any dataset used for training or improving machine learning algorithms,
including but not limited to artificial intelligence, natural language processing, or data mining.

3. Any person or organization found to be in violation of these restrictions will be subject to legal action and may be held liable
for any damages resulting from such use.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

$fn=90;

handle_spec = "1/4"; // [ #6, #8, #10, #12, 1/4, M3, M4, M5, M6, M7, M8 ]
bolt_info = screw_info(handle_spec, "hex");
echo(bolt_info);
echo(is_struct(bolt_info));
bolt_info_od = struct_val(bolt_info,"diameter");
bolt_info_head_size = struct_val(bolt_info,"head_size");
bolt_info_head_height = struct_val(bolt_info,"head_height");
handle_end_od = bolt_info_head_size;
handle_end_ht = bolt_info_head_size;
handle_len = 0;
handle_base_od = bolt_info_head_size * 2.2;
handle_base_ht = bolt_info_head_height+1;
handle_base_depth = bolt_info_head_height*2;
handle_base_total_height = handle_base_depth + handle_base_ht;
handle_lobes = 2;
handle_lobe_degrees = 360/handle_lobes;

module handle_body() {
  len = handle_len ? handle_len : bolt_info_head_size * 1.8;
  for ( i=[0:handle_lobes - 1] ) {
    hull( ) {
      translate( [0, 0, -handle_base_depth] )
        cyl( l=handle_base_total_height, d=handle_base_od, chamfer1=2, rounding2=2, anchor=BOT );

      rotate( [0, 0, i * handle_lobe_degrees] )
        translate( [0, len, handle_base_ht - handle_end_ht] )
          cyl( l=handle_end_ht, d=handle_end_od, rounding=2, anchor=BOT );
    }
  }
}

module handle_cut() {
  screw_hole(handle_spec, thread=false, l=handle_base_depth, anchor="head_bot");
  hull() {
    screw_head( bolt_info );
    translate( [0, 0, handle_base_ht] )
      screw_head( bolt_info );
  }
}

difference() {
  handle_body();
  handle_cut();
}