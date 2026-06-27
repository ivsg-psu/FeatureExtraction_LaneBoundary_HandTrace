function fcn_HandTrace_createMenusFromFile(filename, figHandle)
% createMenusFromFile Create menu hierarchy from file lines
%   createMenusFromFile(filename, figHandle) reads all lines from the text
%   file specified by filename. Each nonempty line defines a menu entry:
%     - "Label"                   -> top-level menu
%     - "Parent_Child"            -> Child submenu under Parent
%     - "Parent_Child_Grandchild" -> Grandchild under Child under Parent
%
%   The function creates missing parent menus as needed.
%
% This is a function that takes in a filename as a character array and a
% handle to a figure. The function should read all lines of the file as a
% string array. For each row that contains no underscore characters, the
% row string is made into a main menu choice in the figure. For each row
% that contains one underscore separating two strings, the string after the
% underscore is made into a submenu of the string before the underscore.
% For a row that contains two underscores separating three strings, the
% last string becomes a sub-sub menu underneath the submenu of the second
% string, which is a submenu under the menu item of the first string.
% Create a simple example showing the usage including at least 3 menus, 1
% submenu, and 1 sub-sub menu.


% Create the "Data" menu options (Save, Load)
dataHandle = uimenu(figHandle, 'Text', 'Data');
% set(dataHandle,'ForegroundColor',childColor);

% Add save option
handleSaveData = uimenu(dataHandle, 'Text', 'Save Data', ...  % 		% 'Checked', 'on', ...
	'MenuSelectedFcn', @fcn_INTERNAL_fileSave); %#ok<NASGU>

% Add load option
handleLoadData = uimenu(dataHandle, 'Text', 'Load Data', ...  % 		% 'Checked', 'on', ...
	'MenuSelectedFcn', @fcn_INTERNAL_fileLoad); %#ok<NASGU>


% Read all lines as a string array
lines = readlines(filename);
lines = strtrim(lines);              % trim whitespace
lines = lines(~(lines == ""));       % remove empty lines

% Populate the menu options
menuStruct = fcn_INTERNAL_createMenusFromLines(figHandle, lines);

% Save the lines, in case we save/load the data later
menuStruct.selfLines = lines;

% Save results into the figure for function call-backs
set(figHandle,'UserData',menuStruct);

% Draw results
fcn_INTERNAL_drawDataOntoPlot(figHandle, [], [], false)

end

%% fcn_INTERNAL_addMenuInfo
function [childHandle, outputStruct] = fcn_INTERNAL_addMenuInfo(...
    parentHandle, parentStruct, ...
    childText, childColor, childSize, childIsRequiredString, childDrawingType, ...
    flagSubmenusExist, fullKey)


childHandle = uimenu(parentHandle, 'Text', childText);
set(childHandle,'ForegroundColor',childColor);

if isfield(parentStruct,'selfIsVisible') && ~parentStruct.selfIsVisible
    set(childHandle,'Visible','off');
end

if flagSubmenusExist
    % Add toggle buttons
    handleShowOnFig = uimenu(childHandle, 'Text', 'Show Category', ...  % 		% 'Checked', 'on', ...
        'MenuSelectedFcn', @toggleShowInfo, 'UserData', fullKey);
else
    % Add toggle buttons
    handleShowOnFig = uimenu(childHandle, 'Text', 'Show on Figure', ... % 		'Checked', 'on', ...
        'MenuSelectedFcn', @toggleShowInfo, 'UserData', fullKey);

    handleEdit = uimenu(childHandle, 'Text', 'Edit', ...
        'Callback', @(src,event) fcn_INTERNAL_updateData(src, event, fullKey));

    handleShowExamples = uimenu(childHandle, 'Text', 'Show Examples', ...
        'Callback', @(src,event) fcn_INTERNAL_showExamples(src, event, fullKey), ...
		'UserData',fullKey);
end

outputStruct = parentStruct;
outputStruct.(childText).selfColor = childColor;
outputStruct.(childText).selfSize = childSize;
outputStruct.(childText).selfIsRequiredFlag = strcmpi(childIsRequiredString,'required');
outputStruct.(childText).selfDrawingType = childDrawingType;
outputStruct.(childText).selfIsVisible = outputStruct.(childText).selfIsRequiredFlag;
outputStruct.(childText).selfHandle = childHandle;
outputStruct.(childText).selfHandleShowOnFig = handleShowOnFig;
if ~flagSubmenusExist
    outputStruct.(childText).selfHandleEdit = handleEdit;
    outputStruct.(childText).selfHandleShowExamples = handleShowExamples;
end
outputStruct.(childText).selfData = [nan nan];
outputStruct.(childText).selfDataFlagDataHasChanged = false;

% Create an empty plot
figHandle = fcn_INTERNAL_getFigHandleFromSource(parentHandle);
outputStruct.(childText).selfDataHandleToDataPlot = fcn_plotRoad_plotLL([nan nan],[],figHandle);

end % Ends fcn_INTERNAL_addMenuInfo

%% toggleShowInfo
function toggleShowInfo(src, ~)
% Toggle the Checked property and the local state
% if strcmp(src.Checked, 'on')
%     src.Checked = 'off';
%     showInfo = false;
% else
%     src.Checked = 'on';
%     showInfo = true;
% end

% Change the menu text
flagShowInfo = fcn_INTERNAL_flipMenuText(src);

% For debugging:
if 1==0
    disp(['Show Info is now: ', string(flagShowInfo)]);
end

% Get the figure handle. To do this, pull the data out of the figure
figHandle = fcn_INTERNAL_getFigHandleFromSource(src);

% Save results into the figure data
thisNode = get(src,'UserData');
parts = strsplit(thisNode, '.');
menuStruct = get(figHandle,'UserData');
if strcmp(parts{1},'menuStruct')
    subStructure = getfield(menuStruct, parts{2:end});
else
	subStructure = getfield(menuStruct, parts{1:end});
end

% Turn on or off this structure
subStructure = fcn_INTERNAL_showOrHideStructure(subStructure,flagShowInfo, true);	

% Turn on all substructure menus and plots
fields = fieldnames(subStructure);
for ith_field = 1:length(fields)
	thisFieldString = fields{ith_field};
	if isstruct(subStructure.(thisFieldString))
		subStructure.(thisFieldString) = fcn_INTERNAL_showOrHideStructure(subStructure.(thisFieldString),flagShowInfo, false);		
	end
end

newSubStructure = subStructure;
newSubStructure.selfIsVisible = flagShowInfo;
fcn_INTERNAL_saveDataIntoFigure(figHandle, newSubStructure, parts)

% Redraw the plot
fcn_INTERNAL_drawDataOntoPlot(src, [], [], false)
end % Ends toggleShowInfo


%% fcn_INTERNAL_flipMenuText
function flagShowInfo = fcn_INTERNAL_flipMenuText(src)
oldNameString = src.Text;
if contains(oldNameString, 'Show')
    newNameString = replace(oldNameString,'Show','Hide');
    flagShowInfo = true;
else
    newNameString = replace(oldNameString,'Hide','Show');
    flagShowInfo = false;
end
set(src,'Text',newNameString);
end % Ends fcn_INTERNAL_flipMenuText

%% fcn_INTERNAL_showOrHideStructure
function thisStructure = fcn_INTERNAL_showOrHideStructure(thisStructure,flagShowInfo, flagThisIsMainMenu)
if flagShowInfo
	if ~flagThisIsMainMenu
		% Turn the menu on
		if isfield(thisStructure,'selfHandle')
			thisSelfHandle = thisStructure.selfHandle;
			set(thisSelfHandle,'Visible','on');
		end

		% Mark the flag that it is now visible
		if isfield(thisStructure,'selfIsVisible')
			thisStructure.selfIsVisible = true;
		end
	end

	% Turn on the plot
	if isfield(thisStructure,'selfDataHandleToDataPlot')
		set(thisStructure.selfDataHandleToDataPlot,'Visible','on');
	end

	% Mark that the plot has updated
	if isfield(thisStructure,'selfDataFlagDataHasChanged')
		thisStructure.selfDataFlagDataHasChanged = true;
	end
else
	if ~flagThisIsMainMenu

		% Turn the menu off
		if isfield(thisStructure,'selfHandle')
			thisSelfHandle = thisStructure.selfHandle;
			set(thisSelfHandle,'Visible','off');
		end

		% Mark the flag that it is now NOT visible
		if isfield(thisStructure,'selfIsVisible')
			thisStructure.selfIsVisible = false;
		end
	end
	% Turn off the plot
	if isfield(thisStructure,'selfDataHandleToDataPlot')
		set(thisStructure.selfDataHandleToDataPlot,'Visible','off');
	end

	% Mark that the plot has updated
	if isfield(thisStructure,'selfDataFlagDataHasChanged')
		thisStructure.selfDataFlagDataHasChanged = true;
	end
end
end % Ends fcn_INTERNAL_showOrHideStructure

%% fcn_INTERNAL_updateData
function  fcn_INTERNAL_updateData(src, event, fullKey)

% Updates data being shown on a given menu. Saves the results into the
% 'UserData' area of the current figure, as a structure.

% Get the figure handle
figHandle = fcn_INTERNAL_getFigHandleFromSource(src);


% Grab the structure that contains all the menus, and drill down into the
% structure to find the specific substructure that is calling this
% function. Once in that substructure, grab the data.
menuStruct = get(figHandle,'UserData');
parts = strsplit(fullKey, '.');
subStructure = getfield(menuStruct, parts{:});
inputType = subStructure.selfDrawingType;
startingXY = subStructure.selfData;

% Grab the current properties of the figure, so that we can open up a new
% one with the same properties
hAxes = gca;
flag_isGeoPlot = isa(hAxes,'matlab.graphics.axis.GeographicAxes');
if ~flag_isGeoPlot
    error('Expecting a geoplot - exiting');
end

% Get the current figure's location information
currentMapCenter = get(gca,'MapCenter');
currentZoomLevel = get(gca,'ZoomLevel');

% Open up a new figure
tempFigHandle = figure;
fcn_plotRoad_plotLL([],[],(tempFigHandle));
set(gca,'MapCenter',currentMapCenter,'ZoomLevel',currentZoomLevel);

% Grab results from user
newSelfData = fcn_GetUserInputPath_getUserInputPath((startingXY),(tempFigHandle),(inputType));



% Save results into structure and into the figure
newSubStructure = subStructure;

% Make sure changes are visible
newSubStructure.selfIsVisible = true;

newPlotHandle = fcn_GetUserInputPath_updateDrawing(newSelfData, (inputType), (newSubStructure.selfDataHandleToDataPlot), (figHandle));
newSubStructure.selfDataHandleToDataPlot = newPlotHandle;
set(newSubStructure.selfDataHandleToDataPlot,'Visible','on')
% set(newSubStructure.selfDataHandleToDataPlot,'LatitudeData',newSelfData(:,1));
% set(newSubStructure.selfDataHandleToDataPlot,'LongitudeData',newSelfData(:,2));
set(newSubStructure.selfDataHandleToDataPlot,'Color',newSubStructure.selfColor);
set(newSubStructure.selfDataHandleToDataPlot,'LineWidth',newSubStructure.selfSize);
newSubStructure.selfDataFlagDataHasChanged = true;

% Change the menu
flagShowInfo = fcn_INTERNAL_flipMenuText(src.Parent.Children(3)); %#ok<NASGU>

% Save results back into figure
newSubStructure.selfData = newSelfData;
fcn_INTERNAL_saveDataIntoFigure(figHandle, newSubStructure, parts)

% Redraw the plot
fcn_INTERNAL_drawDataOntoPlot(src, event, fullKey, false)

end

%% fcn_INTERNAL_showExamples
function  fcn_INTERNAL_showExamples(src, event, fullKey) %#ok<INUSD>

thisNode = get(src,'UserData');
filePrefix = replace(thisNode,'.','_');
searchString = cat(2,filePrefix,'*.jpg');
fullSearchPath = fullfile(pwd,'Data',searchString);
listing = dir(fullSearchPath);

fcn_INTERNAL_tileImages(listing, 'MaxCols', 5, 'Title', filePrefix);

end


%% fcn_INTERNAL_drawDataOntoPlot
function fcn_INTERNAL_drawDataOntoPlot(src, event, fullKey, flagForcePlot) %#ok<INUSD>

% Plots all the menus and submenu data
% Setting flagForcePlot to true forces everything to be redrawn


% Get the figure handle
figHandle = fcn_INTERNAL_getFigHandleFromSource(src);

menuStruct = get(figHandle,'UserData');
[nodes, ~] = fcn_INTERNAL_structHierarchy(menuStruct, 'menuStruct');


% Loop through all the entries, from bottom to top, shutting off visibility
% for ones that are not checked
numStructures = size(nodes,1);
flagsShowMenuData = true(numStructures,1);


for ith_struct = numStructures:-1:1
	thisNode = nodes{ith_struct};
	if ~contains(thisNode,'self')
		parts = strsplit(thisNode, '.');

		% Is this substructure NOT the root?
		if length(parts)>1
			subStructure = getfield(menuStruct, parts{2:end});
			% Is visibility a field that is set?
			if isfield(subStructure,'selfIsVisible')
				if ~subStructure.selfIsVisible
					% Set all values to false
					flagsShowMenuData(contains(nodes,thisNode)) = false;
				end
			end

		end
	end
end


% Now, loop through all the structures and plot each
for ith_struct = numStructures:-1:1
    thisNode = nodes{ith_struct};
    if ~contains(thisNode,'self')
        parts = strsplit(thisNode, '.');

        % Is this substructure something to be plotted, for example NOT the root?
        if length(parts)>1
            subStructure = getfield(menuStruct, parts{2:end});

            % Is this menu item changed since last time?
            if flagForcePlot || (isfield(subStructure,'selfDataFlagDataHasChanged') && subStructure.selfDataFlagDataHasChanged)
                % Grab the handle to the data plot, if it exists
                if isfield(subStructure,'selfDataHandleToDataPlot') && ~isempty(subStructure.selfDataHandleToDataPlot)
                    plotHandle = subStructure.selfDataHandleToDataPlot;
                                                                                                                                          
                    % Change the visibility of the plot
                    if flagsShowMenuData(ith_struct,1)
                        set(plotHandle,'Visible','on');						
                    else
                        set(plotHandle,'Visible','off');
                    end
                    

                    % Update the flag so it isn't replotted until another
                    % change
                    subStructure.selfDataFlagDataHasChanged = 0;

                    % Save results into the figure data
                    newSubStructure = subStructure;
                    fcn_INTERNAL_saveDataIntoFigure(figHandle, newSubStructure, parts)
                end
            end
        end
    end
end

end % Ends fcn_INTERNAL_drawDataOntoPlot




%% fcn_INTERNAL_structHierarchy
function [nodes, edges] = fcn_INTERNAL_structHierarchy(s, rootName)
% structHierarchy  List parent/child relationships for nested structures.
%   [NODES, EDGES] = fcn_INTERNAL_structHierarchy(S) returns all node paths and edges.
%   [NODES, EDGES] = fcn_INTERNAL_structHierarchy(S, ROOTNAME) uses ROOTNAME as top path.
%
%   Node path examples:
%     'mystruct'                     (scalar struct)
%     'mystruct.field'               (field)
%     'mystruct(2).field.subfield'   (struct array element)
%
%   EDGES is Mx2 cell array: {parentPath, childPath}.
%
% EXAMPLE USAGE:
% s(1).a.x = 1;
% s(1).a.y = struct('m',10);
% s(2).a.x = 2;
% s(2).b = struct('z',3);
% [nodes, edges] = fcn_INTERNAL_structHierarchy(s, 's')
%
% Interpretation tips:
%
% nodes lists every visited path.
% edges lists direct parent → child relationships; children may themselves be parents for deeper levels.
% To get children of a given parent, find rows in edges where first column equals that parent.
% To get parents of a node, find rows in edges where second column equals that node.


if nargin < 2 || isempty(rootName)
    rootName = 'root';
end

nodes = {}; edges = {};
visited = containers.Map(); % to avoid duplicate nodes if same path revisited

recurse(rootName, s);

    function recurse(path, val)
        % record node
        if ~isKey(visited, path)
            visited(path) = true;
            nodes{end+1,1} = path;
        end
        % only structures can have children
        if ~isstruct(val)
            return
        end
        % iterate over elements of struct array
        for k = 1:numel(val)
            idx = '';
            if numel(val) > 1
                idx = sprintf('(%d)', k);
            end
            % for each field
            fn = fieldnames(val);
            for f = 1:numel(fn)
                childPath = sprintf('%s%s.%s', path, idx, fn{f});
                % record edge parent -> child
                edges(end+1,:) = {path, childPath}; %#ok<AGROW>
                % recurse into field value
                try
                    fldVal = val(k).(fn{f});
                catch
                    fldVal = []; % safe fallback
                end
                recurse(childPath, fldVal);
            end
        end
    end
end

%% fcn_INTERNAL_saveDataIntoFigure
function fcn_INTERNAL_saveDataIntoFigure(figHandle, newSubStructure, parts)
% Saves changes to a subStructure back into the figure

% Grab the existing data
menuStruct = get(figHandle,'UserData');

% Make sure to avoid nesting menuStruct into itself
if strcmp(parts{1},'menuStruct')
    if length(parts)>1
        tempParts = parts(1,2:end);
    else
        error('Expected a menu structure more than 1 menu deep.');
    end
    parts = tempParts;
end

% Save the new substructure into the figure data
newMenuStruct = setfield(menuStruct,parts{:},newSubStructure);

% Push the new figure data back into the figure
set(figHandle,'UserData',newMenuStruct);
end % Ends fcn_INTERNAL_saveDataIntoFigure

%% fcn_INTERNAL_getFigHandleFromSource
function figHandle = fcn_INTERNAL_getFigHandleFromSource(src)
% Gets the handle figure. This is done by recursively going "up" each
% parent until a figure type handle is found.

p = src;
if ~isgraphics(p,'figure')
    p = get(src,'Parent');
    while ~isempty(p) && ~isgraphics(p,'figure')
        p = get(p,'Parent');
    end
end

figHandle = p; % empty if no figure found

end % Ends fcn_INTERNAL_getFigHandleFromSource

%% fcn_INTERNAL_fileSave
function fcn_INTERNAL_fileSave(src, ~)
% Saves data from the current figure to a file

% Get the figure handle. To do this, pull the data out of the figure
figHandle = fcn_INTERNAL_getFigHandleFromSource(src);

% Grab data from the current figure
menuStruct = get(figHandle,'UserData');

% Show a simple menu
choice = menu('Do you want to save the data?', 'Save', 'Cancel');

% Get the axis location
hAxis = gca;
LatLimits = get(hAxis,'LatitudeLimits');
LonLimits = get(hAxis,'LongitudeLimits');
ZoomLevel = get(hAxis,'ZoomLevel');

AABB = [...
	min(LatLimits) min(LonLimits);
	max(LatLimits) min(LonLimits);
	max(LatLimits) max(LonLimits);
	min(LatLimits) max(LonLimits);
	min(LatLimits) min(LonLimits);
	];
stringZoomLevel = sprintf('%.3f',ZoomLevel);

if choice == 1
    % Default folder and filename (adjust as needed)
    defaultFolder = fullfile(pwd, 'Data'); % Default save folder
    defaultName = fcn_INTERNAL_makeBBoxFilename(AABB(:,1), AABB(:,2), stringZoomLevel, 'mat');
    defaultFull = fullfile(defaultFolder, defaultName);

	% Make sure file name is valid
	[isValid, reason] = fcn_INTERNAL_isValidWindowsFilename(defaultName, 'CheckPath',true, 'BasePath',defaultFolder);
	if ~isValid
		error('Unable to use filename: %s because: %s',defaultFull,reason);
	end

    % Show Save dialog with default location/name
    [file, path] = uiputfile(defaultFull, 'Save MAT file as');

    if isequal(file, 0) || isequal(path, 0)
        disp('User canceled save.');
    else
        save(fullfile(path, file), 'menuStruct'); % specify variables to save
        fprintf('Saved to %s\n', fullfile(path, file));
    end
else
    disp('Save canceled via menu.');
end

end % Ends fcn_INTERNAL_fileSave


%% fcn_INTERNAL_makeBBoxFilename
function filename = fcn_INTERNAL_makeBBoxFilename(lat, lon, stringZoomLevel, extension)
% MAKEBBOXFILENAME Generates a positive-only bounding box filename using N/S/E/W suffixes.
%
% EXAMPLE:
% latData = [40.3521, 40.4015, 40.3750];
% lonData = [-79.9142, -79.8511, -79.8890];
% 
% bBoxFile = fcn_INTERNAL_makeBBoxFilename(latData, lonData, 'geojson');
% disp(bBoxFile); 
% % Outputs: "40.3521N_79.9142W_40.4015N_79.8511W.geojson"
%
% No Negative Signs: The code uses abs() to convert all numbers to absolute
% positive values.Readable: A human or a script can instantly tell exactly
% what quadrant of the Earth the data belongs to without guessing if a
% positive number was originally a negative.Cross-Platform Safe: Letters
% and underscores are completely safe on Windows, Mac, and Linux systems.

% 1. Extract the extreme bounding box limits
ymin = min(lat); % Southernmost
xmin = min(lon); % Westernmost
ymax = max(lat); % Northernmost
xmax = max(lon); % Easternmost

% 2. Helper function to format an individual coordinate with its direction
formatLat = @(v) sprintf('%.8f%s', abs(v), char(sprintf('%s', fnc_INTERNAL_ternary(v >= 0, 'N', 'S'))));
formatLon = @(v) sprintf('%.8f%s', abs(v), char(sprintf('%s', fnc_INTERNAL_ternary(v >= 0, 'E', 'W'))));

% 3. Clean up the extension formatting
if ~startsWith(extension, '.')
	extension = ['.' extension];
end

% 4. Build the final filename
filename = sprintf('%s_%s_%s_%s_%s%s', ...
	formatLat(ymin), formatLon(xmin), formatLat(ymax), formatLon(xmax), stringZoomLevel, extension);
end % Ends fcn_INTERNAL_makeBBoxFilename

%% fnc_INTERNAL_ternary
function out = fnc_INTERNAL_ternary(condition, trueVal, falseVal)
% Inline helper function to mimic standard ternary operators
if condition, out = trueVal; else, out = falseVal; end
end % Ends fnc_INTERNAL_ternary


%% fcn_INTERNAL_fileLoad
function fcn_INTERNAL_fileLoad(src, ~)
% Loads data from a file into the current figure

% Get the figure handle. To do this, pull the data out of the figure
figHandle = fcn_INTERNAL_getFigHandleFromSource(src);

% Show a simple menu
% choice = menu('Do you want to load data? WARNING: this will delete any unsaved changes', 'Continue', 'Cancel');

choice = uiconfirm(figHandle, 'Do you want to load data? WARNING: this will delete any unsaved changes', 'Confirm', ...
                        'Options', {'Yes','Cancel'}, ...
                        'DefaultOption', 'Yes');

if strcmpi(choice,'yes')
    % Default folder and filename (adjust as needed)
    defaultFolder = fullfile(pwd, 'Data'); % Default save folder
    defaultName = []; %fcn_INTERNAL_makeBBoxFilename(AABB(:,1), AABB(:,1), 'mat');
    defaultFull = fullfile(defaultFolder, defaultName);

    % Show Save dialog with default location/name
    [file, path] = uigetfile('*.mat', 'Select a file to load',defaultFull);

    if isequal(file, 0) || isequal(path, 0)
        disp('User canceled load.');
	else




        % Load the data
		load(fullfile(path, file), 'menuStruct'); % specify variables to save
		fprintf('Loaded data from %s\n', fullfile(path, file));

		% Delete old menu options and delete all existing plots
		allChildren = get(figHandle,'Children');
		for ith_child = 1:length(allChildren)
			thisChildHandle = allChildren(ith_child);
			if isgraphics(thisChildHandle, 'uimenu') && ~strcmp(thisChildHandle.Text,'Data')
				delete(thisChildHandle);
			elseif isa(thisChildHandle, 'matlab.graphics.axis.GeographicAxes')
				subChildren = get(thisChildHandle,'Children');
				for ith_subChild = 1:length(subChildren)
					delete(subChildren(ith_subChild));
				end
			end
		end

		% Plot one point (empty) to force plot to remain
		currentCenter = get(gca,'MapCenter');
		currentZoom = get(gca,'ZoomLevel');
		hTempPlot = fcn_plotRoad_plotLL(currentCenter,[],figHandle);
		set(hTempPlot,'Visible','off');
		set(gca,'ZoomLevel',currentZoom);

		% Update the menu options
		lines = menuStruct.selfLines;
		tempStruct = fcn_INTERNAL_createMenusFromLines(figHandle, lines); 

		% Copy the data plots into the new menu structure
		allFields = fieldnames(menuStruct);
		for ith_field = 1:length(allFields)
			thisField = allFields{ith_field};
			if isfield(tempStruct, thisField) && isstruct(tempStruct.(thisField))
				% Loop through all the children
				allSubFields = fieldnames(menuStruct.(thisField));
				for ith_subfield = 1:length(allSubFields)
					thisSubfield = allSubFields{ith_subfield};
					if isstruct(menuStruct.(thisField).(thisSubfield))

						tempSubStructure = menuStruct.(thisField).(thisSubfield);
						newPlotHandle = fcn_GetUserInputPath_updateDrawing(tempSubStructure.selfData, tempSubStructure.selfDrawingType, [], (figHandle));
						set(newPlotHandle,'Color',tempSubStructure.selfColor);
						set(newPlotHandle,'LineWidth',tempSubStructure.selfSize);

						% Update all the fields
						tempStruct.(thisField).(thisSubfield).selfIsVisible = menuStruct.(thisField).(thisSubfield).selfIsVisible;
						tempStruct.(thisField).(thisSubfield).selfData = menuStruct.(thisField).(thisSubfield).selfData;
						tempStruct.(thisField).(thisSubfield).selfDataFlagDataHasChanged = true;
						tempStruct.(thisField).(thisSubfield).selfDataHandleToDataPlot = newPlotHandle;
					end
				end
			else
				% Copy over directly
				tempStruct.(thisField) = menuStruct.(thisField);
			end
		end

		menuStruct = tempStruct;

		% Save results
		set(figHandle,'UserData',menuStruct);

		% Draw results
		fcn_INTERNAL_drawDataOntoPlot(figHandle, [], [], true)

		% Set the display
		[ymin, xmin, ymax, xmax, zoomLevel] = fcn_INTERNAL_parseBBoxFilename(file);

		% Set display limits
		set(gca,'MapCenter',[(ymin+ymax)/2 (xmin+xmax)/2],'ZoomLevel',zoomLevel);

    end
else
    disp('Save canceled via menu.');
end

end % Ends fcn_INTERNAL_fileLoad

%% fcn_INTERNAL_parseBBoxFilename
function [ymin, xmin, ymax, xmax, zoomLevel] = fcn_INTERNAL_parseBBoxFilename(filename)
% PARSEBBOXFILENAME Decodes an N/S/E/W formatted filename into numeric lat/lon coordinates.
%
% Output Order:
%   ymin = South Lat, xmin = West Lon, ymax = North Lat, xmax = East Lon
%
% EXAMPLE:
% % Example filename string
% myFile = '40.3521N_79.9142W_40.4015N_79.8511W.geojson';
% 
% % Decode back to raw geographic numbers
% [ymin, xmin, ymax, xmax] = fcn_INTERNAL_parseBBoxFilename(myFile);
% 
% % Display results
% fprintf('Bounding Box:\n');
% fprintf('  South (ymin): %.4f\n', ymin);
% fprintf('  West  (xmin): %.4f\n', xmin);
% fprintf('  North (ymax): %.4f\n', ymax);
% fprintf('  East  (xmax): %.4f\n', xmax);
% 
% % Outputs:
% % Bounding Box:
% %   South (ymin): 40.3521
% %   West  (xmin): -79.9142
% %   North (ymax): 40.4015
% %   East  (xmax): -79.8511
%
% Why This Method Is Robust
% File Separation: The use of fileparts ensures
% the code won't break if your filename still has a directory path (e.g.,
% C:/Data/40.3521N...) or an extension attached to it.
% 
% Regex Protection: The regular expression tokenizes the pattern
% dynamically, meaning it will still work perfectly even if your
% coordinates change in precision (e.g., switching from 4 decimal places to
% 6 decimal places later on).

% 1. Strip out the file path and extension to isolate just the coordinate string
[~, nameOnly, ~] = fileparts(filename);

% 2. Parse the 4 coordinate tokens using Regular Expressions
% Looks for: [digits and decimals] followed by [N, S, E, or W]
tokens = regexp(nameOnly, '([\d.]+)([NSEW])', 'tokens');

% Validate that we found exactly 4 coordinates
if length(tokens) ~= 4
	error('Filename format invalid. Expected 4 directional coordinate blocks.');
end

% 3. Extract and convert each bounding box limit
ymin = fcn_INTERNAL_parseCoord(tokens{1}); % Southernmost Lat
xmin = fcn_INTERNAL_parseCoord(tokens{2}); % Westernmost Lon
ymax = fcn_INTERNAL_parseCoord(tokens{3}); % Northernmost Lat
xmax = fcn_INTERNAL_parseCoord(tokens{4}); % Easternmost Lon

% 4. Extract the Zoom level
tokens = regexp(nameOnly, '_([\d.]+)', 'tokens');
zoomLevel = str2double(tokens{end});

end % Ends fcn_INTERNAL_parseBBoxFilename

%% fcn_INTERNAL_parseCoord
function val = fcn_INTERNAL_parseCoord(token)
% Helper function to apply the negative multiplier based on direction
numPart = str2double(token{1});
direction = token{2};

if strcmp(direction, 'S') || strcmp(direction, 'W')
	val = -numPart;
else
	val = numPart;
end
end % Ends fcn_INTERNAL_parseCoord

%% fcn_INTERNAL_isValidWindowsFilename
function [isValid, reason] = fcn_INTERNAL_isValidWindowsFilename(name, varargin)
% isValidWindowsFilename  Validate Windows filename (and optional full path)
%   [isValid, reason] = fcn_INTERNAL_isValidWindowsFilename(name)
%   [isValid, reason] = fcn_INTERNAL_isValidWindowsFilename(name, 'CheckPath',true, 'BasePath',C)
%
% Options:
%   'CheckPath' (default false)  - if true, checks full path length against MAX_PATH
%   'BasePath'  (default pwd)    - base folder to combine with name when checking full path
%
% Returns:
%   isValid - logical
%   reason  - empty if valid, otherwise short explanation
%
% USAGE EXAMPLES
% [ok, why] = isValidWindowsFilename('myFile.txt')
% [ok, why] = isValidWindowsFilename('CON.txt')
% [ok, why] = isValidWindowsFilename('aVeryLongNameThatShouldntBeUsedBecauseItIsWayTooLongAndWouldCauseIssuesWhenSavingBecauseWindowsCannotHandleLongNames','.CheckPath',true,'BasePath',pwd)

% Parse inputs
p = inputParser;
addRequired(p,'name',@ischar);
addParameter(p,'CheckPath',false,@islogical);
addParameter(p,'BasePath',pwd,@ischar);
parse(p,name,varargin{:});
name = p.Results.name;
checkPath = p.Results.CheckPath;
basePath = p.Results.BasePath;

% Quick type/empty check
if isempty(name)
	isValid = false;
	reason = 'Name is empty.';
	return
end

% 1) Disallow path separators in name (this checks a single filename, not a path)
if any(name==filesep) || any(name=='/') || any(name=='\')
	isValid = false;
	reason = 'Name contains path separators. Use only a file name, not a path.';
	return
end

% 2) Invalid characters
invalidChars = '<>:"/\\|?*'; % characters Windows forbids in file names
if any(ismember(name, invalidChars))
	isValid = false;
	reason = sprintf('Contains invalid characters: %s', invalidChars);
	return
end

% 3) Control characters (ASCII 0-31) not allowed
if any(double(name) < 32)
	isValid = false;
	reason = 'Contains control characters (ASCII < 32).';
	return
end

% 4) Reserved device names (CON, PRN, AUX, NUL, COM1..COM9, LPT1..LPT9)
[~, base, ~] = fileparts(name);
upperBase = base;
reserved = {'CON','PRN','AUX','NUL'};
for k=1:9, reserved{end+1} = sprintf('COM%d',k); reserved{end+1} = sprintf('LPT%d',k); end %#ok<AGROW>
if any(strcmpi(upperBase, reserved))
	isValid = false;
	reason = 'Reserved device name (e.g., CON, COM1).';
	return
end

% 5) Trailing space or dot is invalid
if ~isempty(name) && (name(end)==' ' || name(end)=='.')
	isValid = false;
	reason = 'Name ends with a space or a dot.';
	return
end

% 6) Component length (NTFS limit 255 bytes/characters)
% Use characters as approximation; for Unicode byte-length may vary.
maxComponentLength = 255;
if length(name) > maxComponentLength
	isValid = false;
	reason = sprintf('File name component too long (>%d chars).', maxComponentLength);
	return
end

% 7) Optional full path length check (MAX_PATH 260 historically)
if checkPath
	fullPath = fullfile(basePath, name);
	% Historically Windows MAX_PATH = 260 (including null). Many systems allow longer
	MAX_PATH = 260;
	if length(fullPath) >= MAX_PATH
		isValid = false;
		reason = sprintf('Full path length >= %d characters (may exceed MAX_PATH).', MAX_PATH);
		return
	end
end

isValid = true;
reason = '';
end % Ends fcn_INTERNAL_isValidWindowsFilename


%% fcn_INTERNAL_createMenusFromLines
function menuStruct = fcn_INTERNAL_createMenusFromLines(figHandle, lines)
% Maps to store handles:
% mainMap('Label') = uimenu handle
% subMap('Parent_Child') = uimenu handle (child)

mainMap = containers.Map('KeyType','char','ValueType','any');
subMap  = containers.Map('KeyType','char','ValueType','any');

menuStruct = struct;

for i = 1:numel(lines)
    line = lines(i);
    lineParts = split(line,',');
    if size(lineParts,1)~=5
        error('Expected 5 elements in each line definition of a menu item');
    end

    % Break line parts into meaningful strings
    % Format:
    % menuName, defaultColorAs1x3, defaultSize, required (anything else is NOT required), patch or segment or points

    menuName = strtrim(char(lineParts(1)));
    defaultColor = eval(lineParts(2));
    defaultSize = eval(lineParts(3));
    isRequiredString = strtrim(char(lineParts(4)));
    drawingType = strtrim(char(lineParts(5)));

    menuParts = split(menuName, "_");       % split on underscore
    np = numel(menuParts);

    switch np
        case 1  % top-level menu
            parentKey = char(menuParts(1));
            if ~isKey(mainMap, parentKey)
                flagSubmenusExist = any(contains(lines,cat(2,parentKey,'_')));
                fullKey = parentKey;
                [mainMap(parentKey), menuStruct] = fcn_INTERNAL_addMenuInfo(figHandle, menuStruct, parentKey, defaultColor, defaultSize, isRequiredString, drawingType, flagSubmenusExist, fullKey);
            end

        case 2  % submenu under top-level
            parentKey = char(menuParts(1));
            childKey  = char(menuParts(2));

            % Ensure parent exists
            if ~isKey(mainMap, parentKey)
                flagSubmenusExist = any(contains(lines,cat(2,parentKey,'_')));
                fullKey = parentKey;
                [mainMap(parentKey), menuStruct] = fcn_INTERNAL_addMenuInfo(figHandle, menuStruct, parentKey, defaultColor, defaultSize, isRequiredString, drawingType, flagSubmenusExist, fullKey);
            end
            parentHandle = mainMap(parentKey);

            childMapKey = [parentKey '_' childKey];
            if ~isKey(subMap, childMapKey)
                flagSubmenusExist = any(contains(lines,cat(2,childMapKey,'_')));
                fullKey = cat(2,parentKey,'.',childKey);
                [subMap(childMapKey), menuStruct.(parentKey)] = fcn_INTERNAL_addMenuInfo(parentHandle, menuStruct.(parentKey), childKey, defaultColor, defaultSize, isRequiredString, drawingType, flagSubmenusExist, fullKey);
            end

        case 3  % sub-submenu (grandchild)
            parentKey = char(menuParts(1));
            childKey  = char(menuParts(2));
            grandKey  = char(menuParts(3));

            % Ensure parent exists
            if ~isKey(mainMap, parentKey)
                flagSubmenusExist = any(contains(lines,cat(2,parentKey,'_')));
                fullKey = parentKey;
                [mainMap(parentKey), menuStruct] = fcn_INTERNAL_addMenuInfo(figHandle, menuStruct, parentKey, defaultColor, defaultSize, isRequiredString, drawingType, flagSubmenusExist, fullKey);
            end
            parentHandle = mainMap(parentKey);

            % Ensure child exists (as submenu)
            childMapKey = [parentKey '_' childKey];
            if ~isKey(subMap, childMapKey)
                flagSubmenusExist = any(contains(lines,cat(2,childMapKey,'_')));
                fullKey = cat(2,parentKey,'.',childKey);
                [subMap(childMapKey), menuStruct.(parentKey)] = fcn_INTERNAL_addMenuInfo(parentHandle, menuStruct.(parentKey), childKey, defaultColor, defaultSize, isRequiredString, drawingType, flagSubmenusExist, fullKey);
            end
            childHandle = subMap(childMapKey);

            % Create grandchild under child
            % uimenu(childHandle, 'Text', grandKey);
            flagSubmenusExist = false;
            fullKey = cat(2,parentKey,'.',childKey,'.',grandKey);
            [~, menuStruct.(parentKey).(childKey)] = fcn_INTERNAL_addMenuInfo(childHandle, menuStruct.(parentKey).(childKey), grandKey, defaultColor, defaultSize, isRequiredString, drawingType, flagSubmenusExist, fullKey);

        otherwise
            % Ignore deeper levels or malformed lines
            warning('Ignoring line with %d parts: %s', np, line);
    end
end
end % Ends fcn_INTERNAL_createMenusFromLines

%% fcn_INTERNAL_tileImages
function fcn_INTERNAL_tileImages(listing, varargin)
% tileImages  Display images from a dir listing or list of filenames in a tiled view
%
% a compact, robust function that accepts a directory listing (the struct
% returned by dir), or a cell/char array of filenames, reads the images,
% and displays them in a tiled view using tiledlayout + imshow. It handles
% full paths (dir with folder field), optional max tiles per row, and skips
% unreadable files.
% 
% fcn_INTERNAL_tileImages(listing)
% fcn_INTERNAL_tileImages(listing, 'MaxCols', 5, 'Title', 'My Images')
%
% listing can be:
%  - struct array as returned by dir('*.jpg') (uses listing.name and listing.folder if present)
%  - cell array of filenames
%  - char vector filename (single file)
%
% Name-Value:
%  'MaxCols' (positive integer, default 5)  - maximum columns per row
%  'Title'   (char)                        - optional overall title
%
% Usage examples:
% Using dir output:
% 
%   listing = dir('*.jpg');
%   fcn_INTERNAL_tileImages(listing, 'MaxCols', 6, 'Title', 'Photos');
% Using explicit file list:
% 
%   files = {'C:\images\a.jpg', 'C:\images\b.jpg'};
%   fcn_INTERNAL_tileImages(files);

% Parse inputs
p = inputParser;
addRequired(p,'listing');
addParameter(p,'MaxCols',5,@(x)isnumeric(x)&&isscalar(x)&&x>0);
addParameter(p,'Title','',@ischar);
parse(p,listing,varargin{:});
maxCols = round(p.Results.MaxCols);
ttl = p.Results.Title;

% Normalize to cell array of full file paths
files = {};
if isstruct(listing)
    if isempty(listing)
        warning('Listing is empty. Nothing to display.'); return
    end
    if isfield(listing,'folder')
        for k = 1:numel(listing)
            files{end+1} = fullfile(listing(k).folder, listing(k).name); %#ok<AGROW>
        end
    else
        for k = 1:numel(listing)
            files{end+1} = listing(k).name; %#ok<AGROW>
        end
    end
elseif iscell(listing)
    files = listing;
elseif ischar(listing)
    files = {listing};
else
    error('Unsupported listing type.');
end

% Filter out directories and non-existing files
existsMask = cellfun(@(f) exist(f,'file')==2, files);
if ~all(existsMask)
    missing = files(~existsMask);
    warning('Some files not found and will be skipped (%d):\n%s', numel(missing), strjoin(missing,', '));
    files = files(existsMask);
end
if isempty(files)
    warning('No valid image files to display.'); return
end

% Read images and record sizes; skip unreadable files
imgs = cell(1,numel(files));
validIdx = false(1,numel(files));
for k = 1:numel(files)
    try
        imgs{k} = imread(files{k});
        validIdx(k) = true;
    catch
        warning('Failed to read %s — skipping.', files{k});
    end
end
imgs = imgs(validIdx);
files = files(validIdx);
n = numel(imgs);
if n==0, warning('No readable images.'); return; end

% Determine grid
nCols = min(maxCols, n);
nRows = ceil(n / nCols);

% Create tiled layout and show images
f = figure('Name','Image Tiles','NumberTitle','off'); %#ok<NASGU>
t = tiledlayout(nRows, nCols, 'Padding','compact', 'TileSpacing','compact');

for k = 1:n
    ax = nexttile;
    try
        imshow(imgs{k}, 'Parent', ax);
    catch
        % fallback: use image + axis equal/off
        image(ax, imgs{k});
        axis(ax, 'image', 'off');
    end
    [~,nm,ext] = fileparts(files{k});
    title(ax, [nm ext], 'Interpreter','none', 'FontSize',8);
end

% Fill remaining tiles (optional) with blank axes
for k = n+1 : nRows*nCols
    ax = nexttile;
    axis(ax,'off');
end

if ~isempty(ttl)
    title(t, ttl, 'FontWeight','bold');
end
end % Ends fcn_INTERNAL_tileImages
