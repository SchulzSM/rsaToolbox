%rsaLoad.m is part of the RSA calibration toolbox,
%a set of programs for correcting RSA for influences from respiratory rate.
%The toolbox is based on an algorithm published in Ritz & Dahme (2006).
%
%rsaLoad.m - part of rsaToolbox v2.0.0 - Copyright (C) 2008  Stefan M. Schulz
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
%function [loadedData,fileName,newCol]=rsaLoad(preLoadedData);
%
%Part of rsaToolbox - adds data from appropriate files to rsaToolbox
%==================================================================================================================================================

function [loadedData,newCol]=rsaLoad(preLoadedData,infoString);

loadedDataTTOT={};
loadedDataVT={};
loadedDataIBI={};

[fileName,pathName] = uigetfile({'*.txt;*.csv;*.dat','Separate ASCII-files (*.txt *.csv *.dat)';'*.mat','Prepared MAT-files (*.mat)'},['Open TTOT from ',infoString,' recording.']);
if isequal([fileName,pathName],[0,0])
	loadedData=preLoadedData;
	newCol=0;
	return
	% Otherwise construct the fullfilename and Check and load the file.
else
	fileName = fullfile(pathName,fileName);
	cd(pathName);
end;
if fileName(1,end-2:end)=='txt' | fileName(1,end-2:end)=='csv' | fileName(1,end-2:end)=='dat'
		loadedDataTTOT{1,1}=importdata(fileName);
elseif fileName(1,end-2:end)=='mat'
		loadedDataTTOT=load(fileName);
		loadedDataTTOT=struct2cell(loadedDataTTOT);
		loadedDataTTOT=loadedDataTTOT{1,1};
else
	loadedData=preLoadedData;
	newCol=0;
	return
end;
newCol=length(loadedDataTTOT);


[fileName,pathName] = uigetfile({'*.txt;*.csv;*.dat','Separate ASCII-files (*.txt *.csv *.dat)';'*.mat','Prepared MAT-files (*.mat)'},['If exist, open ttotFlag-data.']);
if isequal([fileName,pathName],[0,0])
	loadedDataFlagTTOT={([1:length(loadedDataTTOT{1,1}-1)]*0)'};
	% Otherwise construct the fullfilename and Check and load the file.
else
	fileName = fullfile(pathName,fileName);
	cd(pathName);
    if fileName(1,end-2:end)=='txt' | fileName(1,end-2:end)=='csv' | fileName(1,end-2:end)=='dat'
		loadedDataFlagTTOT{1,1}=importdata(fileName);
    elseif fileName(1,end-2:end)=='mat'
		loadedDataFlagTTOT=load(fileName);
		loadedDataFlagTTOT=struct2cell(loadedDataTTOT);
		loadedDataFlagTTOT=loadedDataTTOT{1,1};
    else
    	loadedData=preLoadedData;
	    newCol=0;
	    return
    end;
end;


[fileName,pathName] = uigetfile({'*.txt;*.csv;*.dat','Separate ASCII-files (*.txt *.csv *.dat)';'*.mat','Prepared MAT-files (*.mat)'},'Open matching VT recording.');
if isequal([fileName,pathName],[0,0])
	loadedData=preLoadedData;
	newCol=0;
	return
	% Otherwise construct the fullfilename and Check and load the file.
else
	fileName = fullfile(pathName,fileName);
	cd(pathName);
end;
if fileName(1,end-2:end)=='txt' | fileName(1,end-2:end)=='csv' | fileName(1,end-2:end)=='dat'
		loadedDataVT{1,1}=importdata(fileName);
elseif fileName(1,end-2:end)=='mat'
		loadedDataVT=load(fileName);
		loadedDataVT=struct2cell(loadedDataVT);
		loadedDataVT=loadedDataVT{1,1};
else
	loadedData=preLoadedData;
	newCol=0;
	return
end;

[fileName,pathName] = uigetfile({'*.txt;*.csv;*.dat','Separate ASCII-files (*.txt *.csv *.dat)';'*.mat','Prepared MAT-files (*.mat)'},'Open matching IBI recording.');
if isequal([fileName,pathName],[0,0])
	loadedData=preLoadedData;
	newCol=0;
	return
	% Otherwise construct the fullfilename and Check and load the file.
else
	fileName = fullfile(pathName,fileName);
	cd(pathName);
end;
if fileName(1,end-2:end)=='txt' | fileName(1,end-2:end)=='csv' | fileName(1,end-2:end)=='dat'
		loadedDataIBI{1,1}=importdata(fileName);
elseif fileName(1,end-2:end)=='mat'
		loadedDataIBI=load(fileName);
		loadedDataIBI=struct2cell(loadedDataIBI);
		loadedDataIBI=loadedDataIBI{1,1};
else
	loadedData=preLoadedData;
	newCol=0;
	return
end;

[fileName,pathName] = uigetfile({'*.txt;*.csv;*.dat','Separate ASCII-files (*.txt *.csv *.dat)';'*.mat','Prepared MAT-files (*.mat)'},['If exist, open ibiFlag-data.']);
if isequal([fileName,pathName],[0,0])
	loadedDataFlagIBI={[1,([1:length(loadedDataIBI{1,1}-2)]*0)]'};
	% Otherwise construct the fullfilename and Check and load the file.
else
	fileName = fullfile(pathName,fileName);
	cd(pathName);
    if fileName(1,end-2:end)=='txt' | fileName(1,end-2:end)=='csv' | fileName(1,end-2:end)=='dat'
		loadedDataFlagIBI{1,1}=importdata(fileName);
    elseif fileName(1,end-2:end)=='mat'
		loadedDataFlagIBI=load(fileName);
		loadedDataFlagIBI=struct2cell(loadedDataIBI);
		loadedDataFlagIBI=loadedDataIBI{1,1};
    else
    	loadedData=preLoadedData;
	    newCol=0;
	    return
    end;
end;

%perform checks
%if necessary transform into cumulative data

tempLoadedData=[loadedDataTTOT;loadedDataVT;loadedDataIBI;loadedDataFlagTTOT;loadedDataFlagIBI];
loadedData=cat(2,preLoadedData,tempLoadedData);

