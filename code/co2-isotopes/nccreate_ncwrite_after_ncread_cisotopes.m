% nccreate_ncwrite_after_ncread_cisotopes.m
%
% PURPOSE
% -------
% Regenerate the CMIP7 c13 and c14 files on the 360x720 grid to help our streams
% infrastructure read the data without trouble.
%
% UPDATE: Turns out we only needed to do this to the c14 file.
%
% INSTRUCTIONS
% ------------
% Should work on derecho or casper:
% >>> module load matlab
% >>> matlab -nodesktop
% >>> nccreate_ncwrite_after_ncread_cisotopes.m
%
% NECESSARY STEP
% --------------
% I didn't figure out how to make time unlimited in matlab, so invoke these
% lines after matab generates the new files:
% >>> ncks -O --mk_rec_dmn time ctsmforc.Graven.atm_delta_C13_CMIP7_360x720_1700-2023_yearly_v3.0_c251117_timelimited.nc ctsmforc.Graven.atm_delta_C13_CMIP7_360x720_1700-2023_yearly_v3.0_c251117.nc
% >>> ncks -O --mk_rec_dmn time ctsmforc.Graven.atm_delta_C14_CMIP7_360x720_1700-2023_yearly_v3.0_c251117_timelimited.nc ctsmforc.Graven.atm_delta_C14_CMIP7_360x720_1700-2023_yearly_v3.0_c251117.nc
%
% slevis created 2025/11/17

 clear  % clears matlab's workspace

% get the constants
 [ndpm, mw31d, mw30d, mw28d, days_yr, hours_day, seconds_day, jan_start_day_of_year, jan_end_day_of_year, jul_start_day_of_year, jul_end_day_of_year, earth_radius_m, m2_km2] = f_constants();

% path to files containing the data
 path = '/glade/campaign/cesm/cesmdata/cseg/inputdata/lnd/clm2/isotopes/';

% read the data
 file = strcat(path, 'ctsmforc.Graven.atm_delta_C13_CMIP7_global_1700-2023_yearly_v3.0_c251013.nc');
 c13_orig = ncread(file, 'delta13co2_in_air');

 file = strcat(path, 'ctsmforc.Graven.atm_delta_C14_CMIP7_4x1_global_1700-2023_yearly_v3.0_c251013.nc');
 c14_orig = ncread(file, 'Delta14co2_in_air');

% user-specified year range (just being lazy)
 year_beg = 1700; year_end = 2023; years = year_end - year_beg + 1;
 days = [days_yr/2:days_yr:years*days_yr-days_yr/2];
 day_bounds = [0:days_yr:(years-1)*days_yr; days_yr:days_yr:years*days_yr];

% new 1d lat lon 720x360
 lat_degN(:) = [-89.75:0.5:89.75];
 lon_degE(:) = [0.25:0.5:359.75];

 rows = length(lat_degN);
 cols = length(lon_degE);

 lat_bnds(:,:) = [-90:0.5:89.5; -89.5:0.5:90];
 lon_bnds(:,:) = [0:0.5:359.5; 0.5:0.5:360];
 bound = 2;

% the new data
 delta13co2_in_air=zeros(720,360,324) + c13_orig;
 Delta14co2_in_air=zeros(720,360,324);
 Delta14co2_in_air(:,1:120,:) = Delta14co2_in_air(:,1:120,:) + c14_orig(:,1,:);  % -90 to -30 deg N
 Delta14co2_in_air(:,121:180,:) = Delta14co2_in_air(:,121:180,:) + c14_orig(:,2,:);  % -30 to 0 deg N
 Delta14co2_in_air(:,181:240,:) = Delta14co2_in_air(:,181:240,:) + c14_orig(:,3,:);  % 0 to 30 deg N
 Delta14co2_in_air(:,241:360,:) = Delta14co2_in_air(:,241:360,:) + c14_orig(:,4,:);  % 30 to 90 deg N

% output file name 1
% MAKE SURE THIS DIFFERS FROM THE FILES THAT WE READ ABOVE (risk of overwriting)
 file = '/glade/campaign/cesm/cesmdata/cseg/inputdata/lnd/clm2/isotopes/rawdata_copies/workspace/ctsmforc.Graven.atm_delta_C13_CMIP7_360x720_1700-2023_yearly_v3.0_c251117_timeunlimited.nc';

% nccreate and ncwrite file 1

 var_name = 'lat'; data = lat_degN;
 nccreate(file, var_name, 'Dimensions', {'lat', rows}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'standard_name', 'latitude')
 ncwriteatt(file, var_name, 'units', 'degrees_north')
 ncwriteatt(file, var_name, 'bounds', 'lat_bnds')

 var_name = 'lat_bnds'; data = lat_bnds;
 nccreate(file, var_name, 'Dimensions', {'bound', bound, 'lat', rows}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'standard_name', 'latitude')
 ncwriteatt(file, var_name, 'units', 'degrees_north')

 var_name = 'lon'; data = lon_degE;
 nccreate(file, var_name, 'Dimensions', {'lon', cols}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'standard_name', 'longitude')
 ncwriteatt(file, var_name, 'units', 'degrees_east')
 ncwriteatt(file, var_name, 'bounds', 'lon_bnds')

 var_name = 'lon_bnds'; data = lon_bnds;
 nccreate(file, var_name, 'Dimensions', {'bound', bound, 'lon', cols}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'standard_name', 'longitude')
 ncwriteatt(file, var_name, 'units', 'degrees_east')

 var_name = 'time'; data = days;
 nccreate(file, var_name, 'Dimensions', {'time', years}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'bounds', 'time_bnds')
 ncwriteatt(file, var_name, 'realtopology', 'linear')
 ncwriteatt(file, var_name, 'units', 'days since 1700-01-01 00:00:00')
 ncwriteatt(file, var_name, 'long_name', 'time')
 ncwriteatt(file, var_name, 'standard_name', 'time')
 ncwriteatt(file, var_name, 'axis', 'T')
 ncwriteatt(file, var_name, 'calendar', 'noleap')

 var_name = 'time_bnds'; data = day_bounds;
 nccreate(file, var_name, 'Dimensions', {'bound', bound, 'time', years}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'calendar', 'noleap')
 ncwriteatt(file, var_name, 'realtopology', 'linear')
 ncwriteatt(file, var_name, 'units', 'days since 1700-01-01 00:00:00')
 ncwriteatt(file, var_name, 'long_name', 'time bounds')
 ncwriteatt(file, var_name, 'axis', 'T')

 var_name = 'delta13co2_in_air'; data = delta13co2_in_air;
 nccreate(file, var_name, 'Dimensions', {'lon', cols, 'lat', rows, 'time', years}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'FillValue', '1.e20')
 ncwriteatt(file, var_name, 'info', 'delta13C in atmospheric CO2. Units are per mil, relative to VPDB')
 ncwriteatt(file, var_name, 'long_name', 'delta13C in atmospheric CO2')
 ncwriteatt(file, var_name, 'missing_value', '1.e20')
 ncwriteatt(file, var_name, 'units', '1')
 ncwriteatt(file, var_name, 'name', 'delta13co2_in_air')

% output file name 2
% MAKE SURE THIS DIFFERS FROM THE FILES THAT WE READ ABOVE (risk of overwriting)
 file = '/glade/campaign/cesm/cesmdata/cseg/inputdata/lnd/clm2/isotopes/rawdata_copies/workspace/ctsmforc.Graven.atm_delta_C14_CMIP7_360x720_1700-2023_yearly_v3.0_c251117_timeunlimited.nc';

% nccreate and ncwrite file 2

 var_name = 'lat'; data = lat_degN;
 nccreate(file, var_name, 'Dimensions', {'lat', rows}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'standard_name', 'latitude')
 ncwriteatt(file, var_name, 'units', 'degrees_north')
 ncwriteatt(file, var_name, 'bounds', 'lat_bnds')
 ncwriteatt(file, var_name, 'info', 'The data are reported for four zonal bands: 1: Southern Extratropics; 2: Southern Tropics; 3: Northern Tropics; 4: Northern Extratropics')
 ncwriteatt(file, var_name, 'description', 'Latitude is positive northward; its units of degree_north (or equivalent) indicate this explicitly. In a latitude-longitude system defined with respect to a rotated North Pole, the standard name of grid_latitude should be used instead of latitude. Grid latitude is positive in the grid-northward direction, but its units should be plain degree.')

 var_name = 'lat_bnds'; data = lat_bnds;
 nccreate(file, var_name, 'Dimensions', {'bound', bound, 'lat', rows}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'standard_name', 'latitude')
 ncwriteatt(file, var_name, 'units', 'degrees_north')

 var_name = 'lon'; data = lon_degE;
 nccreate(file, var_name, 'Dimensions', {'lon', cols}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'standard_name', 'longitude')
 ncwriteatt(file, var_name, 'units', 'degrees_east')
 ncwriteatt(file, var_name, 'bounds', 'lon_bnds')

 var_name = 'lon_bnds'; data = lon_bnds;
 nccreate(file, var_name, 'Dimensions', {'bound', bound, 'lon', cols}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'standard_name', 'longitude')
 ncwriteatt(file, var_name, 'units', 'degrees_east')

 var_name = 'time'; data = days;
 nccreate(file, var_name, 'Dimensions', {'time', years}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'bounds', 'time_bnds')
 ncwriteatt(file, var_name, 'realtopology', 'linear')
 ncwriteatt(file, var_name, 'units', 'days since 1700-01-01 00:00:00')
 ncwriteatt(file, var_name, 'long_name', 'time')
 ncwriteatt(file, var_name, 'standard_name', 'time')
 ncwriteatt(file, var_name, 'axis', 'T')
 ncwriteatt(file, var_name, 'calendar', 'noleap')

 var_name = 'time_bnds'; data = day_bounds;
 nccreate(file, var_name, 'Dimensions', {'bound', bound, 'time', years}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'calendar', 'noleap')
 ncwriteatt(file, var_name, 'realtopology', 'linear')
 ncwriteatt(file, var_name, 'units', 'days since 1700-01-01 00:00:00')
 ncwriteatt(file, var_name, 'long_name', 'time bounds')
 ncwriteatt(file, var_name, 'axis', 'T')

 var_name = 'Delta14co2_in_air'; data = Delta14co2_in_air;
 nccreate(file, var_name, 'Dimensions', {'lon', cols, 'lat', rows, 'time', years}, 'Format','classic');
 ncwrite(file, var_name, data)
 ncwriteatt(file, var_name, 'FillValue', '1.e20')
 ncwriteatt(file, var_name, 'info', 'Delta14C in atmospheric CO2. Units are per mil, relative to Modern standard. Corrections for mass-dependent fractionation and sample age have been applied, as in Delta notation in Stuiver and Polach, 1977.')
 ncwriteatt(file, var_name, 'long_name', 'Delta14C in atmospheric CO2')
 ncwriteatt(file, var_name, 'missing_value', '1.e20')
 ncwriteatt(file, var_name, 'units', '1')
 ncwriteatt(file, var_name, 'name', 'Delta14co2_in_air')

