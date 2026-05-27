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
				[mainMap(parentKey), menuStruct] = fcn_INTERNAL_addMenuInfo(figHandle, menuStruct, parentKey, defaultColor, defaultSize, isRequiredString, drawingType, flagSubmenusExist);	
			end

		case 2  % submenu under top-level
			parentKey = char(menuParts(1));
			childKey  = char(menuParts(2));

			% Ensure parent exists
			if ~isKey(mainMap, parentKey)
				flagSubmenusExist = any(contains(lines,cat(2,parentKey,'_')));
				[mainMap(parentKey), menuStruct] = fcn_INTERNAL_addMenuInfo(figHandle, menuStruct, parentKey, defaultColor, defaultSize, isRequiredString, drawingType, flagSubmenusExist);
			end
			parentHandle = mainMap(parentKey);
			
			childMapKey = [parentKey '_' childKey];
			if ~isKey(subMap, childMapKey)
				flagSubmenusExist = any(contains(lines,cat(2,childMapKey,'_')));
				[subMap(childMapKey), menuStruct.(parentKey)] = fcn_INTERNAL_addMenuInfo(parentHandle, menuStruct.(parentKey), childKey, defaultColor, defaultSize, isRequiredString, drawingType, flagSubmenusExist);
			end

		case 3  % sub-submenu (grandchild)
			parentKey = char(menuParts(1));
			childKey  = char(menuParts(2));
			grandKey  = char(menuParts(3));

			% Ensure parent exists
			if ~isKey(mainMap, parentKey)
				flagSubmenusExist = any(contains(lines,cat(2,parentKey,'_')));
				[mainMap(parentKey), menuStruct] = fcn_INTERNAL_addMenuInfo(figHandle, menuStruct, parentKey, defaultColor, defaultSize, isRequiredString, drawingType, flagSubmenusExist);
			end
			parentHandle = mainMap(parentKey);

			% Ensure child exists (as submenu)
			childMapKey = [parentKey '_' childKey];
			if ~isKey(subMap, childMapKey)
				flagSubmenusExist = any(contains(lines,cat(2,childMapKey,'_')));
				[subMap(childMapKey), menuStruct.(parentKey)] = fcn_INTERNAL_addMenuInfo(parentHandle, menuStruct.(parentKey), childKey, defaultColor, defaultSize, isRequiredString, drawingType, flagSubmenusExist);
			end
			childHandle = subMap(childMapKey);

			% Create grandchild under child
			% uimenu(childHandle, 'Text', grandKey);
			flagSubmenusExist = false;
			[~, menuStruct.(parentKey).(childKey)] = fcn_INTERNAL_addMenuInfo(childHandle, menuStruct.(parentKey).(childKey), grandKey, defaultColor, defaultSize, isRequiredString, drawingType, flagSubmenusExist);

		otherwise
			% Ignore deeper levels or malformed lines
			warning('Ignoring line with %d parts: %s', np, line);
	end
end
end

%% fcn_INTERNAL_addMenuInfo
function [childHandle, outputStruct] = fcn_INTERNAL_addMenuInfo(parentHandle, parentStruct, childText, childColor, childSize, childIsRequiredString, childDrawingType, flagSubmenusExist)
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

	mToggle = uimenu(childHandle, 'Text', 'Edit', ...
		'Checked', 'on', ...
		'MenuSelectedFcn', @toggleShowInfo);

	mToggle = uimenu(childHandle, 'Text', 'Show Examples', ...
		'Checked', 'on', ...
		'MenuSelectedFcn', @toggleShowInfo);
end

outputStruct = parentStruct;
outputStruct.(childText).selfColor = childColor;
outputStruct.(childText).selfSize = childSize;
outputStruct.(childText).selfIsRequiredFlag = strcmpi(childIsRequiredString,'required');
outputStruct.(childText).selfDrawingType = childDrawingType;
outputStruct.(childText).selfIsVisible = outputStruct.(childText).selfIsRequiredFlag;
outputStruct.(childText).selfHandle = childHandle;
outputStruct.(childText).selfHandleShowOnFig = handleShowOnFig;

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
