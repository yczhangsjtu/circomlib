pragma circom 2.0.0;

include "../../circuits/sha256/sha256_2.circom";
include "../../circuits/bitify.circom";
include "../../circuits/switcher.circom";

template Main(n, d) {
    signal input leaf;
    signal input path[n];
    signal input leaf_index;
    signal output root;

    signal bits[n];
    signal digests[n];

    component expand = Num2Bits(n);
    expand.in <== leaf_index;
    bits <== expand.out;

    component switchers[n];
    component sha256s[n];

    signal a[n], b[n];

    for(var i = 0; i < n; i++) {

      switchers[i] = Switcher();
      switchers[i].sel <== bits[i];
      if (i > 0) {
        switchers[i].L <== digests[i-1];
      } else {
        switchers[i].L <== leaf;
      }
      switchers[i].R <== path[i];
      a[i] <== switchers[i].outL;
      b[i] <== switchers[i].outR;

      sha256s[i] = Sha256_2();
      sha256s[i].a <== a[i];
      sha256s[i].b <== b[i];
      digests[i] <== sha256s[i].out;
    }

    component range_check = Num2Bits(d);
    range_check.in <== leaf;

    root <== digests[n-1];
}
