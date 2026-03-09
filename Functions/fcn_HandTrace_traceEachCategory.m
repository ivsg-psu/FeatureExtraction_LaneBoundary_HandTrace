function userFilledCategoryData = fcn_HandTrace_traceEachCategory(varargin)
% fcn_HandTrace_traceEachCategory
% A function for the user to enter all categorical information for a road,
% parking lot, etc.
%
% FORMAT:
%
%      pathXY = fcn_HandTrace_traceEachCategory((startingXY),(figNum))
%
% INPUTS:
%
%      (OPTIONAL INPUTS)
%
%      categoryData: a Nx2 cell array with 1 row for each category. The
%      columns are defined as:
%              categoryData{ith_category,1} = thisCategoryName;  % Char array representing categories
%              categoryData{ith_category,2} = thisSubcategories; % Cell array of subcategories
%          Subcategory cell arrays are defined as:
%              thisSubcategories{ith_subcategory,1} = subCategoryName;
%              thisSubcategories{ith_subcategory,2} = subCategoryColor;
%              thisSubcategories{ith_subcategory,3} = subCategorySize;
%              thisSubcategories{ith_subcategory,4} = subCategoryIsRequired;
%              thisSubcategories{ith_subcategory,5} = XY(Z) data;
%
%      figNum - a figure number to plot results. If set to -1,
%      skips any input checking or debugging, no figures will be generated,
%      and sets up code to maximize speed.
%
% OUTPUTS:
%
%      userFilledCategoryData: the same data above, but filled with user
%      inputs
%
% EXAMPLES:
%
% See the script: script_test_fcn_HandTrace_traceEachCategory
% for a full test suite.
%
% This function was written on 2026_03_08 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% 2026_03_08 by Sean Brennan, sbrennan@psu.edu
% - wrote the code originally using fcn_GetUserInputPath_getUserInputPath
%   % as a starter

% TO-DO:
% - 2026_03_08 by Sean Brennan, sbrennan@psu.edu
%   % - Add items here


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 2; % The largest Number of argument inputs to the function
flag_max_speed = 0; % The default. This runs code with all error checking
if (nargin==MAX_NARGIN && isequal(varargin{end},-1))
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_HANDTRACE_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_HANDTRACE_FLAG_CHECK_INPUTS");
    MATLABFLAG_HANDTRACE_FLAG_DO_DEBUG = getenv("MATLABFLAG_HANDTRACE_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_HANDTRACE_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_HANDTRACE_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_HANDTRACE_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_HANDTRACE_FLAG_CHECK_INPUTS);
    end
end

% flag_do_debug = 1;

if flag_do_debug % If debugging is on, print on entry/exit to the function
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_figNum = 999978; %#ok<NASGU>
else
    debug_figNum = []; %#ok<NASGU>
end

%% check input arguments?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0==flag_max_speed
    if flag_check_inputs
        % Are there the right number of inputs?
        narginchk(0,MAX_NARGIN);

        % validateattributes(L,{'numeric'},{'scalar','positive'});
        % validateattributes(W,{'numeric'},{'scalar','positive'});


    end
end

% Does the user want to specify the startingXY?
categoryData = [];  % Default case
if 1 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        categoryData = temp;
    end
end

% % Does the user want to specify the cornerShape?
% cornerParams = [L/5 W/10]; % Default case
% if 4 <= nargin
%     temp = varargin{2};
%     if ~isempty(temp)
% 		cornerParams = temp;
%     end
% end
%
% % Does the user want to specify the NcornerPoints?
% NcornerPoints = 20; % Default case
% if 5 <= nargin
%     temp = varargin{3};
%     if ~isempty(temp)
% 		NcornerPoints = temp;
% 		validateattributes(NcornerPoints,{'numeric'},{'scalar','integer','>=',2});
%     end
% end

% Does user want to show the plots?
flag_do_plots = 1; % Default is to show plots
figNum = [];
if (0==flag_max_speed) && (MAX_NARGIN == nargin)
    temp = varargin{end};
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp;
        flag_do_plots = 1;
    end
end

if isempty(figNum)
    temp = figure;
    figNum = get(temp,'Number');
end

%% Solve for the circle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Do we need to fill in categoryData?

if isempty(categoryData)
    categoryData = fcn_INTERNAL_fillCategoryDataFromFiles;
end

%% Fill in outputs
userFilledCategoryData = categoryData;

%% Set up figure
h_fig = figure(figNum);

% For debugging
warning('backtrace','on');

ax = gca(figNum); % axes('Parent',h_fig);

flag_isGeoPlot = 0;
if isprop(ax,'LatitudeAxis') && isprop(ax,'LongitudeAxis')
    flag_isGeoPlot = 1;
end


h_legend = legend('Interpreter','none','Location','northeast');


% Create the "exit" patch
fcn_INTERNAL_createNamedPatch(flag_isGeoPlot, [0 0 0], 'Click Here To Exit');
hold on;

% Create patches and handles for all items in categoryData
colorOrderThisAxis = colororder(ax);
Ncolors = size(colorOrderThisAxis,1);
cellArrayOfPlotHandles = cell(size(categoryData,1),2);
allCategoryNames = cell(size(categoryData,1),1);
for ith_category = 1:size(categoryData,1)
    thisCategoryName = categoryData{ith_category,1};
    allCategoryNames{ith_category,1} = thisCategoryName;
    colorToUse = mod(ith_category-1,Ncolors)+1;
    h_category = fcn_INTERNAL_createNamedPatch(flag_isGeoPlot, colorOrderThisAxis(colorToUse,:), thisCategoryName);
    cellArrayOfPlotHandles{ith_category,1} = h_category;

    thisSubcategories = categoryData{ith_category,2};
    cellArrayOfSubplotHandles = cell(size(thisSubcategories,1),1);
    for jth_subcategory = 1:size(thisSubcategories,1)
        subCategoryName       = thisSubcategories{jth_subcategory,1};
        subCategoryColor      = thisSubcategories{jth_subcategory,2};
        subCategorySize       = thisSubcategories{jth_subcategory,3};
        subCategoryIsRequired = thisSubcategories{jth_subcategory,4};
        XYZdata               = thisSubcategories{jth_subcategory,5};
        h_subcategory = fcn_INTERNAL_createNamedPlot(flag_isGeoPlot, subCategoryName, subCategoryColor, subCategorySize, subCategoryIsRequired, XYZdata);
        cellArrayOfSubplotHandles{jth_subcategory,1} = h_subcategory;
    end

    cellArrayOfPlotHandles{ith_category,2} = cellArrayOfSubplotHandles;

end


% Set ItemHitFcn
h_legend.ItemHitFcn = @(src,event) legendItemClicked(src,event);


set(h_fig, ...
    'WindowKeyPressFcn', @onKey);

title({'Select which categories to view.'});


uiwait(figNum);    % block until uiresume or figure closed
if ishandle(figNum)
    % close(figNum); % optional: close after finishing
end

    function legendItemClicked(~, event)
        s = getappdata(figNum,'HoldPanState');
        s.legendClicked = true;
        setappdata(figNum,'HoldPanState',s);

        % event.Peer      -> chart object associated with clicked legend item
        % event.Region    -> 'icon' or 'label'
        % event.SelectionType -> 'normal','extend','open','alt'

        h_Peer = event.Peer;
        h_PeerStruct = get(event.Peer);
        peerDisplayName = h_PeerStruct.DisplayName;

        % For debugging
        if 1==0
            fprintf(1,'Region: %s, SelectionType: %s, Name: %s \n', event.Region, event.SelectionType, peerDisplayName);
        end

        if strcmp(peerDisplayName,'Click Here To Exit')
            % set(h_fig, ...
            % 	'WindowButtonDownFcn', '', ...
            % 	'WindowKeyPressFcn', '', ...
            % 	'WindowButtonMotionFcn', '', ...
            % 	'WindowButtonUpFcn',   '');
            % h_legend.ItemHitFcn = [];
            % legend('off');
            uiresume(figNum);
        elseif any(strcmp(allCategoryNames,peerDisplayName))
            categoryHitIndex = find(strcmp(allCategoryNames,peerDisplayName),1);
            thisSubCategoryHandles = cellArrayOfPlotHandles{categoryHitIndex,2};
            tempSubcategories = categoryData{categoryHitIndex,2};
            for jth_tempSubcategory = 1:size(thisSubCategoryHandles,1)
                thisHandle = thisSubCategoryHandles{jth_tempSubcategory,1};
                if ~tempSubcategories{jth_tempSubcategory,4}
                    thisHandle.Visible = toggle(thisHandle.Visible);
                    thisHandle.HandleVisibility = toggle(thisHandle.HandleVisibility);
                end
            end
        elseif isprop(h_Peer,'Visible') || isfield(h_Peer,'Visible')
            h_Peer.Visible = toggle(h_Peer.Visible);   % toggle visibility
        end


    end

    function v = toggle(prev)
        if strcmp(prev,'on')
            v = 'off';
        else
            v = 'on';
        end
    end


    function onKey(~,event)
        % User pressed a key on the keyboard
        keyPress = event.Key;
        % if strcmp(event.Key,'return')
        % end

        switch keyPress
            case 'return'     % finish on Enter
                uiresume(figNum);

                % disp('Points collected:');
                % disp(pts);
                % uiresume(h_fig);               % optional: resume if waiting
                % close(h_fig);                  % optional: close figure

            % case 'hyphen' % Removes the last point
            %     if size(pathXY,1)>0
            %         pathXY(end,:) = [];
            %     end
            %     if isempty(pathXY)
            %         pathXY = [nan nan];
            %     end
            %     set(hPoints, 'XData', pathXY(:,1), 'YData', pathXY(:,2));
            %     drawnow;                      % update immediately

            % case 'i'     % Insert a new point
            % 
            %     % Find closest point
            %     currentPoint = get (ax, 'CurrentPoint');
            %     currentPointXY = currentPoint(1,1:2);
            % 
            %     if size(pathXY,1)==0
            %         pathXY = currentPointXY;
            %     else
            %         % Break path up into cell arrays, because snap function
            %         % does not work if there are NaN values
            %         cellArrayOfSubPathIndices = fcn_DebugTools_breakArrayByNans(pathXY,-1);
            % 
            %         % Loop through subpaths to see if they have closest
            %         % distance
            %         nearestDistance = inf;
            %         first_path_point_index = 1;
            %         second_path_point_index = 1;
            %         flag_isStartOrEnd = 0;
            %         for ith_subpath = 1:length(cellArrayOfSubPathIndices)
            %             thisIndices = cellArrayOfSubPathIndices{ith_subpath};
            %             thisSubPath = pathXY(thisIndices,:);
            % 
            %             % Keep track of which index the subpath starts at.
            %             % The snap function returns indices relative to the
            %             % subpath, NOT to pathXY
            %             thisOffsetIndex = thisIndices(1);
            % 
            %             % Snap point onto nearest path segment
            %             % FORMAT:
            %             % [closest_path_point,s_coordinate,path_point_yaw,....
            %             % 	first_path_point_index,...
            %             % 	second_path_point_index,...
            %             % 	percent_along_length] = ...
            %             % 	fcn_Path_snapPointOntoNearestPath(point, path, varargin)
            %             [closest_path_point,~,~,....
            %                 this_first_path_point_index,...
            %                 this_second_path_point_index,...
            %                 ~] = fcn_Path_snapPointOntoNearestPath(currentPointXY, thisSubPath, -1);
            %             thisDistance = sum((closest_path_point-currentPointXY).^2,2);
            % 
            %             % Check to see if this snap point is the closest
            %             if thisDistance < nearestDistance
            %                 nearestDistance = thisDistance;
            %                 first_path_point_index = this_first_path_point_index + thisOffsetIndex-1;
            %                 second_path_point_index = this_second_path_point_index + thisOffsetIndex-1;
            % 
            %                 % Check for special case where insertion has to
            %                 % be done at one of the endpoints of the
            %                 % subsegments
            %                 flag_isStartOrEnd = 0;
            %                 if this_first_path_point_index==this_second_path_point_index
            %                     if this_first_path_point_index==1
            %                         flag_isStartOrEnd = -1;
            %                     else
            %                         flag_isStartOrEnd = 1;
            %                     end
            %                 end
            % 
            %             end
            %         end
            % 
            %         % Perform insertion
            %         if first_path_point_index==second_path_point_index
            %             % The only time code will enter here is if an added
            %             % path point was found to occur either at the very
            %             % start or very end of the entire pathXY or one of
            %             % the subsegments. The insertion changes depending
            %             % on which case is encountered.
            %             if first_path_point_index == 1
            %                 % Insert at very front
            %                 pathXY = [currentPointXY; pathXY];
            %             elseif first_path_point_index == size(pathXY,1)
            %                 % Insert at very end
            %                 pathXY = [pathXY; currentPointXY];
            %             elseif flag_isStartOrEnd== -1
            %                 % Insert at front of subsegment but not very front
            %                 pathXY = [pathXY(1:first_path_point_index-1,:); currentPointXY; pathXY(first_path_point_index:end,:)];
            %             else
            %                 % Insert at end of subsegment but not very end
            %                 pathXY = [pathXY(1:first_path_point_index,:); currentPointXY; pathXY(first_path_point_index+1:end,:)];
            %             end
            %         else
            %             % Insert between end points
            %             pathXY = [pathXY(1:first_path_point_index,:); currentPointXY; pathXY(second_path_point_index:end,:)];
            %         end
            %     end
            % 
            %     set(hPoints, 'XData', pathXY(:,1), 'YData', pathXY(:,2));
            %     drawnow;                      % update immediately
            % 
            % 
            % 
            % case 'd' % Delete a point
            %     if size(pathXY,1)<2
            %         pathXY = [nan nan];
            %         return;
            %     end
            % 
            %     % Find closest point
            %     currentPoint = get (ax, 'CurrentPoint');
            %     currentPointXY = currentPoint(1,1:2);
            % 
            %     % Get current axis limits
            %     s = getappdata(figNum,'HoldPanState');
            %     if flag_isGeoPlot
            %         [latlimOut,lonlimOut] = geolimits;
            %         s.startXLim = lonlimOut;
            %         s.startYLim = latlimOut;
            %     else
            %         s.startXLim = ax.XLim;
            %         s.startYLim = ax.YLim;
            %     end
            % 
            %     %%%%%%%%%%%%%
            %     % FORMAT:
            %     % closestIndex = fcn_INTERNAL_findNearestPointIndex(xlimits, ylimits, pathXY, currentPointXY, threshold)
            %     closestIndex = fcn_INTERNAL_findNearestPointIndex(s.startXLim, s.startYLim, pathXY, currentPointXY, 1);
            % 
            %     % Remove it from the list
            %     pathXY(closestIndex,:) = [];
            % 
            %     set(hPoints, 'XData', pathXY(:,1), 'YData', pathXY(:,2));
            %     drawnow;                      % update immediately

            otherwise
                fprintf(1,'No action coded for keypress: %s\n',keyPress);
        end
    end

%% Plot the results (for debugging)?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close(figNum);

if flag_do_plots
    % Nothing to do

end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end
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


function closestIndex = fcn_INTERNAL_findNearestPointIndex(xlimits, ylimits, pathXY, currentPointXY, threshold)
% Check to see if mouse click is on top of existing point
% Find nearest point in the clicked handle

xAxisRange = xlimits(2) - xlimits(1);
yAxisRange = ylimits(2) - ylimits(1);

Npoints = size(pathXY,1);
xyDifferences = pathXY- ones(Npoints,1)*currentPointXY;

normalizedDifferences = xyDifferences./[xAxisRange yAxisRange];


distanceFromPointsSquared = sum(normalizedDifferences.^2,2);
[minDistanceSquared,ind] = min(distanceFromPointsSquared,[],1,'omitnan');

% For debugging
if 1==0
    fprintf(1,'%.6f\n',minDistanceSquared);
end

if minDistanceSquared<threshold^2
    closestIndex = ind;
else
    % Leave move index empty if not a click and drag
    closestIndex = [];
end
end

%% fcn_INTERNAL_fillCategoryDataFromFiles
function categoryData = fcn_INTERNAL_fillCategoryDataFromFiles
categoryFiles = dir(fullfile(pwd,'Data','Categories_*.txt'));
categoryData = cell(length(categoryFiles), 2);
for ith_category = 1:length(categoryFiles)
    % For each text file, read the file and ignore the first line. Each of
    % the following lines is saved into a cell array to define the
    % subcategories.
    thisFileName = categoryFiles(ith_category).name;
    thisTextFile = fullfile(categoryFiles(ith_category).folder, thisFileName);

    % Read all the lines of the file into an array of strings
    categoryText = readlines(thisTextFile);

    % Loop through the strings, identifying which are categories
    flagIsCategory = false(size(categoryText,1),1);
    Ncomments = 0;
    Nempty = 0;
    for ith_line = 1:size(categoryText,1)
        thisLineOfText = char(categoryText(ith_line,:));
        if isempty(thisLineOfText)
            % Empty
            Nempty = Nempty+1;
        elseif strcmp(thisLineOfText(1,1),'%')
            % Comment, skip it
            Ncomments = Ncomments + 1;
        elseif ~isempty(thisLineOfText)
            flagIsCategory(ith_line,1) = true;
        else
            error('Unknown situation encountered?');
        end
    end

    % Loop through the subcategories
    subcategoryList = categoryText(flagIsCategory,:);
    Nsubcategories = size(subcategoryList,1);
    Nparts = 4;

    thisSubcategories = cell(Nsubcategories,Nparts);
    for ith_subcategory = 1:Nsubcategories
        thisCategoryText = char(subcategoryList(ith_subcategory,:));

        % Break the subcategory text into parts
        % Example: thisLineOfText = 'one, two , three';
        cellArrayOfParts = strsplit(thisCategoryText, ',');          % keeps spaces
        cellArrayOfPartsNoLeadTrailSpaces = strtrim(cellArrayOfParts);  % remove leading/trailing spaces in each cell
        % result: {'one' 'two' 'three'}

        % Make sure right number of parts
        if size(cellArrayOfPartsNoLeadTrailSpaces,2)~=Nparts
            error('Subcategory encountered in:\n\t%s\nthat is missing required details (%.0f parts expected): \n\t%s', thisTextFile, Nparts, thisCategoryText);
        end

        % Grab name
        subCategoryName = cellArrayOfPartsNoLeadTrailSpaces{1};
        if ~isvarname(subCategoryName)
            error('Subcategory name encountered in file:\n\t%s \nthat is not a valid MATLAB variable name:\n\t%s',thisTextFile, subCategoryName);
        end

        % Grab color
        subCategoryColorString = cellArrayOfPartsNoLeadTrailSpaces{2};
        eval(sprintf('subCategoryColor = %s;',subCategoryColorString));
        if size(subCategoryColor,1)~=1 || size(subCategoryColor,2)~=3
            error('Subcategory color encountered in file:\n\t%s \nthat is not a valid 1x3 color matrix:\n\t%s',thisTextFile, subCategoryColorString);
        end

        % Grab size
        subCategorySizeString = cellArrayOfPartsNoLeadTrailSpaces{3};
        eval(sprintf('subCategorySize = %s;',subCategorySizeString));
        if size(subCategorySize,1)~=1 || size(subCategorySize,2)~=1
            error('Subcategory size encountered in file:\n\t%s \nthat is not a valid 1x1 scalar:\n\t%s',thisTextFile, subCategorySizeString);
        end

        % Grab isRequired
        subCategoryIsRequiredString = cellArrayOfPartsNoLeadTrailSpaces{4};
        eval(sprintf('subCategoryIsRequired = %s;',subCategoryIsRequiredString));
        if size(subCategoryIsRequired,1)~=1 || size(subCategoryIsRequired,2)~=1
            error('Subcategory isRequired encountered in file:\n\t%s \nthat is not a valid 1x1 scalar:\n\t%s',thisTextFile, subCategoryIsRequiredString);
        end

        thisSubcategories{ith_subcategory,1} = subCategoryName;
        thisSubcategories{ith_subcategory,2} = subCategoryColor;
        thisSubcategories{ith_subcategory,3} = subCategorySize;
        thisSubcategories{ith_subcategory,4} = subCategoryIsRequired;
        thisSubcategories{ith_subcategory,5} = [rand rand; rand rand];
    end

    % Save the name
    thisCategoryWithExtension = extractAfter(thisFileName,'Categories_');
    thisCategoryName = thisCategoryWithExtension(1:end-4);
    categoryData{ith_category,1} = thisCategoryName;  % Char array representing categories

    % Save the subcategories
    categoryData{ith_category,2} = thisSubcategories; % Cell array of subcategories


end
end % Ends fcn_INTERNAL_fillCategoryDataFromFiles

%% fcn_INTERNAL_createNamedPatch
function h_category = fcn_INTERNAL_createNamedPatch(flag_isGeoPlot, colorVector, displayNameString)

% Check for named colors
if contains(displayNameString,'Yellow')
    colorVector = [1 1 0];
elseif contains(displayNameString,'White')
    colorVector = [1 1 1];
elseif contains(displayNameString,'Blue')
    colorVector = [0 0 1];
elseif contains(displayNameString,'Green')
    colorVector = [0 1 0];
elseif contains(displayNameString,'Red')
    colorVector = [1 0 0];
end

if flag_isGeoPlot
    laneShape = geopolyshape(nan, nan);
    h_category = geoplot(laneShape,'FaceColor',colorVector,'DisplayName',displayNameString);
else
    h_category = patch('Xdata',nan, 'YData',nan,'FaceColor',colorVector,'DisplayName',displayNameString);
end
end % Ends fcn_INTERNAL_createNamedPatch

%% fcn_INTERNAL_createNamedPlot
function h_subcategory = fcn_INTERNAL_createNamedPlot(flag_isGeoPlot, subCategoryName, subCategoryColor, subCategorySize, subCategoryIsRequired, XYZdata)

if contains(subCategoryName,'Node')
    markerStyle = '.';
    MarkerSize = subCategorySize;
    LineWidth = 3;
else
    markerStyle = '.-';
    MarkerSize = 10;
    LineWidth = subCategorySize;
end

HandleVisibility = 'off';
Visible = 'off';
if subCategoryIsRequired
    HandleVisibility = 'on';
    Visible = 'on';
end

if flag_isGeoPlot
    h_subcategory = geoplot(XYZdata(:,1),XYZdata(:,2), markerStyle,'Color',subCategoryColor,'MarkerSize',MarkerSize,'LineWidth',LineWidth,'DisplayName',subCategoryName,'HandleVisibility',HandleVisibility,'Visible',Visible);
else
    h_subcategory = plot(XYZdata(:,1),XYZdata(:,2), markerStyle, 'Color',subCategoryColor,'MarkerSize',MarkerSize,'LineWidth',LineWidth,'DisplayName',subCategoryName,'HandleVisibility',HandleVisibility,'Visible',Visible);
end
end % Ends fcn_INTERNAL_createNamedPlot