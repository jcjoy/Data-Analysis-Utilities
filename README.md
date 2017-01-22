# Data-Analysis-Utilities
A sampling of code that I've made to make analyzing data quicker and simplier

Files:
- axisFunc.m (01-21-2017): MATLAB function which allows a user to perform transformations on data in a given axis
- editingFig.m (01-21-2017): MATLAB function which takes in axis properties and returns the handles to a figure and a set of
axes with these properties. It also binds a pushbutton to the figure, which I've primarily used in creating scripts that require data brushing, etc. For example, scripts which use this function typically plot data from files in a given directory, but will be instructed to wait until the button in the figure is pressed in order to proceed. This allows for manual inspection of large amounts of data without rewriting the same code over and over again.

