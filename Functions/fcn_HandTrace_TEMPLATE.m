function varargout = fcn_HandTrace_TEMPLATE(...
    input_path,...
    start_zone_definition,...
    varargin)
%fcn_HandTrace_TEMPLATE
%     fcn_HandTrace_TEMPLATE(path,zone_definition) - gives
%     indices of each lap meeting the zone definition
%
% Given an input of "path" type, breaks data into laps by checking whether
% the data meet particular "zone" conditions to define the meaning of a
% lap. The function returns the indices of each lap as a cell array. Any
% entry and exit portions that are not full laps are also returned as
% optional output arguments. If no laps are detected, then the input path
% is assumed to be only an entry case and the cell_array_of_lap_indices is
% empty.
%
% The zone conditions to specify a lap can be given as either (1) points or
% (2) line segments. These conditions are used to define situations that
% start a lap, ends a lap, or defines an excursion as defined below. The
% end and excursion inputs are optional. If an optional end condition is
% not specified, then the start condition is used for both the start and
% end condition. If the excursion condition is not given, then no
% requirement for this is checked.
%
% The start_zone_definition condition defines how a lap should start,
% namely the conditions wherein the given path is beginning the lap.
% The XY point of the path immediately prior to the start condition
% being met is considered the start of the lap. Note: this can cause
% path indices to be repeated if laps are stacked onto each other after
% partitioning.
%
% The end_zone_definition condition, an optional input, defines how a lap
% should end, namely the conditions wherein the given path is ending
% the lap. The XY point of the path immediately after to the end
% condition being met is considered the end of the lap. Note: this can
% cause indices to be repeated as noted in the start condition.
%
% The excursion_zone_definition condition, an optional input, defines a
% condition that must be met after the start condition and before the end
% condition. This specification allows one to define an area away from the
% start and end condition that must be reached in order for the lap to be
% allowed to end. The end condition immediately after the excursion is
% considered the end of the lap.
%
% Of the two types of conditions, the definitions are as follows:
% (1) For point conditions, the inputs are condition = [radius num_points X
% Y] wherein X and Y specify the XY coordinates for the point, and radius
% specifies the radius from the point that the traversal must pass, and
% num_points specify the number of points that must be in the zone for the
% condition to be met. The minimum distance from the portion of the
% traversal within the radius to the XY point is considered the
% corresponding best condition.
%
% (2) For line segment conditions, the inputs are condition formatted as:
% [X_start Y_start; X_end Y_end] wherein start denotes the starting
% coordinate of the line segment, end denotes the ending coordinate of the
% line segment. For the condition to be met, the traversal must pass
% over the line segment, or directly through one of the end points.
% Further, the traversal must pass in the positive cross-product direction
% through the point, wherein the positive direction is denoted from the
% vector from start to end of the line segment.
%
% FORMAT:
%
%      [cell_array_of_lap_indices, ...
%       (cell_array_of_entry_indices, cell_array_of_exit_indices)] = ...
%      fcn_HandTrace_TEMPLATE(...
%            input_traversal,...
%            start_zone_definition,...
%            (end_zone_definition),...
%            (excursion_zone_definition),...
%            (figNum));
%
% INPUTS:
%
%      input_traversal: the traversal that is to be broken up into laps. It
%      is a traversals type consistent with the Paths library of functions.
%
%      start_zone_definition: the condition, defined as a point/radius or
%      line segment, defining the start condition to break the data into
%      laps. It is of one of two forms. A zone defined by a center point,
%      radius, and number of points that must past through that "circle",
%      given in a 1-row format as:
%
%        [zone_radius zone_num_points zone_center_x zone_center_y] (or)
%        [zone_radius zone_num_points zone_center_x zone_center_y
%        zone_center_z]
%
%      OR, a zone can be given by a segment defined by a start and end
%      point, given by two rows.
%
%        [zone_start_x zone_start_y; zone_end_x zone_end_y]
%      (NOTE: there's no 3-d equivalent of a starting line or finish line)
%
%      (OPTIONAL INPUTS)
%
%      end_zone_definition: the condition, defined as a point/radius or
%      line segment, defining the end condition to break the data into
%      laps. If not specified, the start condition is used. The same type
%      is used as the start_definition.
%
%      excursion_zone_definition: the condition, defined as a point/radius
%      or line segment, defining a situation that must be met between the
%      start and end conditions. If not specified, then no excursion point
%      is used. The same type is used as the start_definition.
%
%      figNum: a figure number to plot results.
%
% OUTPUTS:
%
%      cell_array_of_lap_indices: a cell array containint the indices for
%      each lap
%
%      OPTIONAL OUTPUTS:
%
%      cell_array_of_entry_indices: a structure containing the indices
%      prior to each staring condition, that are not part of a lap.
%
%      cell_array_of_exit_indices: a structure containing the indices after
%      to each ending condition, that are not part of a lap.

%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%      fcn_Laps_checkZoneType
%      fcn_Laps_findPointZoneStartStopAndMinimum
%      fcn_Laps_findSegmentZoneStartStop
%      fcn_DebugTools_debugPrintStringToNCharacters
%
% EXAMPLES:
%
%     See the script: script_test_fcn_HandTrace_TEMPLATE
%     for a full test suite.
%
% This function was written on 2022_07_23 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% 2022_07_23 by Sean Brennan, sbrennan@psu.edu
% - wrote the code originally, using breakDataIntoLaps as starter
% 
% 2025_04_25 by Sean Brennan, sbrennan@psu.edu
% - added global debugging options
% 
% 2025_07_03 by Sean Brennan, sbrennan@psu.edu
% - cleanup of Debugging area codes
% - turn on fast mode for Path calls
% 
% 2025_07_05 by Sean Brennan, sbrennan@psu.edu
% - fixed poorly constructed input area (bad copy)

% TO-DO:
%
% 2025_11_21 by Sean Brennan, sbrennan@psu.edu
% - (fill in items here)



%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 5; % The largest Number of argument inputs to the function
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
    debug_figNum = 999978; 
else
    debug_figNum = []; 
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
        narginchk(2,MAX_NARGIN);

        % Check the input_path to be sure it has 2 or 3 columns, minimum 2 rows
        % or more
        fcn_DebugTools_checkInputsToFunctions(input_path, '2or3column_of_numbers',[2 3]);
    end
end


% The following area checks for variable argument inputs (varargin)

% Does the user want to specify the end_definition?
% Set defaults first:
end_zone_definition = start_zone_definition; % Default case
flag_end_is_a_point_type = flag_start_is_a_point_type; % Inheret the start case
% Check for user input
if 3 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        % Set the end values
        [flag_end_is_a_point_type, end_zone_definition] = fcn_Laps_checkZoneType(temp, 'end_definition', -1);
    end
end

% Does the user want to specify excursion_definition?
flag_use_excursion_definition = 0; % Default case
flag_excursion_is_a_point_type = 1; % Default case
if 4 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        % Set the excursion values
        [flag_excursion_is_a_point_type, excursion_definition] = fcn_Laps_checkZoneType(temp, 'excursion_definition',-1);
        flag_use_excursion_definition = 1;
    end
end

% Does user want to show the plots?
flag_do_plots = 0; % Default is to NOT show plots
if (0==flag_max_speed) && (MAX_NARGIN == nargin) 
    temp = varargin{end};
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp;
        flag_do_plots = 1;
    end
end


%% Main code starts here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Main code goes here

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
if flag_do_plots
    
    % plot the final XY result
    figure(figNum);
    clf;
    
    % Everything put together
    subplot(1,2,1);
    hold on;
    grid on
    title('Results of breaking data into laps');
    
    
    
    % Plot the indices per lap
    all_ones = ones(length(input_path(:,1)),1);
    
    % fill in data
    start_of_lap_x = [];
    start_of_lap_y = [];
    lap_x = [];
    lap_y = [];
    end_of_lap_x = [];
    end_of_lap_y = [];
    for ith_lap = 1:Nlaps
        start_of_lap_x = [start_of_lap_x; cell_array_of_entry_indices{ith_lap}; NaN]; %#ok<AGROW>
        start_of_lap_y = [start_of_lap_y; all_ones(cell_array_of_entry_indices{ith_lap})*ith_lap; NaN]; %#ok<AGROW>;
        lap_x = [lap_x; cell_array_of_lap_indices{ith_lap}; NaN]; %#ok<AGROW>
        lap_y = [lap_y; all_ones(cell_array_of_lap_indices{ith_lap})*ith_lap; NaN]; %#ok<AGROW>;
        end_of_lap_x = [end_of_lap_x; cell_array_of_exit_indices{ith_lap}; NaN]; %#ok<AGROW>
        end_of_lap_y = [end_of_lap_y; all_ones(cell_array_of_exit_indices{ith_lap})*ith_lap; NaN]; %#ok<AGROW>;
    end
    
    % Plot results
    plot(start_of_lap_x,start_of_lap_y,'g-','Linewidth',3,'DisplayName','Prelap');
    plot(lap_x,lap_y,'b-','Linewidth',3,'DisplayName','Lap');
    plot(end_of_lap_x,end_of_lap_y,'r-','Linewidth',3,'DisplayName','Postlap');
    
    h_legend = legend;
    set(h_legend,'AutoUpdate','off');
    
    xlabel('Indices');
    ylabel('Lap number');
    axis([0 length(input_path(:,1)) 0 Nlaps+0.5]);
    
    
    subplot(1,2,2);
    % Plot the XY coordinates of the traversals
    hold on;
    grid on
    title('Results of breaking data into laps');
    axis equal
    
    cellArrayOfPathsToPlot = cell(Nlaps+1,1);
    cellArrayOfPathsToPlot{1,1}     = input_path;
    for ith_lap = 1:Nlaps
        temp_indices = cell_array_of_lap_indices{ith_lap};
        if length(temp_indices)>1
            dummy_path = input_path(temp_indices,:);
        else
            dummy_path = [];
        end
        cellArrayOfPathsToPlot{ith_lap+1,1} = dummy_path;
    end
    h = fcn_Laps_plotLapsXY(cellArrayOfPathsToPlot,figNum);
    
    % Make input be thin line
    set(h(1),'Color',[0 0 0],'Marker','none','Linewidth', 0.75);
    
    % Make all the laps have thick lines
    for ith_plot = 2:(length(h))
        set(h(ith_plot),'Marker','none','Linewidth', 5);
    end
    
    % Add legend
    legend_text = {};
    legend_text = [legend_text, 'Input path'];
    for ith_lap = 1:Nlaps
        legend_text = [legend_text, sprintf('Lap %d',ith_lap)]; %#ok<AGROW>
    end
    
    h_legend = legend(legend_text);
    set(h_legend,'AutoUpdate','off');
    
    
    
    %     % Plot the start, excursion, and end conditions
    %     % Start point in green
    %     if flag_start_is_a_point_type==1
    %         Xcenter = start_zone_definition(1,1);
    %         Ycenter = start_zone_definition(1,2);
    %         radius  = start_zone_definition(1,3);
    %         INTERNAL_plot_circle(Xcenter, Ycenter, radius, [0 .7 0], 4);
    %     end
    %
    %     % End point in red
    %     if flag_end_is_a_point_type==1
    %         Xcenter = end_definition(1,1);
    %         Ycenter = end_definition(1,2);
    %         radius  = end_definition(1,3);
    %         INTERNAL_plot_circle(Xcenter, Ycenter, radius, [0.7 0 0], 2);
    %     end
    %     legend_text = [legend_text, 'Start condition'];
    %     legend_text = [legend_text, 'End condition'];
    %     h_legend = legend(legend_text);
    %     set(h_legend,'AutoUpdate','off');
    
    % Plot start zone
    h_start_zone = fcn_Laps_plotZoneDefinition(start_zone_definition,'g-',figNum);

    % Plot end zone
    h_end_zone = fcn_Laps_plotZoneDefinition(end_zone_definition,'r-',figNum);

    
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends main function

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

% function INTERNAL_plot_circle(center_x, center_y, radius, color, linewidth)
% 
% % Plot the center point
% % plot(center_x,center_y,'ro','Markersize',22);
% 
% % Plot circle
% angles = 0:0.01:2*pi;
% x_circle = center_x + radius * cos(angles);
% y_circle = center_y + radius * sin(angles);
% plot(x_circle,y_circle,'-','color',color,'Linewidth',linewidth);
% end
