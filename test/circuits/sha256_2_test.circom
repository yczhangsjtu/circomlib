pragma circom 2.0.0;

include "../../circuits/sha256/sha256_2.circom";

template Main() {
    signal input a;
    signal input b;
    signal input switch;
    signal output out;

    component sha256_2 = Sha256_2();

    signal a0, a1, left;
    signal b0, b1, right;

    a0 <== a * (1 - switch);
    b0 <== b * (1 - switch);
    a1 <== a * switch;
    b1 <== b * switch;

    sha256_2.a <== a0 + b1;
    sha256_2.b <== b0 + a1;
    out <== sha256_2.out;
}

component main{public[a, b, switch]} = Main();
