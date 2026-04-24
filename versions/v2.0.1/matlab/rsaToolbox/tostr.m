%tostr.m is part of the RSA calibration toolbox,
%a set of programs for correcting RSA for influences from respiratory rate.
%The toolbox is based on an algorithm published in Ritz & Dahme (2006). 
%
%tostr.m - part of rsaToolbox v2.0.1 - Copyright (C) 1999  Alexander Gerlach
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
%Special Thanks go to Thomas Ritz and Bernd Dahme for developing the
%scientific groundwork and the underlying algorithm, as well as for
%many valuable suggestions and discussions during development of these tools.
%
%
%================================================================================================
%function a=tostr(x,n);
%
%Part of rsaToolbox - changes integers into strings with n digits.
%Adds leading 0's if n>number of digits of integer of n< then size = number of digits of integer.
%If n is not specified and the number is smaller than 2 then, n=2 (nargin).
%================================================================================================

function a=tostr(x,n);
if nargin<2, n=2; end

if isnan(x) %added handling of NaN's by Stefan M. Schulz, 2005
    a='NaN';
elseif x==0
    a='0';
else
    size=floor(log10(x))+1;
    a=[strmult(0,n-size)' int2str(x)];
end;

