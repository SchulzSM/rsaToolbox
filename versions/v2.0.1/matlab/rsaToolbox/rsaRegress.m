%rsaRegress.m is part of the RSA calibration toolbox,
%a set of programs for correcting RSA for influences from respiratory rate.
%The toolbox is based on an algorithm published in Ritz & Dahme (2006).
%
%rsaRegress.m - part of rsaToolbox v2.0.1 - Copyright (C) 2006  Stefan M. Schulz
%
%This toolbox is free software; you can redistribute it and/or
%modify it under the terms of the GNU Lesser General Public
%License as published by the Free Software Foundation; either
%version 2.1 of the License, or (at your option) any later version.
%This toolbox is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%Lesser General Public License for more details.
%You should have received a copy of the GNU Lesser General Public
%License along with this library; if not, write to the Free Software
%Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA
%
%Please keep this header in the file.
%We'd appreciate if you document any changes you make as well as your authorship.
%If your update includes major changes, please send a copy to <schulz@psychologie.uni-wuerzburg.de>
%Please, feel free to contact me for any questions, or suggestions.
%ThanX!
%
%===================================================================================================
%function [intercept,slope,df,p,R2]=rsaRegress(RV,TTOTCal,externalRegression,internalRegression);
%
%Part of rsaToolbox - regression for RSA breathing correction
%===================================================================================================

function [intercept,slope,df,p,R2]=rsaRegress(RV,TTOTCal,externalRegression,internalRegression,printMethodSelection);

if nargin < 3
	externalRegression=1;
end;

[r1,c1]=size(RV);
[R2,c2]=size(TTOTCal);
if c1~=c2
	slope='Error in rsaRegress.m';intercept ='Error in rsaRegress.m';df='Error in rsaRegress.m';p='Error in rsaRegress.m';R2='Error in rsaRegress.m';
	return;
end;

tempRVCol=[];
tempTTOTCalCol=[];
for n=1:c1
	tempRV=RV(:,n);
	tempTTOTCal=TTOTCal(:,n);
	tempRV(isnan(tempRV))=[];
	tempTTOTCal(isnan(tempTTOTCal))=[];
	%collate calibration epochs for regression
	tempRVCol=cat(1,tempRVCol,tempRV);
  	tempTTOTCalCol=cat(1,tempTTOTCalCol,tempTTOTCal);
end;

if externalRegression==1
	dlmwrite('DataForExternalRegression_RSA_upon_VT_and_TTOT.csv',[tempRVCol,tempTTOTCalCol],',');
end;

if internalRegression==1
    [intercept,slope,R2,F,p]=rsaToolboxRegression(tempRVCol,[ones(length(tempTTOTCalCol(:,1)),1),tempTTOTCalCol]);
	df=length(tempRVCol(:,1))-length(tempTTOTCalCol(1,:))-1; %degrees of freedom
else
	intercept=NaN;
	slope=NaN;
	df=NaN;
	p=NaN;
	R2=NaN;
end;

hold off;
scatter(tempTTOTCalCol,tempRVCol);
hold on;
tempAx=axis;

xlimits = get(gca,'Xlim');
ylimits = get(gca,'Ylim');
np = get(gcf,'NextPlot');
set(gcf,'NextPlot','add');
xdat = xlimits;
ydat = intercept + slope.*xdat;
maxy = max(ydat);
miny = min(ydat);
if maxy > ylimits(2)
  if miny < ylimits(1)
     set(gca,'YLim',[miny maxy]);
  else
     set(gca,'YLim',[ylimits(1) maxy]);
  end;
else
  if miny < ylimits(1)
     set(gca,'YLim',[miny ylimits(2)]);
  end;
end;
h = line(xdat,ydat);
set(h,'LineStyle','-');
set(gcf,'NextPlot',np);

hold off;

if printMethodSelection~=1
    switch printMethodSelection
    case 1
        printFigureToType='DoNotPrintFigure';
    case 2
        printFigureToType='-depsc2';
    case 3
        printFigureToType='-deps2';
    case 4
        printFigureToType='-dbmp';
    case 5
        printFigureToType='-dbmpmono';
    case 6
        printFigureToType='-djpeg';
    case 7
        printFigureToType='-dtiff';
    case 8
        printFigureToType='-dmeta';
    end;
    %create new figure
    newfigure = figure;
    hold off;
    scatter(tempTTOTCalCol,tempRVCol);
    hold on;
    xlabel('TTOT [s]');
    ylabel('RSA/VT [ms/l]');
    title('Regression of paced breathing RSA/VT upon TTOT');
    tempAx=axis;

    xlimits = get(gca,'Xlim');
    ylimits = get(gca,'Ylim');
    np = get(gcf,'NextPlot');
    set(gcf,'NextPlot','add');
    xdat = xlimits;
    ydat = intercept + slope.*xdat;
    maxy = max(ydat);
    miny = min(ydat);
    if maxy > ylimits(2)
        if miny < ylimits(1)
             set(gca,'YLim',[miny maxy]);
        else
             set(gca,'YLim',[ylimits(1) maxy]);
        end;
    else
        if miny < ylimits(1)
             set(gca,'YLim',[miny ylimits(2)]);
        end;
    end;
    h = line(xdat,ydat);
    set(h,'LineStyle','-');
    set(gcf,'NextPlot',np);

    hold off;
    %print the new figure
    print(newfigure,printFigureToType,'RegressionPlot');
    % close the new figure
    close(newfigure)
end;
