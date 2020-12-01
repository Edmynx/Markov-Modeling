% ChadEdJasProChris
% ENGS 27; Final Project - Matlab
% November 18, 2020

%This script handles the collection of the data which we will use to inform
%our model in final_code.m (Note: some of the figures are best when viewed
%in full screen. Also note that distance between longitudes is not constant
%on a graph due to mercator projections.)
clear

% Note: distance between longitudes is not constant on a graph 

protest_data = readtable('US_BLM_Protests.xlsx'); % Read protest data into table form

num_events = height(protest_data(:,1)); % Count rows in data table

% Turn select table columns into column arrays of cell type
type_column = protest_data.EVENT_TYPE;
date_column = protest_data.EVENT_DATE;
county_column = protest_data.ADMIN2;
state_column = protest_data.ADMIN1;
lat_column = protest_data.LATITUDE;
lon_column = protest_data.LONGITUDE;
actor_column = protest_data.ASSOC_ACTOR_1;

% Find duration of protest data in days
total_duration = days(date_column(num_events)-date_column(1));

% Turn dates into indexable integers
x = date_column(1);
y = 1;
for i=1:num_events
    if date_column(i)==x
        rel_date_column(i,1) = y;
    else
        x = x+1;
        y = y+1;
        rel_date_column(i,1) = y;
    end
end

% Count # of protests and # of BLM riots via for loop
num_protests = 0;
num_protests_blm = 0;
for i=1:num_events
    if type_column(i) == "Protests"
        num_protests = num_protests+1;
        if actor_column(i) == "BLM: Black Lives Matter"
            num_protests_blm = num_protests_blm+1;
        end
    end
end

% Define how many regions and time steps we want
num_regions = 49; % Number of box regions
num_times = total_duration; % Number of time steps

% Creating mesh grid over the US excluding AL AND HI
max_lon = -66; % East coast
min_lon = -125; % West coast
max_lat = 49; % 49th parallel
min_lat = 24; % Southern tip of florida
num_region_rows = sqrt(num_regions);
num_region_cols = sqrt(num_regions);
region_row_lines = flip(linspace(min_lat,max_lat,num_region_rows+1));
region_row_lines_2 = linspace(min_lat,max_lat,num_region_rows+1);
region_col_lines = linspace(min_lon,max_lon,num_region_cols+1);

% Convert event type and actor data to cateegorical form
protest_data.EVENT_TYPE = categorical(protest_data.EVENT_TYPE);
protest_data.ASSOC_ACTOR_1 = categorical(protest_data.ASSOC_ACTOR_1);

% Extract BLM data and create a condensed table
BLM_table = protest_data(((protest_data.EVENT_TYPE == 'Protests') & ...
                          (protest_data.ASSOC_ACTOR_1 == 'BLM: Black Lives Matter')),:);
BLM_rel_date_column = rel_date_column(((protest_data.EVENT_TYPE == 'Protests') & ...
                                       (protest_data.ASSOC_ACTOR_1 == 'BLM: Black Lives Matter')));

% Store geographic coordinates of BLM data                    
geo_coordinates = zeros(num_protests_blm,2); %Initialize geocoordinates matrix                     
geo_coordinates(:,1) = BLM_table.LATITUDE; %Store latitude in the first column
geo_coordinates(:,2) = BLM_table.LONGITUDE; %Store longitude in the second column    

% Populate the 3D matrix protests_per_region
protests_per_region = zeros(num_region_rows, num_region_cols, num_times); 
for i=1:num_times
   [protests_per_region(:,:,i),Xedges,Yedges] = histcounts2(geo_coordinates((BLM_rel_date_column == i),1),...
                                                         geo_coordinates((BLM_rel_date_column == i),2),...
                                                         region_row_lines_2,...
                                                         region_col_lines);
end

% For the histogram to work, the data had to be flipped
% We flip it back to get the actual matrix representation 
for i = 1:num_times
    protests_per_region(:, :, i) = flipud(protests_per_region(:, :, i));
end
        
% Visualize the 3D matrix with a daily heat map by plotting the first 21
% days, just to provide an example of temporal progression.
figure(1);
    x_labels = {'c1','c2', 'c3', 'c4', 'c5', 'c6', 'c7'};
    y_labels = {'r1','r2', 'r3', 'r4', 'r5', 'r6', 'r7'};
    for count = 3:23
        x = count - 2;
        subplot(5, 5, x);
        heatmap(x_labels, y_labels, protests_per_region(:, :, count));
        colormap autumn
        title('Day' + string(x));
    end   
    sgtitle('Number of Protests in Each Region by Day') 

% Visualize the geospatial density of proteests with a scatter plot
figure(2)
     geoscatter(geo_coordinates(:,1),geo_coordinates(:,2),'filled','MarkerFaceColor',[0.6350, 0.0780, 0.1840]);
     hold on
     for n = 1:(num_region_cols+1)
         geoplot([min_lat max_lat], [region_col_lines(n) region_col_lines(n)],'-k','LineWidth',1)
         geoplot([region_row_lines_2(n) region_row_lines_2(n)], [min_lon max_lon],'-k','LineWidth',1)
     end
     title('All Protests over a Span of 164 Days');
     geolimits([min_lat max_lat],[min_lon max_lon])
     geobasemap streets-dark
     hold off
