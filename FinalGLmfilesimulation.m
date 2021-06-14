% GL NPV Evaluation
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
Yearstoabandonement = -(log(Initialoilrate)-log(Abandonementoilrate))/log(1-Rdecl)
%To calculate production decline factor
R = log(1-Rdecl);
%Starting loop to calculate costs and net present value up to the abandonement
%year
noofdaysperworkover=5;
noofworkoversperyear=2;
Abandonement_GOR=5000;
% Intialising some parameters
cummulative_NPV=0;
Cummulative_Oil_I =0;
Cummulative_gas_I=0;
Cummulative_wat_I=0;
GOR_I=InitialGOR;
Water_cut_I= Initialwatercut;
BOPD_year_zero=Initialoilrate/365.25; %correct up to this point 
for  iteration = 1:Yearstoabandonement
    I=iteration;
  Iless1 =(I)-1; 
%   %calculate daily prod at the end of each year
%   BOPD_year_I = BOPD_year_I* exp(R * I);%exponetial decline rate formula
%   %calculate max production for each year
%   Qmax_year_I = BOPD_year_I * 365.25;
%   %Adjusting for lost production during no working days 
  %calculate daily prod at the end of each year
  BOPD_year_I = BOPD_year_zero* exp(R * I); %exponetial decline rate formula
  BOPD_year_Iminus1= BOPD_year_zero* exp(R * Iless1);
  %calculate max production for each year
  Qmax_year_I = 365.25*(BOPD_year_I - BOPD_year_Iminus1)/R
  %Adjusting for lost production during no working days 
  Qoil_I = (Qmax_year_I)-(Qmax_year_I/365.25)* noofdaysperworkover* noofworkoversperyear
  %To Calculate cummulative oi  produced at the  end of each year
  Cummulative_Oil_I = Cummulative_Oil_I + Qoil_I;
% Calculating straight line WC and GOR
Water_cut_I= Water_cut_I + (I * (Abandonementwatercut - Initialwatercut))/Yearstoabandonement
GOR_I= GOR_I +I *(Abandonement_GOR - InitialGOR)/Yearstoabandonement;
%Calculating Water and Gas rates for rate I 
Qwat_I=Qoil_I*( Water_cut_I)/(1- (Water_cut_I));
Qgas_I= 0.001*Qoil_I*GOR_I;
%To calc cumm gas and water produced at the end of each year
 Cummulative_gas_I = Cummulative_gas_I + Qgas_I;
 Cummulative_wat_I = Cummulative_wat_I + Qwat_I;
%Calculating Recquired Cost and Revenue Factors
Inflationrate=3;
Discountrate=8;
Oilpriceincreaserate=1;
Eqpcostincreaserate=0.5;
ElectcostperKwhr=0.05;
ElectcostinkWperliquidprod=24;
Rinflation=(1+Inflationrate/100)^(I -0.5);
Rdiscount=(1+ Discountrate/100)^(I-0.5);
Roil=(1+Oilpriceincreaserate/100)^(I-0.5);
Requip=(1+Eqpcostincreaserate/100)^(I-0.5);
Relec= ElectcostperKwhr*ElectcostinkWperliquidprod;
%Calculating Fluid Cost
fluiddisposalcostperbbl=0.15;
Fluidcost_I= Rinflation*fluiddisposalcostperbbl*(Qoil_I+Qwat_I);
%calculating Fixed Operating Cost;
commonfixedcostpermonth=10000;
glmethodfixedcostpermonth=16000;
Fixedcost_I=Rinflation*12*(commonfixedcostpermonth+glmethodfixedcostpermonth);
%Calculating Workovercost
Workovercostperday=1000;     
Workovercost_I=Rinflation*Workovercostperday*noofdaysperworkover*noofworkoversperyear;
%Calculating Equipment cost throughout the whole life of the GL 
averagecostofcomponentreplacement=6563;
Equipmentcost_I=averagecostofcomponentreplacement*Requip;
%calculating Electricitycost
Electricitycost_I=Rinflation * Relec * (Qoil_I+Qwat_I);
%Calculating total cost for each year
Yearly_Cost_I=Fluidcost_I + Workovercost_I + Equipmentcost_I + Electricitycost_I;
%Calculating total income for each year
Royalty= 8;
Oilprice=45; %per barrel
Gasprice=5; %per Mscf
Yearly_Income_I= Roil * (1-Royalty/100)*(Qoil_I*Oilprice +Qgas_I*Gasprice);
%calculating NPV from the first year
Net_PV_I= (Yearly_Income_I - Yearly_Cost_I)/Rdiscount;
cummulative_NPV=cummulative_NPV+Net_PV_I;
% %Exporting Values to Excel Sheet
% Parameters(I,:)=[I Qwat_I Qgas_I Qoil_I Water_cut_I,Cummulative_wat_I, Cummulative_gas_I Cummulative_Oil_I, Yearly_Income_I,Yearly_Cost_I, Net_PV_I, cummulative_NPV]
% xlswrite('GasLiftNPVAnalysis.xlsx',Parameters,'Matlabgenvalues','A2')
end
