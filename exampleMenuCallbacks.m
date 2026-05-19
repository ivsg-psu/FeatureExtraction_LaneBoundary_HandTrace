function exampleMenuCallbacks()
    % Create a figure
    f = figure('Name','Menu Callbacks Example');

    % Top-level menu (uses named function handle)
    mFile = uimenu(f, 'Text', 'File');
    mOpen = uimenu(mFile, 'Text', 'Open...', ...
                   'MenuSelectedFcn', @onOpenSelected);

    % Submenu (uses nested function so it can modify local state)
    mRecent = uimenu(mFile, 'Text', 'Recent Files');
    mRecent1 = uimenu(mRecent, 'Text', 'recent1.txt', ...
                      'MenuSelectedFcn', @onRecentSelected);

    % Sub-submenu (uses anonymous function)
    mMore = uimenu(mRecent, 'Text', 'More...');
    uimenu(mMore, 'Text', 'recent2.txt', ...
           'MenuSelectedFcn', @(src,evt) disp(['You chose: ' src.Text]));

    % Example state variable toggled by a menu
    showInfo = true;
    mView = uimenu(f, 'Text', 'View');
    mToggle = uimenu(mView, 'Text', 'Show Info', ...
                     'Checked', 'on', ...
                     'MenuSelectedFcn', @toggleShowInfo);

    % ---- Callback implementations ----
    function onOpenSelected(~, ~)
        % Named function: open a file selection dialog
        [file, path] = uigetfile({'*.m;*.txt','Code or Text Files';'*.*','All Files'});
        if isequal(file,0)
            disp('User canceled Open');
        else
            disp(['Opening: ', fullfile(path,file)]);
        end
    end

    function onRecentSelected(src, ~)
        % Nested function: can access variables like showInfo
        msg = sprintf('Selected recent file: %s. showInfo=%d', src.Text, showInfo);
        disp(msg);
    end

    function toggleShowInfo(src, ~)
        % Toggle the Checked property and the local state
        if strcmp(src.Checked, 'on')
            src.Checked = 'off';
            showInfo = false;
        else
            src.Checked = 'on';
            showInfo = true;
        end
        disp(['Show Info is now: ', string(showInfo)]);
    end
end
