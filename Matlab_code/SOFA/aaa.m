clc;
A = load('saveROC_stat_SOFA.mat');
B = load('saveROC_stat_d_SOFA.mat');
A = A.ROC_stat(:,:);
B = B.ROC_stat(:,:);

counterB_yes = 0;
counterB_bet = 0;
counterA_yes = 0;
counterA_bet = 0;
d = 1;
i = 0;
while(i<37590)
   i = i +1; 
   if B(i,1) == 1 && A(i,1) == 1
       C(d) = B(i,3) - A(i,3);
       if C(d) >= 0
           counterA_bet = counterA_bet + 1;
       else
           counterB_bet = counterB_bet + 1;
       end
       d = d +1;
   elseif B(i,1) == 1 && A(i,1) == 0
       counterB_yes = counterB_yes + 1;
   elseif B(i,1) == 0 && A(i,1) == 1
       counterA_yes = counterA_yes + 1;       
   end
end

counterB_yes
counterB_bet
counterA_yes
counterA_bet


greater = (C > 0).*C;
lower = (C < 0).*C;

low = 15 *sum(lower)/(sum(C<0))
gr = 15 *sum(greater)/(sum(C>0))



FP = B(end , 4)
FN = B(end , 6)
TP = B(end , 5)
TN = B(end , 7)
FP = A(end , 4)
FN = A(end , 6)
TP = A(end , 5)
TN = A(end , 7)
