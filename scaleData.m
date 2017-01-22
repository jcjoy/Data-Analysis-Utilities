function t0 = scaleData(xData,yData)
% SCALEDATA performs a one-parameter scaling procedure for the data given
% in the cell arrays xData and yData. Each entry in xData must have the
% same length as the corresponding entry in ydata. 
% Additionally, the two cell arrays must have the same length (ie there
% must be the same number of x and y datasets, and the number of x and y
% points must be the same within each dataset)
% t0 is an array whose length is the same as the number of datasets input.
%
% Dependencies:
% lsqspl: Routine written to simplify code for fitting least squares
% splines. See 
% https://www.mathworks.com/help/curvefit/least-squares-approximation-by-natural-cubic-splines.html
% scaleObjective: Function to scale a given dataset to a known function by
% minimizing the sum of squared differences between the function and the
% dataset
% Written by James C. Joy
% 12-08-2016

% Preliminary error checking
% Make sure that both inputs are cell arrays
if ~iscell(xData) || ~iscell(yData)
   error('Input data must be cells with the same length.'); 
end

% Make sure that xData and yData have the same length
if length(xData) ~= length(yData)
   error('Input cell arrays must have the same length.'); 
end
% Initialize the output for speed (probably an unnecessary enhancement
% since a much larger array will hold all of the data. For now, I don't
% plan on enhancing this portion of the algorithm, but I may make this
% modification in the future).
t0 = ones(length(xData),1);
% Set up a figure to do plotting to check the procedure while it runs
f = figure('position',[1 1 750 750]);
a = axes('parent',f,'box','on','fontsize',16,...
    'yscale','lin','xscale','log','yscale','lin');
hold on
xlabel('a*x');
ylabel('y');
title('Scaled Data');
% Get a colormap to distinguish each dataset
clr = jet(length(xData));
% Main loop
for i = 1:length(xData)
    % Case i == 1: define the objective function
    if i == 1
        % Initialize the scaling data
        xScaled = reshape(xData{i},[1,length(xData{i})]);
        yScaled = reshape(yData{i},[1,length(yData{i})]);
        % Plot the data
        plot(xData{i},yData{i},'marker','.','markersize',12,...
            'linestyle','none','color',clr(i,:));
        waitforbuttonpress
        % Find the maximum and minimum for the current xdata to ease the
        % calculation of the interior breakpoints
        xMax = max(xScaled);
        xMin = min(xScaled);
        % Set the number of interior breakpoints
        numBP = 10;
        % Define the breakpoints so that they are logarithmically spaced
        bPoints = logspace(log10(xMin),log10(xMax),numBP + 2);
        bPoints = bPoints(2:end-1);
        % Fit and display the least-square spline
        spl = lsqspl(xScaled(:),yScaled(:),bPoints);
        p1 = plot(logspace(log10(xMin),log10(xMax),100),...
            (ppval(spl,logspace(log10(xMin),log10(xMax),100))),...
            'k-','linewidth',2,'marker','none');
        waitforbuttonpress
    else
        % Find the points that overlap in y
        inds = yData{i} > min((yScaled)) & yData{i} < max((yScaled));
        xCurrent = xData{i}(inds);
        yCurrent = (yData{i}(inds));
        % Set up the objective function to pass to the optimation routine
        objFun = @(x)sum((yCurrent-ppval(spl,xCurrent./x)).^2);
        % Set up the options for the solver
        opts = optimoptions('fminunc','algorithm','quasi-newton',...
            'display','off');
        t0(i) = fminunc(objFun,t0(i-1),opts);
        % Plot the result
        plot(xData{i}./t0(i),yData{i},'marker','.','markersize',12,...
            'linestyle','none','color',clr(i,:));
        waitforbuttonpress
        % Add the data to the scaled data
        xScaled = [xScaled,reshape(xData{i}./t0(i),[1,length(xData{i})])];
        yScaled = [yScaled,reshape(yData{i},[1,length(yData{i})])];
        % Find the new minimum and maximum of the dataset
        xMin = min(xScaled);
        xMax = max(xScaled);
        % Find new breakpoints
        numBP = 10;
        bPoints = logspace(log10(xMin),log10(xMax),12);
        bPoints = bPoints(2:end-1);
        % Fit the new spline
        spl = lsqspl(xScaled(:),(yScaled(:)),bPoints(:));
        % Plot the spline
        delete(p1);
        p1 = plot(logspace(log10(xMin),log10(xMax),100),...
            (ppval(spl,logspace(log10(xMin),log10(xMax),100))),...
            'k-','linewidth',2);
        waitforbuttonpress
    end % end if i == 1
    
end % End of main loop

end % end scaleData