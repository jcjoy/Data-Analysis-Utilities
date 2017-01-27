%{
Name: getScaleBar.m
Author: James C. Joy
Date: 01-25-2017
%}

function ppl = getScaleBar(image)
% SCALEBAR takes an image, asks the user to input the length of the
% scalebar, then asks a user to select two points on the image that
% represents the length, and returns the number of pixels per unit len

% Set up a figure and axes to display the image
figure('windowstyle','docked');
axes('fontsize',16,'box','on','plotboxaspectratio',[1 1 1]);
% Display the image with a grayscale colormap
imagesc(image);colormap gray;
hold on;
while true
    % Ask the user to input the length of the scalebar
    len = input('What is the length of the scalebar? ');
    if isnumeric(len)
        break
    else
       disp('Please enter a number!'); 
    end
end
% Set up a loop to allow the user to select the scalebar
while true
% Ask the user for to choose the endpoints of the scalebar in the image
    disp('Please choose the endpoints of the scalebar: ');
    [X,Y] = ginput(2);
    yAvg = mean(Y);
    pl = plot(X,[yAvg;yAvg],'r-','linewidth',5);
    userResponse = input('Scalebar okay (y/n)? ','s');
    if strcmp(lower(userResponse),'y')
       break 
    else
       delete(pl);
    end
end
% Calculate the conversion between the scalebar and the units chosen
ppl = abs(X(2) - X(1))/len;
% Close the figure
delete(gcf);

end