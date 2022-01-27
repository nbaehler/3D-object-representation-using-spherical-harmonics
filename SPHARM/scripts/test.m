clear;

a = [1 0 0];
b = [-1 0 0];

lenA = sqrt(a * a');
lenB = sqrt(b * b');

theta = acos((a * b') / (lenA * lenB));

pi / 2
