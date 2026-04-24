%rsaClearFlag.m is part of the RSA calibration toolbox,
%a set of programs for correcting RSA for influences from respiratory rate.
%The toolbox is based on an algorithm published in Ritz & Dahme (2006).
%
%rsaClearFlag.m - part of rsaToolbox v2.0.2 - Copyright (C) 2008  Stefan M. Schulz
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
%==============================================================================================================================
%function [TTOTFlagged,VT,IBIcount,IBImean,IBImin,IBImax,IBIdiff,flag,PVCfail]=rsaClearFlag(TTOT,VT,IBImean,IBImin,IBImax,IBIdiff,IBIdiffType,flagTtot,includediffType);
%
%Part of rsaToolbox - clear data for analysis according to criterion includediffType
%==============================================================================================================================

function [TTOTFlagged,VT,IBIcount,IBImean,IBImin,IBImax,IBIdiff,flag,PVCfail,notEnoughIBI,HRperBreath,IBInoFlagged]=rsaClearFlag(TTOT,VT,IBImean,IBImin,IBImax,IBIdiff,IBIdiffType,flagTtot,IBIno,includediffType);

if nargin < 10
	includediffType=5; %default: 5
end;
%includediffType=1: keep only data meeting most conservative criterion
%includediffType=2: keep only data meeting most conservative and most lenient criterion
%includediffType=3: keep all data regardless of peak-valley criterion
%includediffType=4: set all data not meeting the most conservative criterion to zero
%includediffType=5: set data not meeting conservative PVC to zero and breath with < 2 IBI to missing

[r1,c1]=size(TTOT);
[r2,c2]=size(VT);
[r3,c3]=size(IBImean);
[r4,c4]=size(IBImin);
[r5,c5]=size(IBImax);
[r6,c6]=size(IBIdiff);
[r7,c7]=size(IBIdiff);
[r8,c8]=size(IBIno);

if includediffType~=1 & includediffType~=2 & includediffType~=4 & includediffType~=5
	includediffType=3;
end;

TTOTFlagged=[];
VTFlagged=[];
IBIcountFlagged=[];
IBImeanFlagged=[];
IBIminFlagged=[];
IBImaxFlagged=[];
IBIdiffFlagged=[];
IBInoFlagged=[];
flag=[];
PVCfail=[];
notEnoughIBI=[];
for n=1:c1 %
	tempTTOT=TTOT{n};
	tempVT=VT{n};
	tempIBImean=IBImean(:,n);
	tempIBImin=IBImin(:,n);
	tempIBImax=IBImax(:,n);
	tempIBIdiff=IBIdiff(:,n);
    tempIBIno=IBIno(:,n);
	tempFlagTtot=flagTtot{n};
	tempIBIdiffType=IBIdiffType(:,n);
	%apply flagging
	if includediffType==1 %only data meeting most conservative criterion
		tempTTOT(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)))=NaN;
		tempVT(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)))=NaN;
		tempIBImean(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)))=NaN;
		tempIBImin(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)))=NaN;
		tempIBImax(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)))=NaN;
		tempIBIdiff(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)))=NaN;
		tempIBIdiffType(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)))=NaN;
        tempIBIno(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)))=NaN;
	elseif includediffType==2 %only data meeting most conservative and most lenient criterion
		tempTTOT(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)&(IBIdiffType(:,n)~=2)&(IBIdiffType(:,n)~=6)))=NaN;
		tempVT(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)&(IBIdiffType(:,n)~=2)&(IBIdiffType(:,n)~=6)))=NaN;
		tempIBImean(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)&(IBIdiffType(:,n)~=2)&(IBIdiffType(:,n)~=6)))=NaN;
		tempIBImin(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)&(IBIdiffType(:,n)~=2)&(IBIdiffType(:,n)~=6)))=NaN;
		tempIBImax(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)&(IBIdiffType(:,n)~=2)&(IBIdiffType(:,n)~=6)))=NaN;
		tempIBIdiff(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)&(IBIdiffType(:,n)~=2)&(IBIdiffType(:,n)~=6)))=NaN;
		tempIBIdiffType(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)&(IBIdiffType(:,n)~=2)&(IBIdiffType(:,n)~=6)))=NaN;
        tempIBIno(find((IBIdiffType(:,n)~=1)&(IBIdiffType(:,n)~=5)&(IBIdiffType(:,n)~=2)&(IBIdiffType(:,n)~=6)))=NaN;
	elseif includediffType==4 %set all data not meeting the most conservative criterion to zero
		tempIBIdiff(find(IBIdiffType(:,n)~=1&(IBIdiffType(:,n)~=5)&~isnan(IBIdiffType(:,n))))=0;
		tempIBImean(find(IBIdiffType(:,n)~=1&(IBIdiffType(:,n)~=5)&~isnan(IBIdiffType(:,n))))=0;
        tempIBImin(find(IBIdiffType(:,n)~=1&(IBIdiffType(:,n)~=5)&~isnan(IBIdiffType(:,n))))=0;
    elseif includediffType==5 %set data not meeting conservative PVC to zero and breath with < 2 IBI to missing
		tempIBIdiff(find(IBIdiffType(:,n)~=1&(IBIdiffType(:,n)~=5)&~isnan(IBIdiffType(:,n))))=0;
		tempIBImean(find(IBIdiffType(:,n)~=1&(IBIdiffType(:,n)~=5)&~isnan(IBIdiffType(:,n))))=0;
        tempIBImin(find(IBIdiffType(:,n)~=1&(IBIdiffType(:,n)~=5)&~isnan(IBIdiffType(:,n))))=0;
    end;
    if includediffType~=3
    	tempTTOT(find(tempFlagTtot==1))=NaN;
        tempVT(find(tempFlagTtot==1))=NaN;
        tempIBImean(find(tempFlagTtot==1))=9999999;
        tempIBImin(find(tempFlagTtot==1))=NaN;
        tempIBImax(find(tempFlagTtot==1))=NaN;
        tempIBIdiff(find(tempFlagTtot==1))=NaN;
        tempIBIdiffType(find(tempFlagTtot==1))=NaN;
        tempIBIno(find(tempFlagTtot==1))=NaN;
        tempTTOT(isnan(tempTTOT))=[];
        tempVT(isnan(tempVT))=[];
        tempIBImean(find((tempIBImean==9999999)))=[];
        tempIBImin(isnan(tempIBImin))=[];
        tempIBImax(isnan(tempIBImax))=[];
        tempIBIdiff(isnan(tempIBIdiff))=[];
        tempIBIdiffType(isnan(tempIBIdiffType))=[];
        tempIBIno(isnan(tempIBIno))=[];
    end;
    if includediffType==5 %set data not meeting conservative PVC to zero and breath with < 2 IBI to missing
        tempTTOT(find(tempIBIdiffType==3|(tempIBIdiffType==7)))=NaN;
		tempVT(find(tempIBIdiffType==3|(tempIBIdiffType==7)))=NaN;
		tempIBImean(find(tempIBIdiffType==3|(tempIBIdiffType==7)))=NaN;
        tempIBImin(find(tempIBIdiffType==3|(tempIBIdiffType==7)))=NaN;
        tempIBImax(find(tempIBIdiffType==3|(tempIBIdiffType==7)))=NaN;
        tempIBIdiff(find(tempIBIdiffType==3|(tempIBIdiffType==7)))=NaN;
    end;
    IBIcountFlagged=appendLine(IBIcountFlagged,length(tempIBImean));
	TTOTFlagged=appendLine(TTOTFlagged,tempTTOT');
	VTFlagged=appendLine(VTFlagged,tempVT');
	IBImeanFlagged=appendLine(IBImeanFlagged,tempIBImean');
	IBIminFlagged=appendLine(IBIminFlagged,tempIBImin');
	IBImaxFlagged=appendLine(IBImaxFlagged,tempIBImax');
	IBIdiffFlagged=appendLine(IBIdiffFlagged,tempIBIdiff');
    IBInoFlagged=appendLine(IBInoFlagged,tempIBIno');
	flag=appendLine(flag,tempIBIdiffType');
	PVCfail=appendLine(PVCfail,length(find((tempIBIdiffType==4)|(tempIBIdiffType==8))));
	notEnoughIBI=appendLine(notEnoughIBI,length(find(tempIBIdiffType==3 | tempIBIdiffType==7)));
end;
TTOTFlagged=TTOTFlagged';
VT=VTFlagged';
IBIcount=IBIcountFlagged';
IBImean=IBImeanFlagged';
IBImin=IBIminFlagged';
IBImax=IBImaxFlagged';
IBIdiff=IBIdiffFlagged';
IBInoFlagged=IBInoFlagged';
flag=flag';
PVCfail=PVCfail';
notEnoughIBI=notEnoughIBI';
warning off MATLAB:divideByZero;
HRperBreath=(1000./IBImean)*60;
