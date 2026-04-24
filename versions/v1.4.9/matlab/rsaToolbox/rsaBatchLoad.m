%rsaBatchLoad.m is part of the RSA calibration toolbox,
%a set of programs for correcting RSA for influences from respiratory rate.
%The toolbox is based on an algorithm published in Ritz & Dahme (2006). 
%
%rsaBatchLoad.m - part of rsaToolbox v1.4.9 - Copyright (C) 2008  Stefan M. Schulz
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
%function [batchList,pathName,event_listString]=rsaBatchLoad(event_listString);
%
%Part of rsaToolbox - loads  appropriate files from one directory for batch processing in rsaToolbox
%==================================================================================================================================================

function [batchList,pathName,event_listString,cancelFlag]=rsaBatchLoad(event_listString);

[fileName,pathName] = uigetfile({'*.csv','comma delimited files (*.csv)'},['Select any file from batch list.']);
if isequal([fileName,pathName],[0,0])
    batchList=fileName;
    event_listString=[event_listString;{'Select a valid file.'}];
    cancelFlag=1;
    return
    % Otherwise construct the fullfilename and Check and load the file.
else
    %analyse filenames
    cd(pathName);
    dateienTTOT=dir('*_TTOT.csv');
    dateienVT=dir('*_VT.csv');
    dateienIBI=dir('*_IBI.csv');
    for i=length(dateienTTOT)
        fileTTOT=getfield(dateienTTOT(i,1),'name');
        filePrefixTTOT=fileTTOT(1:end-9);
        fileVT=getfield(dateienVT(i,1),'name');
        filePrefixVT=fileVT(1:end-7);
        fileIBI=getfield(dateienIBI(i,1),'name');
        filePrefixIBI=fileIBI(1:end-8);
        if filePrefixTTOT==filePrefixVT & filePrefixTTOT==filePrefixIBI
            batchList=dateienTTOT;
            event_listString=[event_listString;{'BATCH-MODE: File list for batch processing successfully created.'}];
            cancelFlag=0;
        else
            batchList=fileName;
            event_listString=[event_listString;{'BATCH-MODE: Inconsistencies in batch file list found.'};{'Make sure you have ONLY matching'};{'*_ibi.csv, *_vt.csv, *_ttot.csv files'};{'in your batch directory.'}];
            event_listString=[event_listString;{'______________________________________________________________________'}];
            cancelFlag=1;
        end;
    end;
end;


