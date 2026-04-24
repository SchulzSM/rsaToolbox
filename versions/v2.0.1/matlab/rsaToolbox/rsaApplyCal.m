%rsaApplyCal.m is part of the RSA calibration toolbox,
%a set of programs for correcting RSA for influences from respiratory rate.
%The toolbox is based on an algorithm published in Ritz & Dahme (2006). 
%
%rsaApplyCal.m - part of rsaToolbox v2.0.1 - Copyright (C) 2006  Stefan M. Schulz
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
%==================================================================================================================================================
%function [RVExpPre,RVExpPreCutoff,RVExpDif,RVExpDifCutoff,TTOTCumExpCutoff,RVExpDifCutoffMean]=rsaApplyCal(TTOTExp,RVExp,beta,intercept,cutoff);
%
%Part of rsaToolbox - application of the RSA breathing calibration
%==================================================================================================================================================

function [RVExpPre,RVExpPreCutoff,RVExpDif,RVExpDifCutoff,TTOTExpCutoff,RVExpDifMean,RVExpDifCutoffMean,RVExpDifNan]=rsaApplyCal(TTOTExp,RVExp,B,intercept,cutoff);

if nargin < 5
    cutoff=10; %default=10 --> integrate: if set to 0 then don't apply
end;

[r1,c1]=size(TTOTExp);
[r2,c2]=size(RVExp);
if c1~=c2
    RVpre='Error in rsaApply.m';RVpreCutoff='Error in rsaApply.m';RVdif='Error in rsaApply.m';RVdifCutoff='Error in rsaApply.m';
    return;

end;

RVExpPre=[];
RVExpPreCutoff=[];
RVExpDif=[];
RVExpDifNan=[];
RVExpDifCutoff=[];
TTOTExpCutoff=[];
RVExpDifMean=[];
RVExpDifCutoffMean=[];
for n=1:c1
    tempTTOTExp=TTOTExp(:,n);
    tempTTOTExp(isnan(tempTTOTExp))=[];
    tempRVExp=RVExp(:,n);
    tempRVExp(isnan(tempRVExp))=[];
    if cutoff~=0
        tempTTOTExpCutoff=tempTTOTExp;
        tempTTOTExpCutoff(find(tempTTOTExpCutoff>cutoff))=cutoff;
    else
        tempTTOTExpCutoff=tempTTOTExp;
    end;
    tempRVExpPre=intercept+B.*tempTTOTExp;
    tempRVExpPreCutoff=intercept+B.*tempTTOTExpCutoff;
    tempRVExpDif=tempRVExp-tempRVExpPre;
    tempRVExpDifCutoff=tempRVExp-tempRVExpPreCutoff;
    RVExpDifMean=cat(2,RVExpDifMean,mean(tempRVExpDif,1));
    %reconstruct NaNs
    tempRVExpNaN=RVExp(:,n);
    tempRVExpDifNan=(1:1:numel(tempRVExpNaN));
    tempRVExpDifNan(isnan(tempRVExpNaN))=NaN;
    tempRVExpDifNan(~isnan(tempRVExpNaN))=tempRVExpDif;
    %putting epochs together
    RVExpPre=appendLine(RVExpPre,tempRVExpPre');
    RVExpPreCutoff=appendLine(RVExpPreCutoff,tempRVExpPreCutoff');
    RVExpDif=appendLine(RVExpDif,tempRVExpDif');
    RVExpDifNan=appendLine(RVExpDifNan,tempRVExpDifNan);
    RVExpDifCutoff=appendLine(RVExpDifCutoff,tempRVExpDifCutoff');
    TTOTExpCutoff=appendLine(TTOTExpCutoff,tempTTOTExpCutoff');
    RVExpDifCutoffMean=cat(2,RVExpDifCutoffMean,mean(tempRVExpDifCutoff,1));
end;
RVExpPre=RVExpPre';
RVExpPreCutoff=RVExpPreCutoff';
RVExpDif=RVExpDif';
RVExpDifNan=RVExpDifNan';
RVExpDifCutoff=RVExpDifCutoff';
TTOTExpCutoff=TTOTExpCutoff';
