% script_test_fcn_HandTrace_traceEachCategory
% This is a script to exercise the function:
% fcn_HandTrace_traceEachCategory.m
%
% This script was written on 2026_03_08 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% As: script_test_fcn_HandTrace_traceEachCategory
%
% 2026_03_08 by Sean Brennan, sbrennan@psu.edu
% - wrote the code originally using fcn_GetUserInputPath_getUserInputPath
%   % as a starter


% TO-DO:
%
% 2026_02_12 by Sean Brennan, sbrennan@psu.edu
% - (fill in items here)


%% Set up the workspace
close all

%% Code demos start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____                              ____   __    _____          _
%  |  __ \                            / __ \ / _|  / ____|        | |
%  | |  | | ___ _ __ ___   ___  ___  | |  | | |_  | |     ___   __| | ___
%  | |  | |/ _ \ '_ ` _ \ / _ \/ __| | |  | |  _| | |    / _ \ / _` |/ _ \
%  | |__| |  __/ | | | | | (_) \__ \ | |__| | |   | |___| (_) | (_| |  __/
%  |_____/ \___|_| |_| |_|\___/|___/  \____/|_|    \_____\___/ \__,_|\___|
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Demos%20Of%20Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 1

close all;
fprintf(1,'Figure: 1XXXXXX: DEMO cases - all are interactive so commented out\n');

if 1==0
	%% DEMO case: basic example
	figNum = 10001;
	titleString = sprintf('DEMO case: basic example ');
	fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
	figure(figNum); clf;

	categoryData = [];
	userFilledCategoryData = fcn_HandTrace_traceEachCategory((categoryData),(figNum));

	% sgtitle(titleString, 'Interpreter','none');

	% Check variable types
	assert(iscell(userFilledCategoryData));

	% % Check variable sizes
	% assert(size(userFilledCategoryData,1)>=1);
	% assert(size(userFilledCategoryData,2)==2);

	% Check variable values
	% User defined

	% % Make sure plot opened up
	% assert(isequal(get(gcf,'Number'),figNum));


	%% DEMO case: starting with initial points
	figNum = 10002;
	titleString = sprintf('DEMO case: starting with initial points');
	fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
	figure(figNum); clf;

	categoryData = rand(10,2);
	userFilledCategoryData = fcn_HandTrace_traceEachCategory((categoryData),(figNum));

	% sgtitle(titleString, 'Interpreter','none');

	% Check variable types
	assert(isnumeric(userFilledCategoryData));

	% Check variable sizes
	assert(size(userFilledCategoryData,1)>=1);
	assert(size(userFilledCategoryData,2)==2);

	% Check variable values
	% User defined

	% % Make sure plot opened up
	% assert(isequal(get(gcf,'Number'),figNum));

	%% DEMO case: hello world
	figNum = 10003;
	titleString = sprintf('DEMO case: hello world');
	fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
	figure(figNum); clf;

	categoryData = [
		0.1743    0.8815
		0.1752    0.7835
		NaN       NaN
		0.1734    0.8346
		0.2113    0.8346
		NaN       NaN
		0.2095    0.8758
		0.2149    0.7878
		NaN       NaN
		0.2374    0.8772
		0.2392    0.7878
		NaN       NaN
		0.2401    0.7878
		0.2716    0.7878
		NaN       NaN
		0.2383    0.8275
		0.2707    0.8289
		NaN       NaN
		0.2401    0.8715
		0.2698    0.8729
		NaN       NaN
		0.2914    0.8715
		0.2941    0.7864
		0.3356    0.7835
		NaN       NaN
		0.3536    0.8616
		0.3599    0.7920
		0.3959    0.7935
		NaN       NaN
		0.4419    0.8758
		0.4221    0.8573
		0.4167    0.8289
		0.4194    0.8105
		0.4329    0.7935
		0.4500    0.7906
		0.4608    0.7991
		0.4626    0.8261
		0.4590    0.8616
		0.4536    0.8744
		0.4455    0.8758
		NaN       NaN
		0.1761    0.7083
		0.2032    0.6118
		0.2248    0.6529
		0.2455    0.6259
		0.2689    0.7154
		NaN       NaN
		0.3122    0.6941
		0.2986    0.6728
		0.2941    0.6245
		0.3050    0.6004
		0.3365    0.6103
		0.3491    0.6316
		0.3464    0.6756
		0.3266    0.6955
		0.3131    0.6955
		NaN       NaN
		0.3752    0.7040
		0.3806    0.6047
		NaN       NaN
		0.3752    0.6998
		0.4032    0.6969
		0.4113    0.6728
		0.3788    0.6558
		0.4221    0.6174
		NaN       NaN
		0.4419    0.7083
		0.4500    0.6132
		0.4959    0.6118
		NaN       NaN
		0.5077    0.7182
		0.5194    0.6146
		0.5392    0.6203
		0.5527    0.6259
		0.5581    0.6444
		0.5590    0.6643
		0.5545    0.6813
		0.5509    0.6983
		0.5437    0.7182
		0.5401    0.7225
		0.5302    0.7253
		0.5194    0.7253
		0.5104    0.7253
		NaN       NaN
		];
	userFilledCategoryData = fcn_HandTrace_traceEachCategory((categoryData),(figNum));

	% sgtitle(titleString, 'Interpreter','none');

	% Check variable types
	assert(isnumeric(userFilledCategoryData));

	% Check variable sizes
	assert(size(userFilledCategoryData,1)>=1);
	assert(size(userFilledCategoryData,2)==2);

	% Check variable values
	% User defined

	% % Make sure plot opened up
	% assert(isequal(get(gcf,'Number'),figNum));


	%% DEMO case: testing with geoplot
	figNum = 10004;
	titleString = sprintf('DEMO case: testing with geoplot');
	fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
	figure(figNum); clf;

	fcn_plotRoad_plotLL([],[],(figNum));
	set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

	categoryData = [];
	userFilledCategoryData = fcn_HandTrace_traceEachCategory((categoryData),(figNum));

	% sgtitle(titleString, 'Interpreter','none');

	% Check variable types
	assert(isnumeric(userFilledCategoryData));

	% Check variable sizes
	assert(size(userFilledCategoryData,1)>=1);
	assert(size(userFilledCategoryData,2)==2);

	% Check variable values
	% User defined

	% % Make sure plot opened up
	% assert(isequal(get(gcf,'Number'),figNum));

	%% DEMO case: testing with geoplot with previous data
	figNum = 10005;
	titleString = sprintf('DEMO case: testing with geoplot with previous data');
	fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
	figure(figNum); clf;

	LLAdata = [
		40.380301927069773 -79.884128796856004
		40.378814453783740 -79.886003667041678
		40.378669382578792 -79.886219585568057
		40.378433386792231 -79.886604483810743
		40.378353699381059 -79.886780169071329
		40.378136091096778 -79.887313930397440
		40.377928699370855 -79.887838973249472
		40.377836751959194 -79.888072325433768
		40.377773410098470 -79.888193024839410
		40.377716198258547 -79.888294948781976
		40.377520043009973 -79.888603402818688
		40.377489393700806 -79.888643635953898
		40.377448524718410 -79.888706667865804
		40.376353312922461 -79.887279732669882
		40.376189846948471 -79.886737926448873
		40.377142030673902 -79.885364635433248
		40.376524951424727 -79.884527767603231
		40.377505743164747 -79.883186643311959
		40.378204549077431 -79.883926938612660
		40.379258892424218 -79.883980584788716
		40.380010826978442 -79.883723056518534
		40.380301927069773 -79.884128796856004];

	plotFormat.Marker = 'none';
	plotFormat.MarkerSize = 10;
	plotFormat.LineStyle = '-';
	plotFormat.LineWidth = 3;
	plotFormat.Color = [1 0 0];


	fcn_plotRoad_plotLL([],[],figNum);
	set(gca,'MapCenter',[40.378155494697360 -79.884093253372299],'ZoomLevel',17);

	categoryData = LLAdata;
	userFilledCategoryData = fcn_HandTrace_traceEachCategory((categoryData),(figNum));

	% sgtitle(titleString, 'Interpreter','none');

	% Check variable types
	assert(isnumeric(userFilledCategoryData));

	% Check variable sizes
	assert(size(userFilledCategoryData,1)>=1);
	assert(size(userFilledCategoryData,2)==2);

	% Check variable values
	% User defined
	% 
	% % Make sure plot opened up
	% assert(isequal(get(gcf,'Number'),figNum));

end

%% Test cases start here. These are very simple, usually trivial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _______ ______  _____ _______ _____
% |__   __|  ____|/ ____|__   __/ ____|
%    | |  | |__  | (___    | | | (___
%    | |  |  __|  \___ \   | |  \___ \
%    | |  | |____ ____) |  | |  ____) |
%    |_|  |______|_____/   |_| |_____/
%
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=TESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 2

close all;
fprintf(1,'Figure: 2XXXXXX: TEST mode cases\n');

%% TEST case: This one returns nothing since there is no portion of the path in criteria
figNum = 20001;
titleString = sprintf('TEST case: This one returns nothing since there is no portion of the path in criteria');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

%% Fast Mode Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ______        _     __  __           _        _______        _
% |  ____|      | |   |  \/  |         | |      |__   __|      | |
% | |__ __ _ ___| |_  | \  / | ___   __| | ___     | | ___  ___| |_ ___
% |  __/ _` / __| __| | |\/| |/ _ \ / _` |/ _ \    | |/ _ \/ __| __/ __|
% | | | (_| \__ \ |_  | |  | | (_) | (_| |  __/    | |  __/\__ \ |_\__ \
% |_|  \__,_|___/\__| |_|  |_|\___/ \__,_|\___|    |_|\___||___/\__|___/
%
%
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Fast%20Mode%20Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 8

close all;
fprintf(1,'Figure: 8XXXXXX: FAST mode cases - none because this is a plotting function\n');

% %% Basic example - NO FIGURE
% figNum = 80001;
% fprintf(1,'Figure: %.0f: FAST mode, empty figNum\n',figNum);
% figure(figNum); close(figNum);
%
% dataSetNumber = 9;
%
% % Load some test data
% tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);
%
% start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
% end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
% excursion_definition = []; % empty
%
% [cell_array_of_lap_indices, ...
%     cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%     fcn_Laps_breakDataIntoLapIndices(...
%     tempXYdata,...
%     start_definition,...
%     end_definition,...
%     excursion_definition,...
%     ([]));
%
% % Check variable types
% assert(iscell(cell_array_of_lap_indices));
% assert(iscell(cell_array_of_entry_indices));
% assert(iscell(cell_array_of_exit_indices));
%
% % Check variable sizes
% Nlaps = 3;
% assert(isequal(Nlaps,length(cell_array_of_lap_indices)));
% assert(isequal(Nlaps,length(cell_array_of_entry_indices)));
% assert(isequal(Nlaps,length(cell_array_of_exit_indices)));
%
% % Check variable values
% % Are the laps starting at expected points?
% assert(isequal(2,min(cell_array_of_lap_indices{1})));
% assert(isequal(102,min(cell_array_of_lap_indices{2})));
% assert(isequal(215,min(cell_array_of_lap_indices{3})));
%
% % Are the laps ending at expected points?
% assert(isequal(88,max(cell_array_of_lap_indices{1})));
% assert(isequal(199,max(cell_array_of_lap_indices{2})));
% assert(isequal(293,max(cell_array_of_lap_indices{3})));
%
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
%
%
% %% Basic fast mode - NO FIGURE, FAST MODE
% figNum = 80002;
% fprintf(1,'Figure: %.0f: FAST mode, figNum=-1\n',figNum);
% figure(figNum); close(figNum);
%
% dataSetNumber = 9;
%
% % Load some test data
% tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);
%
% start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
% end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
% excursion_definition = []; % empty
%
% [cell_array_of_lap_indices, ...
%     cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%     fcn_Laps_breakDataIntoLapIndices(...
%     tempXYdata,...
%     start_definition,...
%     end_definition,...
%     excursion_definition,...
%     (-1));
%
% % Check variable types
% assert(iscell(cell_array_of_lap_indices));
% assert(iscell(cell_array_of_entry_indices));
% assert(iscell(cell_array_of_exit_indices));
%
% % Check variable sizes
% Nlaps = 3;
% assert(isequal(Nlaps,length(cell_array_of_lap_indices)));
% assert(isequal(Nlaps,length(cell_array_of_entry_indices)));
% assert(isequal(Nlaps,length(cell_array_of_exit_indices)));
%
% % Check variable values
% % Are the laps starting at expected points?
% assert(isequal(2,min(cell_array_of_lap_indices{1})));
% assert(isequal(102,min(cell_array_of_lap_indices{2})));
% assert(isequal(215,min(cell_array_of_lap_indices{3})));
%
% % Are the laps ending at expected points?
% assert(isequal(88,max(cell_array_of_lap_indices{1})));
% assert(isequal(199,max(cell_array_of_lap_indices{2})));
% assert(isequal(293,max(cell_array_of_lap_indices{3})));
%
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
%
%
% %% Compare speeds of pre-calculation versus post-calculation versus a fast variant
% figNum = 80003;
% fprintf(1,'Figure: %.0f: FAST mode comparisons\n',figNum);
% figure(figNum);
% close(figNum);
%
% dataSetNumber = 9;
%
% % Load some test data
% tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);
%
% start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
% end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
% excursion_definition = []; % empty
%
%
% Niterations = 50;
%
% % Do calculation without pre-calculation
% tic;
% for ith_test = 1:Niterations
%     % Call the function
%     [cell_array_of_lap_indices, ...
%         cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%         fcn_Laps_breakDataIntoLapIndices(...
%         tempXYdata,...
%         start_definition,...
%         end_definition,...
%         excursion_definition,...
%         ([]));
% end
% slow_method = toc;
%
% % Do calculation with pre-calculation, FAST_MODE on
% tic;
% for ith_test = 1:Niterations
%     % Call the function
%     [cell_array_of_lap_indices, ...
%         cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%         fcn_Laps_breakDataIntoLapIndices(...
%         tempXYdata,...
%         start_definition,...
%         end_definition,...
%         excursion_definition,...
%         (-1));
% end
% fast_method = toc;
%
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
%
% % Plot results as bar chart
% figure(373737);
% clf;
% hold on;
%
% X = categorical({'Normal mode','Fast mode'});
% X = reordercats(X,{'Normal mode','Fast mode'}); % Forces bars to appear in this exact order, not alphabetized
% Y = [slow_method fast_method ]*1000/Niterations;
% bar(X,Y)
% ylabel('Execution time (Milliseconds)')
%
%
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));


%% BUG cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ____  _    _  _____
% |  _ \| |  | |/ ____|
% | |_) | |  | | |  __    ___ __ _ ___  ___  ___
% |  _ <| |  | | | |_ |  / __/ _` / __|/ _ \/ __|
% | |_) | |__| | |__| | | (_| (_| \__ \  __/\__ \
% |____/ \____/ \_____|  \___\__,_|___/\___||___/
%
% See: http://patorjk.com/software/taag/#p=display&v=0&f=Big&t=BUG%20cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All bug case figures start with the number 9

% close all;

%% BUG

%% Fail conditions
if 1==0
	%

end


%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§
