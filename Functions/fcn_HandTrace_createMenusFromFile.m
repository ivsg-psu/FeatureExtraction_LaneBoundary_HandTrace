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

% Read all lines as a string array
lines = readlines(filename);
lines = strtrim(lines);              % trim whitespace
lines = lines(~(lines == ""));       % remove empty lines

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

% Save results
set(figHandle,'UserData',menuStruct);

% Draw results
fcn_INTERNAL_drawDataOntoPlot(figHandle, [], [])

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
        'Callback', @(src,event) fcn_INTERNAL_showExamples(src, event, fullKey));
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
fcn_INTERNAL_drawDataOntoPlot(src, [], [])
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
flagShowInfo = fcn_INTERNAL_flipMenuText(src.Parent.Children(3));

% Save results back into figure
newSubStructure.selfData = newSelfData;
fcn_INTERNAL_saveDataIntoFigure(figHandle, newSubStructure, parts)

% Redraw the plot
fcn_INTERNAL_drawDataOntoPlot(src, event, fullKey)

end

%% fcn_INTERNAL_showExamples
function  fcn_INTERNAL_showExamples(src, event, fullKey) %#ok<INUSD>

% % Shows examples for a given menu choice
%
% % Get the figure handle
% figHandle = fcn_INTERNAL_getFigHandleFromSource(src);
%
% menuStruct = get(figHandle,'UserData');
% parts = strsplit(fullKey, '.');
% subStructure = getfield(menuStruct, parts{:});
% inputType = subStructure.selfDrawingType;
% startingXY = subStructure.selfData;
%
% % Save changes back into the figure
%
% % Query changes from user
% newSelfData = fcn_GetUserInputPath_getUserInputPath((startingXY),(figHandle),(inputType));
%
% % Create a new substructure based on this one
% newSubStructure = subStructure;
% newSubStructure.selfData = newSelfData;
%
% % Save the new substructure into the figure data
% newMenuStruct = setfield(menuStruct,parts{:},newSubStructure);
%
% % Push the new figure data back into the figure
% set(figHandle,'UserData',newMenuStruct);
end


%% fcn_INTERNAL_drawDataOntoPlot
function fcn_INTERNAL_drawDataOntoPlot(src, event, fullKey) %#ok<INUSD>

% Plots all the menus and submenu data

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
            if isfield(subStructure,'selfDataFlagDataHasChanged') && subStructure.selfDataFlagDataHasChanged
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