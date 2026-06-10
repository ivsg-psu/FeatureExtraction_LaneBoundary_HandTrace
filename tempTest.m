s(1).a.x = 1;
s(1).a.y = struct('m',10);
s(2).a.x = 2;
s(2).b = struct('z',3);
[nodes, edges] = structHierarchy(s, 's')


function [nodes, edges] = structHierarchy(s, rootName)
% structHierarchy  List parent/child relationships for nested structures.
%   [NODES, EDGES] = structHierarchy(S) returns all node paths and edges.
%   [NODES, EDGES] = structHierarchy(S, ROOTNAME) uses ROOTNAME as top path.
%
%   Node path examples:
%     'mystruct'                     (scalar struct)
%     'mystruct.field'               (field)
%     'mystruct(2).field.subfield'   (struct array element)
%
%   EDGES is Mx2 cell array: {parentPath, childPath}.

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
            nodes{end+1,1} = path; %#ok<AGROW>
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
