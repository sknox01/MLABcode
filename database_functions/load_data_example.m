% Load data example

siteID = 'DSM';
pth = '/Users/sara/Library/CloudStorage/OneDrive-UBC/UBC/database';
SecondStage = 'clean/SecondStage';
Year = 2022;

var = 'clean_tv';
if strcmp(siteID,'DSM')||strcmp(siteID,'RBM')
    tv=read_bor(fullfile(pth,num2str(Year),siteID,'Flux/clean',var),8,[],Year);
else
    tv=read_bor(fullfile(pth,num2str(Year),siteID,'Met/clean',var),8,[],Year);
end

var = 'FC';

FC=read_bor(fullfile(pth,num2str(Year),siteID,SecondStage,var),[],[],Year);

var = 'SC';

SC=read_bor(fullfile(pth,num2str(Year),siteID,'Flux/clean',var),[],[],Year);

var = 'NEE';

NEE=read_bor(fullfile(pth,num2str(Year),siteID,'clean/SecondStage',var),[],[],Year);

%NEE = sum([FC,SC],2,'omitnan');
%NEE(all(isnan(FC)&isnan(SC),2)) = NaN;

plot(tv, [FC, SC, NEE])


var = 'TA_1_1_1';

TA_1_1_1=read_bor(fullfile(pth,num2str(Year),siteID,SecondStage,var),[],[],Year);

var = 'T_SONIC';

T_SONIC=read_bor(fullfile(pth,num2str(Year),siteID,'Flux/clean',var),[],[],Year);

plot(tv, [TA_1_1_1, T_SONIC])

[data_out_neg1, flag] = calc_avg_trace(tv, [T_SONIC,TA_1_1_1], TA_1_1_1,-1);
[data_out14, flag] = calc_avg_trace(tv, [T_SONIC,TA_1_1_1], TA_1_1_1, 14);
[data_out0, flag] = calc_avg_trace(tv, [T_SONIC,TA_1_1_1]);

figure
 plot(tv, [TA_1_1_1, data_out_neg1,data_out14,data_out0,T_SONIC],'.-')
 hold on
 plot(tv, TA_1_1_1, 'k','LineWidth',2)
 plot(tv, data_out0, 'r','LineWidth',2)
legend('TA', 'data out neg1 ','data out14','data out0','T_SONIC')

[data_out_neg1, flag] = calc_avg_trace(tv, T_SONIC, TA_1_1_1,-1);
[data_out14, flag] = calc_avg_trace(tv, T_SONIC, TA_1_1_1, 14);
[data_out0, flag] = calc_avg_trace(tv, T_SONIC, TA_1_1_1, 0);

figure
 plot(tv, [TA_1_1_1, data_out_neg1,data_out14,data_out0,T_SONIC],'.-')
 hold on
 plot(tv, TA_1_1_1, 'k','LineWidth',2)
 plot(tv, data_out0, 'r','LineWidth',2)
legend('TA', 'data out neg1 ','data out14','data out0','T_SONIC')