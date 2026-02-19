%% Introduction to and Purpose of the Code
% This is the explanation of the code that can be found by running
%
%       script_demo_HandTrace.m
%
% This is a script to demonstrate the functions within the HandTrace code
% library. This code repo is typically located at:
%
%   https://github.com/ivsg-psu/FeatureExtraction_LaneBoundary_HandTrace
%
% If you have questions or comments, please contact Sean Brennan at
% sbrennan@psu.edu or Jaime Rodriguez at jrodriguezs.5@alumni.unav.es
%
% The purpose of the code is to allow the user to "trace" lane markings on
% a map very quickly.

% REVISION HISTORY:
% 
% 2026_02_17 by Sean Brennan, sbrennan@psu.edu and Jaime Rodriguez, jrodriguezs.5@alumni.unav.es
% - Started the repo


% TO-DO:
%
% 2026_02_17 by Sean Brennan, sbrennan@psu.edu
%   % * Main code needs to be updated
%   % * Update templates
%   % * Need to functionalize the template
%   % * Need to copy the getInput into a local version perhaps, allowing
%   white, yellow, dashed lines
%   % * Need to allow different outputs


%% Make sure we are running out of root directory
st = dbstack; 
thisFile = which(st(1).file);
[filepath,name,ext] = fileparts(thisFile);
cd(filepath);

%%% START OF STANDARD INSTALLER CODE %%%%%%%%%

%% Clear paths and folders, if needed
if 1==1
    clear flag_HandTrace_Folders_Initialized
end

if 1==0
    fcn_INTERNAL_clearUtilitiesFromPathAndFolders;
end

if 1==0
    % Resets all paths to factory default
    restoredefaultpath;
end

%% Install dependencies
% Define a universal resource locator (URL) pointing to the repos of
% dependencies to install. Note that DebugTools is always installed
% automatically, first, even if not listed:
clear dependencyURLs dependencySubfolders
ith_repo = 0;

ith_repo = ith_repo+1;
dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary';
dependencySubfolders{ith_repo} = {'Functions','Data'};

ith_repo = ith_repo+1;
dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_PathTools_GetUserInputPath';
dependencySubfolders{ith_repo} = {''};

ith_repo = ith_repo+1;
dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_PlotRoad';
dependencySubfolders{ith_repo} = {'Functions','Data'};

% ith_repo = ith_repo+1;
% dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_GeomTools_GeomClassLibrary';
% dependencySubfolders{ith_repo} = {'Functions','Data'};

% ith_repo = ith_repo+1;
% dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_MapTools_MapGenClassLibrary';
% dependencySubfolders{ith_repo} = {'Functions','testFixtures','GridMapGen'};



%% Do we need to set up the work space?
if ~exist('flag_HandTrace_Folders_Initialized','var')
    
    % Clear prior global variable flags
    clear global FLAG_*

    % Navigate to the Installer directory
    currentFolder = pwd;
    cd('Installer');
    % Create a function handle
    func_handle = @fcn_DebugTools_autoInstallRepos;

    % Return to the original directory
    cd(currentFolder);

    % Call the function to do the install
    func_handle(dependencyURLs, dependencySubfolders, (0), (-1));

    % Add this function's folders to the path
    this_project_folders = {...
        'Functions','Data'};
    fcn_DebugTools_addSubdirectoriesToPath(pwd,this_project_folders)

    flag_HandTrace_Folders_Initialized = 1;
end

%%% END OF STANDARD INSTALLER CODE %%%%%%%%%

%% Set environment flags for input checking in HandTrace library
% These are values to set if we want to check inputs or do debugging
setenv('MATLABFLAG_HANDTRACE_FLAG_CHECK_INPUTS','1');
setenv('MATLABFLAG_HANDTRACE_FLAG_DO_DEBUG','0');

%% Set environment flags that define the ENU origin
% This sets the "center" of the ENU coordinate system for all plotting
% functions
% Location for Test Track base station
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.86368573');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-77.83592832');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','344.189');


%% Set environment flags for plotting
% These are values to set if we are forcing image alignment via Lat and Lon
% shifting, when doing geoplot. This is added because the geoplot images
% are very, very slightly off at the test track, which is confusing when
% plotting data
setenv('MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LAT','-0.0000008');
setenv('MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LON','0.0000054');

%% Check if repo is ready for release
if 1==0
	figNum = 999999;
	repoShortName = '_HandTrace_';
	fcn_DebugTools_testRepoForRelease(repoShortName, (figNum));
end

%% Start of Demo Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____ _             _            __   _____                          _____          _
%  / ____| |           | |          / _| |  __ \                        / ____|        | |
% | (___ | |_ __ _ _ __| |_    ___ | |_  | |  | | ___ _ __ ___   ___   | |     ___   __| | ___
%  \___ \| __/ _` | '__| __|  / _ \|  _| | |  | |/ _ \ '_ ` _ \ / _ \  | |    / _ \ / _` |/ _ \
%  ____) | || (_| | |  | |_  | (_) | |   | |__| |  __/ | | | | | (_) | | |___| (_) | (_| |  __/
% |_____/ \__\__,_|_|   \__|  \___/|_|   |_____/ \___|_| |_| |_|\___/   \_____\___/ \__,_|\___|
%
%
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Start%20of%20Demo%20Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Welcome to the demo code for the HandTrace library!')


%% Section for Jaime to digitize test track
figNum = 10001;
titleString = sprintf('Section for Jaime to digitize Penn State test track');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;


% For Reber
if 1==0
    figNum = 10004;
    fcn_plotRoad_plotLL([],[],(figNum));
    set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);
    fileNameLaneBoundaries = fullfile(pwd,'Data','laneBoundaries_ReberParkingLot.mat');
	traceVariableName = 'boundariesReber';
end

% TO DO 
% - add pictures of each type of marking!
% - make sure our lane marking list is complete (USA, EU, etc.)

% For Test Track
if 1==1
    figNum = 10005;
    fcn_plotRoad_plotLL([],[],(figNum));
    % set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);
    fileNameLaneBoundaries = fullfile(pwd,'Data','pavementBoundaries_LTITestTrack.mat');
	traceVariableName = 'pavementBoundaries';

	% % Yellow
	% traceVariableName = 'solidSingleYellowLaneMarkings';
    figNumImg = 10006;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','solidSingleYellowLaneMarkings.png'));
    imshow(I); axis image off
    title('solidSingleYellowLaneMarkings','Interpreter','none');

	% traceVariableName = 'solidDoubleYellowLaneMarkings';
    figNumImg = 10007;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','solidDoubleYellowLaneMarkings.png'));
    imshow(I); axis image off
    title('solidDoubleYellowLaneMarkings','Interpreter','none');

	% traceVariableName = 'dashedSingleYellowLaneMarkings';
    figNumImg = 10008;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','dashedSingleYellowLaneMarkings.png'));
    imshow(I); axis image off
    title('dashedSingleYellowLaneMarkings','Interpreter','none');

	% traceVariableName = 'dashedDoubleYellowLaneMarkings';
    figNumImg = 10009;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','dashedDoubleYellowLaneMarkings.png'));
    imshow(I); axis image off
    title('dashedDoubleYellowLaneMarkings','Interpreter','none');
    
	% traceVariableName = 'solidDashedDoubleYellowLaneMarkings';
    figNumImg = 10010;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','solidDashedDoubleYellowLaneMarkings.png'));
    imshow(I); axis image off
    title('solidDashedDoubleYellowLaneMarkings','Interpreter','none');

	 
	% % White
	% traceVariableName = 'solidSingleWhiteLaneMarkings';
    figNumImg = 10011;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','solidSingleWhiteLaneMarkings.png'));
    imshow(I); axis image off
    title('solidSingleWhiteLaneMarkings','Interpreter','none');

	% traceVariableName = 'solidDoubleWhiteLaneMarkings';
    figNumImg = 10012;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','solidDoubleWhiteLaneMarkings.png'));
    imshow(I); axis image off
    title('solidDoubleWhiteLaneMarkings','Interpreter','none');

	% traceVariableName = 'dashedSingleWhiteLaneMarkings';
    figNumImg = 10013;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','dashedSingleWhiteLaneMarkings.png'));
    imshow(I); axis image off
    title('dashedSingleWhiteLaneMarkings','Interpreter','none');

	% traceVariableName = 'shortDashedWhiteLaneMarkings';
    figNumImg = 10014;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','shortDashedWhiteLaneMarkings.png'));
    imshow(I); axis image off
    title('shortDashedWhiteLaneMarkings','Interpreter','none');

	% traceVariableName = 'dottedDashedWhiteLaneMarkings';
    figNumImg = 10015;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','dottedDashedWhiteLaneMarkings.png'));
    imshow(I); axis image off
    title('dottedDashedWhiteLaneMarkings','Interpreter','none');

	% traceVariableName = 'dashedDoubleWhiteLaneMarkings';
    figNumImg = 10016;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','dashedDoubleWhiteLaneMarkings.png'));
    imshow(I); axis image off
    title('dashedDoubleWhiteLaneMarkings','Interpreter','none');

    % traceVariableName = 'solidDashedDoubleWhiteLaneMarkings';
    figNumImg = 10017;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','solidDashedDoubleWhiteLaneMarkings.png'));
    imshow(I); axis image off
    title('solidDashedDoubleWhiteLaneMarkings','Interpreter','none');

	% traceVariableName = 'stopLineWhiteLaneMarkings';
    figNumImg = 10018;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','stopLineWhiteLaneMarkings.png'));
    imshow(I); axis image off
    title('stopLineWhiteLaneMarkings','Interpreter','none');

	% traceVariableName = 'crosswalkWhiteLaneMarkings';
    figNumImg = 10019;
    figure(figNumImg);                

    I = imread(fullfile(pwd,'Images','crosswalkWhiteLaneMarkings.png'));
    imshow(I); axis image off
    title('crosswalkWhiteLaneMarkings','Interpreter','none');



end

% For I-99
if 1==0
    figNum = 10006;
    fcn_plotRoad_plotLL([],[],(figNum));
    set(gca,'MapCenter',[40.820145752792733 -77.894216100492017],'ZoomLevel',19.25);
    fileNameLaneBoundaries = fullfile(pwd,'Data','laneBoundaries_Interstate99Toftrees.mat');
end



if exist(fileNameLaneBoundaries,'file')
	load(fileNameLaneBoundaries,traceVariableName);
	eval(sprintf('priorBoundaries = %s;',traceVariableName));
else
	priorBoundaries = [];
end



boundariesByHand = fcn_GetUserInputPath_getUserInputPath((priorBoundaries),(figNum));
eval(sprintf('%s = boundariesByHand;',traceVariableName));
save(fileNameLaneBoundaries,traceVariableName);

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

%% function fcn_INTERNAL_clearUtilitiesFromPathAndFolders
function fcn_INTERNAL_clearUtilitiesFromPathAndFolders
% Clear out the variables
clear global flag* FLAG*
clear flag*
clear path

% Clear out any path directories under Utilities
path_dirs = regexp(path,'[;]','split');
utilities_dir = fullfile(pwd,filesep,'Utilities');
for ith_dir = 1:length(path_dirs)
    utility_flag = strfind(path_dirs{ith_dir},utilities_dir);
    if ~isempty(utility_flag)
        rmpath(path_dirs{ith_dir});
    end
end

% Delete the Utilities folder, to be extra clean!
if  exist(utilities_dir,'dir')
    [status,message,message_ID] = rmdir(utilities_dir,'s');
    if 0==status
        error('Unable remove directory: %s \nReason message: %s \nand message_ID: %s\n',utilities_dir, message,message_ID);
    end
end

end % Ends fcn_INTERNAL_clearUtilitiesFromPathAndFolders

