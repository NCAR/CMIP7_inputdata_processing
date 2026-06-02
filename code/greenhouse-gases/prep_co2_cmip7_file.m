% prep_co2_cmip7_file.m
%
% - before running this matlab script, I renamed the cmip6 co2 file (fco2_datm_global_simyr_1750-2014_CMIP6_c180929.nc) to the name of the cmip7 co2 file (used below)
% - here, extend time variables in the file from 2014 (cmip6) to 2022 (cmip7)
% - and bring in cmip7 co2 to the file
% - after running the matlab script, I used some xarray to append the global attributes from the failing cmip7 co2 file to this new one that works
%
% More information appears in the issue github.com/ESCOMP/CTSM/issues/4072
%
% slevis 2026/06/01

clear

% get cmip6 time, time_bnds, date
time_cmip6 = ncread('fco2_datm_global_simyr_1750-2014_CMIP6_c180929.nc', 'time');
time_bnds_cmip6 = ncread('fco2_datm_global_simyr_1750-2014_CMIP6_c180929.nc', 'time_bnds');
date_cmip6 = ncread('fco2_datm_global_simyr_1750-2014_CMIP6_c180929.nc', 'date');

% extend time
time_cmip7 = time_cmip6;  % goes to 2014
time_cmip7(end+1) = time_cmip7(end) + 365;  % to 2015
time_cmip7(end+1) = time_cmip7(end) + 365.5;  % to 2016 (leap yr)
time_cmip7(end+1) = time_cmip7(end) + 365.5;  % to 2017
time_cmip7(end+1) = time_cmip7(end) + 365;  % to 2018
time_cmip7(end+1) = time_cmip7(end) + 365;  % to 2019
time_cmip7(end+1) = time_cmip7(end) + 365.5;  % to 2020 (leap yr)
time_cmip7(end+1) = time_cmip7(end) + 365.5;  % to 2021
time_cmip7(end+1) = time_cmip7(end) + 365;  % to 2022

% extend time_bnds
time_bnds_cmip7 = time_bnds_cmip6;  % goes to 2014
date_cmip7 = date_cmip6;  % goes to 2014
for yr = 1:8
  time_bnds_cmip7(:,end+1) = time_bnds_cmip7(:,end);
  date_cmip7(end+1) = date_cmip7(end) + 1e4;
end

% get cmip7 co2
co2_cmip7(1,1,:) = ncread('co2_input4MIPs_GHGConcentrations_CMIP_CR-CMIP-1-0-0_gm_1750-2022_CMIP7_c20250228.nc','co2');

% write modified time, time_bnds, and co2 to renamed copy of the cmip6 file
ncwrite('co2_input4MIPs_GHGConcentrations_CMIP_CR-CMIP-1-0-0_gm_1750-2022_CMIP7_c20260601.nc', 'time', time_cmip7);
ncwrite('co2_input4MIPs_GHGConcentrations_CMIP_CR-CMIP-1-0-0_gm_1750-2022_CMIP7_c20260601.nc', 'time_bnds', time_bnds_cmip7);
ncwrite('co2_input4MIPs_GHGConcentrations_CMIP_CR-CMIP-1-0-0_gm_1750-2022_CMIP7_c20260601.nc', 'date', date_cmip7);
ncwrite('co2_input4MIPs_GHGConcentrations_CMIP_CR-CMIP-1-0-0_gm_1750-2022_CMIP7_c20260601.nc', 'CO2', co2_cmip7);

