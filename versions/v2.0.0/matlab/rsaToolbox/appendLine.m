%appendLine.m is part of the RSA calibration toolbox,
%a set of programs for correcting RSA for influences from respiratory rate.
%The toolbox is based on an algorithm published in Ritz & Dahme (2006). 
%
%appendLine.m - part of rsaToolbox v2.0.0 - Copyright (C) 2003  Stefan M. Schulz
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
%function [body]=appendLine(trunk,limb);
%
%Part of rsaToolbox - concatenates lines (limb) with different length to a matrix (trunk)
%==================================================================================================================================================
%
%For the RSA calibration toolbox, data epochs generally need to be stored in columns.
%If columns have different length, NaN's are used to equalize the matrix.
%
%Exp  in a variable name symbolizes that the data was recorded as a dependent variable.
%     Information gained from the calibration data will be used to correct this data.
function [body]=appendLine(trunk,limb);

if isempty(trunk)
    body=limb;
elseif isempty(limb)
    body=trunk;
else
    if isnan(trunk)
        nanPosTrunk=isnan(trunk);
        nanPosTrunk=find(nanPosTrunk==1);
        trunk=0;
    else
        nanPosTrunk=[];
    end;
    if isnan(limb)
        nanPosLimb=isnan(limb);
        nanPosLimb=find(nanPosLimb==1);
        limb=0;
    else
        nanPosLimb=[];
    end;
    [trunkLen,trunkBri]=size(trunk);
    [limbLen,limbBri]=size(limb);
    if trunkBri-limbBri > 0 %fill with NaN if actual part is shorter than the store matrix
            limb(1:limbLen,limbBri+1:trunkBri)=ones(limbLen,(trunkBri-limbBri))*NaN;
            if ~isempty(nanPosLimb)
                limb(nanPosLimb)=[NaN];
            end;
    end;
    if ~isempty(trunk) %do´nt do this when the snippets matrix is empty
        if trunkBri-limbBri < 0 %fill with NaN if store matrix is shorter than actual part
            addToTrunk=abs(trunkBri-limbBri);
            trunk=cat(2,trunk,(ones(trunkLen,addToTrunk)*NaN));
            if ~isempty(nanPosTrunk)
                trunk(nanPosTrunk)=[NaN];
            end;
        end;
        clear addToTrunk;
    end;
    body=cat(1,trunk,limb);
end;
