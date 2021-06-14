%GL NPV Evaluation
clc
clear all
Initialprodrate= 1531; %total prod
Initialwatercut= 0.56;
InitialGOR=446;
Oilproddeclinerate=12;
Totalabandonmentrate=1635;
Abandonementwatercut=0.95;
Abandonementoilrate= 365.25 * Totalabandonmentrate * (1-Abandonementwatercut);
Initialoilrate=   365.25 *Initialprodrate *(1- Initialwatercut); %Barrel/Yr
Rdecl= Oilproddeclinerate/100;
Yearstoabandonement = -(log(Initialoilrate)-log(Abandonementoilrate))/log(1-Rdecl);
%Initialising at Year 0
BOPD_yearzero = Initialoilrate/365.25;
Watercut_yearzero=Initialwatercut;
GOR_yearzero= InitialGOR;
Cummulative_NPV_yearzero= 0;
Cummulative_Oil_yearzero=0;
%To calculate production decline factor
R = log(1-Rdecl);
%Starting loop to calculate costs and net present value up to the abandonement
%year
noofdaysperworkover=7;
noofworkoversperyear=3;
Abandonement_GOR=5000;
% OGinitialwatercut=0.56;
% OGAbandonementwatercut=0.95;
for I = 1:Yearstoabandonement
  Iless1 =I-1; 
  %calculate daily prod at the end of each year
  BOPD_year_I = BOPD_yearzero* exp(R * I); %exponetial decline rate formula
  BOPD_year_Iminus1= BOPD_yearzero* exp(R * Iless1);
  %calculate max production for each year
  Qmax_year_I = 365.25*(BOPD_year_I - BOPD_year_Iminus1/R);
  %Adjusting for lost production during no working days 
%   Qoil_I = Qmax_year_I-(Qmax_year_I/365.25)* noofdaysperworkover* noofworkoversperyear;
%   %To Calculate cummulative oil produced to end of each year
%   Cummulative_Oil_Iless1= Cummulative_Oil_yearzero + Qoil_I
%   Cummulative_Oil_I= cumsum(Cummulative_Oil_Iless1+ Qoil_I)
%    Cummulative_Oil_I= cumsum(Cummulative_Oil_Iless1,Cummulative_Oil_I)
end 

