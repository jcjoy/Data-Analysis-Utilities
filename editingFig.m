function [f,a] = editingFig(axis_opts)
    f = figure('position',[1,1,750,750]);
    h = uicontrol('Position',[20 20 200 40],'String','Continue',...
        'Callback','uiresume(gcbf)');
    a = axes('position',[0.1300,0.1500,0.7750,0.80],...
        axis_opts{:});

end