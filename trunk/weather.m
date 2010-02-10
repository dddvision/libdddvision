% A colormap that looks like weather radar
function f = weather(row)

f = [0,0,0;
0,0.0714,0;
0,0.1429,0;
0,0.2143,0;
0,0.2857,0;
0,0.3571,0;
0,0.4286,0;
0,0.5000,0;
0,0.5714,0;
0,0.6429,0;
0,0.7143,0;
0,0.7857,0;
0,0.8571,0;
0,0.9286,0;
0,1,0;
0.0087,1,0;
0.0174,1,0;
0.0261,1,0;
0.0348,1,0;
0.0435,1,0;
0.0522,1,0;
0.0609,1,0;
0.0696,1,0;
0.0783,1,0;
0.0870,1,0;
0.0957,1,0;
0.1043,1,0;
0.1130,1,0;
0.1217,1,0;
0.1304,1,0;
0.1391,1,0;
0.1478,1,0;
0.1565,1,0;
0.1652,1,0;
0.1739,1,0;
0.1826,1,0;
0.1913,1,0;
0.2000,1,0;
0.2087,1,0;
0.2174,1,0;
0.2261,1,0;
0.2348,1,0;
0.2435,1,0;
0.2522,1,0;
0.2609,1,0;
0.2696,1,0;
0.2783,1,0;
0.2870,1,0;
0.2957,1,0;
0.3043,1,0;
0.3130,1,0;
0.3217,1,0;
0.3304,1,0;
0.3391,1,0;
0.3478,1,0;
0.3565,1,0;
0.3652,1,0;
0.3739,1,0;
0.3826,1,0;
0.3913,1,0;
0.4000,1,0;
0.4087,1,0;
0.4174,1,0;
0.4261,1,0;
0.4348,1,0;
0.4435,1,0;
0.4522,1,0;
0.4609,1,0;
0.4696,1,0;
0.4783,1,0;
0.4870,1,0;
0.4957,1,0;
0.5043,1,0;
0.5130,1,0;
0.5217,1,0;
0.5304,1,0;
0.5391,1,0;
0.5478,1,0;
0.5565,1,0;
0.5652,1,0;
0.5739,1,0;
0.5826,1,0;
0.5913,1,0;
0.6000,1,0;
0.6087,1,0;
0.6174,1,0;
0.6261,1,0;
0.6348,1,0;
0.6435,1,0;
0.6522,1,0;
0.6609,1,0;
0.6696,1,0;
0.6783,1,0;
0.6870,1,0;
0.6957,1,0;
0.7043,1,0;
0.7130,1,0;
0.7217,1,0;
0.7304,1,0;
0.7391,1,0;
0.7478,1,0;
0.7565,1,0;
0.7652,1,0;
0.7739,1,0;
0.7826,1,0;
0.7913,1,0;
0.8000,1,0;
0.8087,1,0;
0.8174,1,0;
0.8261,1,0;
0.8348,1,0;
0.8435,1,0;
0.8522,1,0;
0.8609,1,0;
0.8696,1,0;
0.8783,1,0;
0.8870,1,0;
0.8957,1,0;
0.9043,1,0;
0.9130,1,0;
0.9217,1,0;
0.9304,1,0;
0.9391,1,0;
0.9478,1,0;
0.9565,1,0;
0.9652,1,0;
0.9739,1,0;
0.9826,1,0;
0.9913,1,0;
1,1,0;
1,0.9912,0;
1,0.9823,0;
1,0.9735,0;
1,0.9646,0;
1,0.9558,0;
1,0.9469,0;
1,0.9381,0;
1,0.9292,0;
1,0.9204,0;
1,0.9115,0;
1,0.9027,0;
1,0.8938,0;
1,0.8850,0;
1,0.8761,0;
1,0.8673,0;
1,0.8584,0;
1,0.8496,0;
1,0.8407,0;
1,0.8319,0;
1,0.8230,0;
1,0.8142,0;
1,0.8053,0;
1,0.7965,0;
1,0.7876,0;
1,0.7788,0;
1,0.7699,0;
1,0.7611,0;
1,0.7522,0;
1,0.7434,0;
1,0.7345,0;
1,0.7257,0;
1,0.7168,0;
1,0.7080,0;
1,0.6991,0;
1,0.6903,0;
1,0.6814,0;
1,0.6726,0;
1,0.6637,0;
1,0.6549,0;
1,0.6460,0;
1,0.6372,0;
1,0.6283,0;
1,0.6195,0;
1,0.6106,0;
1,0.6018,0;
1,0.5929,0;
1,0.5841,0;
1,0.5752,0;
1,0.5664,0;
1,0.5575,0;
1,0.5487,0;
1,0.5398,0;
1,0.5310,0;
1,0.5221,0;
1,0.5133,0;
1,0.5044,0;
1,0.4956,0;
1,0.4867,0;
1,0.4779,0;
1,0.4690,0;
1,0.4602,0;
1,0.4513,0;
1,0.4425,0;
1,0.4336,0;
1,0.4248,0;
1,0.4159,0;
1,0.4071,0;
1,0.3982,0;
1,0.3894,0;
1,0.3805,0;
1,0.3717,0;
1,0.3628,0;
1,0.3540,0;
1,0.3451,0;
1,0.3363,0;
1,0.3274,0;
1,0.3186,0;
1,0.3097,0;
1,0.3009,0;
1,0.2920,0;
1,0.2832,0;
1,0.2743,0;
1,0.2655,0;
1,0.2566,0;
1,0.2478,0;
1,0.2389,0;
1,0.2301,0;
1,0.2212,0;
1,0.2124,0;
1,0.2035,0;
1,0.1947,0;
1,0.1858,0;
1,0.1770,0;
1,0.1681,0;
1,0.1593,0;
1,0.1504,0;
1,0.1416,0;
1,0.1327,0;
1,0.1239,0;
1,0.1150,0;
1,0.1062,0;
1,0.0973,0;
1,0.0885,0;
1,0.0796,0;
1,0.0708,0;
1,0.0619,0;
1,0.0531,0;
1,0.0442,0;
1,0.0354,0;
1,0.0265,0;
1,0.0177,0;
1,0.0088,0;
1,0,0;
1,0.0769,0.0769;
1,0.1538,0.1538;
1,0.2308,0.2308;
1,0.3077,0.3077;
1,0.3846,0.3846;
1,0.4615,0.4615;
1,0.5385,0.5385;
1,0.6154,0.6154;
1,0.6923,0.6923;
1,0.7692,0.7692;
1,0.8462,0.8462;
1,0.9231,0.9231;
1,1,1];

if( nargin==1 )
  f=f(row,:);
end

end

