function axisFunc(a,varargin)
% AXISFUNC(a,varargin) allows a user to perform a functional change to the
% data stored in an axis's children.

% Notes:
% (1) Any additional arguments supplied in consective 'field',value pairs
% will simply be treated as set(a,'field',value)
% (2) To quickly change the labels of axes, putting in the field,value
% combination 'xlabel',str; 'ylabel',str'; or 'title',str will change the
% string associated with the respective axis label.

% Get all children of the axis corresponding to plot objects
c = get(a,'children');
c = c(~strcmp(get(c,'tag'),'Legend'));
for ii = (1:2:length(varargin))
   switch lower(varargin{ii})
       case 'x'
           arrayfun(@(y)set(y,'xdata',varargin{ii+1}(get(y,'xdata'))),...
               c,'uniformoutput',1);
       case 'y'
           arrayfun(@(y)set(y,'ydata',varargin{ii+1}(get(y,'ydata'))),...
               c,'uniformoutput',1);
       case 'xlabel'
           set(get(a,'xlabel'),'string',varargin{ii+1})
       case 'ylabel'
           set(get(a,'ylabel'),'string',varargin{ii+1})
       case 'title'
           set(get(a,'title'),'string',varargin{ii+1})
       otherwise
           try
               set(a,varargin{ii},varargin{ii+1})
           catch
               disp(sprintf('Argument %d: Key Value pair incorrect',ii))
   end
end

end