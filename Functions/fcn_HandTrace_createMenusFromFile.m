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

if flagSubmenusExist
	% Add toggle buttons
	handleShowOnFig = uimenu(childHandle, 'Text', 'Show Category', ...
		'Checked', 'on', ...
		'MenuSelectedFcn', @toggleShowInfo);
else
	% Add toggle buttons
	handleShowOnFig = uimenu(childHandle, 'Text', 'Show on Figure', ...
		'Checked', 'on', ...
		'MenuSelectedFcn', @toggleShowInfo);

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
outputStruct.(childText).selfData = [];
outputStruct.(childText).selfDataFlagDataHasChanged = 1;
outputStruct.(childText).selfDataHandleToDataPlot = [];

end % Ends fcn_INTERNAL_addMenuInfo

%%
function toggleShowInfo(src, ~)
% Toggle the Checked property and the local state
if strcmp(src.Checked, 'on')
    src.Checked = 'off';
    showInfo = false;
else
    src.Checked = 'on';
    showInfo = true;
end

% For debugging:
if 1==0
    disp(['Show Info is now: ', string(showInfo)]);
end
end

%% fcn_INTERNAL_updateData
function  fcn_INTERNAL_updateData(src, event, fullKey) 

% Updates data being shown on a given menu. Saves the results into the
% 'UserData' area of the current figure, as a structure.

% Get the parent figure. This is done by recursively going "up" each parent
% until a figure type handle is found.
p = get(src,'Parent');
while ~isempty(p) && ~isgraphics(p,'figure')
	p = get(p,'Parent');
end
figHandle = p; % empty if no figure found


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
newSubStructure.selfData = newSelfData;
fcn_INTERNAL_saveDataIntoFigure(figHandle, newSubStructure, parts)

% Redraw
fcn_INTERNAL_drawDataOntoPlot(src, event, fullKey)

end

%% fcn_INTERNAL_showExamples
function  fcn_INTERNAL_showExamples(src, event, fullKey) %#ok<INUSD>

% % Shows examples for a given menu choice
% 
% % Get the parent figure
% p = get(src,'Parent');
% while ~isempty(p) && ~isgraphics(p,'figure')
% 	p = get(p,'Parent');
% end
% figHandle = p; % empty if no figure found
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

% Get the parent figure
p = get(src,'Parent');
while ~isempty(p) && ~isgraphics(p,'figure')
	p = get(p,'Parent');
end
figHandle = p; % empty if no figure found

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

        % Is this substructure NOT the root?
        if length(parts)>1
            subStructure = getfield(menuStruct, parts{2:end});
            % Is this menu plotted?
            if flagsShowMenuData(ith_struct,1)

				flagUpdatePlot = false;
				% Does this item need to be updated?
				if isfield(subStructure,'selfDataFlagDataHasChanged') 
					if subStructure.selfDataFlagDataHasChanged
						flagUpdatePlot = true;
					end
				else
					flagUpdatePlot = true;
				end

				if flagUpdatePlot
					% Grab the data to plot
					pathXY = subStructure.selfData;

					% Grab the input type
					inputType = subStructure.selfDrawingType;

					% Grab the handle for this data previously plotted
					hPoints = subStructure.selfDataHandleToDataPlot;

					% Update the plot with the new data
					hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figHandle));

					% Update the handle to the plotted data
					subStructure.selfDataHandleToDataPlot = hPoints;

					% Update the flag so it isn't replotted until another
					% change
					subStructure.selfDataFlagDataHasChanged = 0;

					% Save results into the figure data
					newSubStructure = subStructure;
					newSubStructure.selfData = newSelfData;
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

% Save the new substructure into the figure data
newMenuStruct = setfield(menuStruct,parts{:},newSubStructure);

% Push the new figure data back into the figure
set(figHandle,'UserData',newMenuStruct);
end % Ends fcn_INTERNAL_saveDataIntoFigure