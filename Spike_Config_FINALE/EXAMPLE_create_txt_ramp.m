%%Simple script to create a matrix with 2 columns to be plotted in Spike2 as a trace
% Col 1 = x (time points), Col 2 = y (whatever)
%%%%%
% © Paolo Tecchio
% Email: paolo.tecchio@rub.de

%must be columns
%x points or time points
matrix(:,1) = linspace(0,12,75); 

%y points 
matrix(:,2) = sin(matrix(:,1))*20; %20 is the amplitude
matrix = round(matrix,2);
plot(matrix(:,1),matrix(:,2));

%save the txt
[fname,pth] = uiputfile('*.txt'); % Type in name of the file.
writematrix(matrix,[pth fname]);




