%rsaNormalizeByVt.m is part of the RSA calibration toolbox,
%a set of programs for correcting RSA for influences from respiratory rate.
%The toolbox is based on an algorithm published in Ritz & Dahme (2006). 
%
%rsaNormalizeByVt.m - part of rsaToolbox v2.0.1 - Copyright (C) 2006  Stefan M. Schulz
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
%=====================================================================
%function [RV]=rsaNormalizeByVt(VT,IBIdiff);
%
%Part of rsaToolbox - normalize tidal volume (VT) by rsa (IBIdiff)
%=====================================================================

function [RV,RVMean]=rsaNormalizeByVt(VT,IBIdiff);

[r1,c1]=size(VT);
[r2,c2]=size(IBIdiff);
if c1~=c2
    RV='Error in normalizeByVt.m';
    return;
end;

RVFlagged=[];
RVFlaggedMean=[];
for n=1:c1
    tempVT=VT(:,n);
    tempIBIdiff=IBIdiff(:,n);
%    tempVT(isnan(tempVT))=[];
%    tempIBIdiff(isnan(tempIBIdiff))=[];
    tempRV=tempIBIdiff./tempVT;
    RVFlagged=appendLine(RVFlagged,tempRV');
    RVFlaggedMean=cat(1,RVFlaggedMean,rsaNanmean(tempRV));
end;
RV=RVFlagged';
RVMean=RVFlaggedMean';
