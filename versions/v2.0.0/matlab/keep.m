%keep.m is distributed as part of the RSA calibration toolbox,
%a set of programs for correcting RSA for influences from respiratory rate.
%The toolbox is based on an algorithm published in Ritz & Dahme (2006). 
%
%keep - part of rsaToolbox v2.0.0 - Copyright (C) 2003  Stefan M. Schulz
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
%KEEP keeps the caller workspace variables of your choice and clear the rest.
%       Its usage is just like "clear" but only for variables.
%
%       Special Thank's to the original authors of keep:
%      Xiaoning (David) Yang   xyang@lanl.gov 1998
%       Revision based on comments from Michael McPartland,
%       michael@gaitalf.mgh.harvard.edu, 1999
%================================================================================================

function keep(varargin);
 
%       Keep all
if isempty(varargin)
        return
end


%       See what are in caller workspace
wh = evalin('caller','who');


%       Check workspace variables
if isempty(wh)
        error('  There is nothing to keep!')
end


%       Construct a string containing workspace variables delimited by ":"
variable = [];
for i = 1:length(wh)
        variable = [variable,':',wh{i}];
end
variable = [variable,':'];


%       Extract desired variables from string
flag = 0;
for i = 1:length(varargin)
        I = findstr(variable,[':',varargin{i},':']);
        if isempty(I)
                disp(['       ',varargin{i}, ' does not exist!'])
                flag = 1;
        elseif I == 1
                variable = variable(1+length(varargin{i})+1:length(variable));
        elseif I+length(varargin{i})+1 == length(variable)
                variable = variable(1:I);
        else
                variable = [variable(1:I),variable(I+length(varargin{i})+2:length(variable))];
        end
end


%       No delete if some input variables do not exist
if flag == 1
        disp('       No variables are deleted!')
        return
end


%       Convert string back to cell and delete the rest
I = findstr(variable,':');
if length(I) ~= 1
        for i = 1:length(I)-1
                if i ~= length(I)-1
                        del(i) = {[variable(I(i)+1:I(i+1)-1),' ']};
                else
                        del(i) = {variable(I(i)+1:length(variable)-1)};
                end
        end
        evalin('caller',['clear ',del{:}])
end 
