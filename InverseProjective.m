function Pinv=InverseProjective(P)
% Public Domain

den=P(2)*P(4)-P(1)*P(5);

Pinv=[[     -P(5)+P(8)*P(6),     P(4)-P(7)*P(6),-P(4)*P(8)+P(7)*P(5)]
      [      P(2)-P(8)*P(3),    -P(1)+P(7)*P(3), P(1)*P(8)-P(7)*P(2)]
      [-P(2)*P(6)+P(5)*P(3),P(1)*P(6)-P(4)*P(3),                   0]]/den; 

Pinv(9)=1;
    
end
