%rsaPeakValleyWindowed.m is part of the RSA calibration toolbox,
%a set of programs for correcting RSA for influences from respiratory rate.
%The toolbox is based on an algorithm published in Ritz & Dahme (2006).
%
%rsaPeakValleyWindowed.m - part of rsaToolbox v2.0.0 - Copyright (C) 2009  Stefan M. Schulz
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
%==================================================================================
%function [IBIno,IBImean,IBImin,IBImax,IBIdiff,IBIdiffType]=rsaPeakValleyWindowed(TTOT,IBI,windowPre,windowPost,IBIflag,infantOption);
%
%Part of rsaToolbox - peak-valley analysis
%==================================================================================

function [IBIno,IBImean,IBImin,IBImax,IBIdiff,IBIdiffType,HRperBreath,IBIcount]=rsaPeakValleyWindowed(TTOT,IBI,windowPre,windowPost,IBIflag,infantOption);

[r1,c1]=size(TTOT);
[r2,c2]=size(IBI);
if c1~=c2
	IBIno='ERROR in rsaPeakValley.m';IBImean='ERROR in rsaPeakValley.m';IBImin='ERROR in rsaPeakValley.m';IBImax='ERROR in rsaPeakValley.m';IBIdiff='ERROR in rsaPeakValley.m';IBIdiffType='ERROR in rsaPeakValley.m';
	return;
end;

IBIminCol=[];
IBImaxCol=[];
IBInoCol=[];
IBImeanCol=[];
IBIdiffCol=[];
IBIdiffTypeCol=[];
IBIcount=[];
for m=1:c1
    tempTTOTCum=cumsum(TTOT{m})*1000; %convert to ms
	tempIBICum=cumsum(IBI{m});%is in ms
	tempIBIflag=IBIflag{m};
	IBImin=[];
	IBImax=[];
	IBIno=[];
	IBImean=[];
	IBIdiff=[];
	IBIdiffType=[];
	tempTTOTCum=cat(1,[0],tempTTOTCum); %add leading zero to reference correctly to VT in the breathing cycle concluded by the respective TTOT
	for n=1:length(tempTTOTCum(:,1))-1
		tempIBIPos=find((tempIBICum>tempTTOTCum(n,1)-windowPre) & (tempIBICum<=tempTTOTCum(n+1,1)+windowPost));
		%infantOption
		if infantOption==1
			if ~isempty(tempIBIPos) & tempIBIPos(1,1)>1
				tempIBIPos=cat(1,tempIBIPos(1,1)-1,tempIBIPos);
			end;
		end;
		tempIBIflagCurrentBreath=tempIBIflag(tempIBIPos);
		tempIBIPos(find(tempIBIflagCurrentBreath==1))=[];
		tempIBIno=length(tempIBIPos);
		%flagging:
        %1=most conservative criterion (=last longest IBI must precede first shortest IBI); note: flags 1 and 2 (as well as flags 5 and 6) only may differ when there are more than one IBI with the exact same length
        %2=most lenient criterion  (=any of the longest IBI must precede any of the shortest IBI) ; note: flags 1 and 2 (as well as flags 5 and 6) only may differ when there are more than one IBI with the exact same length
		%3=exclusion criterion: if only one or no R-peak is found in the current breathing cycle (i.e., not enough IBI)
		%4=exclusion criterion: peak valley criterion (PVC) not met
		%5=most conservative criterion and missing IBI
		%6=most lenient criterion and missing IBI
		%7=exclusion criterion (if only one or no R-peak is found in the current breathing cycle) and missing IBI
		%8=exclusion criterion (PVC not met) and missing IBI
		if tempIBIno>=2 %if set to 1, this means, if minimum and maximum are the same, the data is included, however, IBIdiff=0; change to 2 if you want to exclude this data!; see below!
			tempIBI=diff(tempIBICum);
			tempIBI=tempIBI(tempIBIPos-1);
			tempIBImin=min(tempIBI);
			tempIBIminPos=find(tempIBI==tempIBImin);
			tempIBImax=max(tempIBI);
			tempIBImaxPos=find(tempIBI==tempIBImax);
			tempIBIdiff=tempIBImax-tempIBImin;
			%note that the order of the following 3 if clauses is important!
			if (tempIBIminPos(1,1)<tempIBImaxPos(end,end))
				if isempty(find(tempIBIflagCurrentBreath==1))
					tempIBIdiffType=2; %most lenient criterion
				else
					tempIBIdiffType=6; %most lenient criterion and missing IBI
				end;
			end;
			if (tempIBIminPos(1,1)>=tempIBImaxPos(end,end)) | (tempIBIminPos(end,end)>tempIBImaxPos(1,1))
				if isempty(find(tempIBIflagCurrentBreath==1))
					tempIBIdiffType=4; %exclusion criterion
				else
					tempIBIdiffType=8; %exclusion criterion and missing IBI
				end;
			end;
			if (tempIBIminPos(end,end)<=tempIBImaxPos(1,1))
				if isempty(find(tempIBIflagCurrentBreath==1))
					tempIBIdiffType=1; %most conservative criterion
				else
					tempIBIdiffType=5; %most conservative criterion and missing IBI
				end;
			end;
			tempIBImean=mean(tempIBI,1);
		else
			tempIBImin=NaN;
			tempIBImax=NaN;
            if tempIBIno<1
                tempIBImean=NaN;
            elseif tempIBIno==1
    			tempIBI=diff(tempIBICum);
        		tempIBI=tempIBI(tempIBIPos-1);
                tempIBImean=mean(tempIBI,1);
            else
                tempIBImean=mean(tempIBI,1);
            end;
			tempIBIdiff=0; %if only one or no R-peak is found in the current breathing cycle; see above!
			if isempty(find(tempIBIflagCurrentBreath==1))
				tempIBIdiffType=3;  %exclusion criterion
			else
				tempIBIdiffType=7; %exclusion criterion and missing IBI
			end;
		end;
		IBImin=cat(1,IBImin,tempIBImin);
		IBImax=cat(1,IBImax,tempIBImax);
		IBIno=cat(1,IBIno,tempIBIno);
		IBImean=cat(1,IBImean,tempIBImean);
		IBIdiff=cat(1,IBIdiff,tempIBIdiff);
		IBIdiffType=cat(1,IBIdiffType,tempIBIdiffType);
		clear tempIBImin tempIBImax tempIBImean tempIBIdiff tempIBIdiffType;
	end;
	IBIcount=appendLine(IBIcount,length(IBImean));
	IBIminCol=appendLine(IBIminCol,IBImin');
	IBImaxCol=appendLine(IBImaxCol,IBImax');
	IBInoCol=appendLine(IBInoCol,IBIno');
	IBImeanCol=appendLine(IBImeanCol,IBImean');
	IBIdiffCol=appendLine(IBIdiffCol,IBIdiff');
	IBIdiffTypeCol=appendLine(IBIdiffTypeCol,IBIdiffType');
end;
IBImin=IBIminCol';
IBImax=IBImaxCol';
IBIno=IBInoCol';
IBImean=IBImeanCol';
IBIdiff=IBIdiffCol';
IBIdiffType=IBIdiffTypeCol';
warning off MATLAB:divideByZero;
HRperBreath=(1000./IBImean)*60;
IBIcount=IBIcount';

