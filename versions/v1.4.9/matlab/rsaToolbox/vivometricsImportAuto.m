%vivometricsImportAuto.m is part of the RSA calibration toolbox,
%a set of programs for correcting RSA for influences from respiratory rate.
%The toolbox is based on an algorithm published in Ritz & Dahme (2006). 
%
%vivometricsImportAuto.m - part of rsaToolbox v1.2.0b - Copyright (C) 2009 Stefan M. Schulz
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
%vivometricsImportAuto;
%
%Part of rsaToolbox - converts Vivometrics (R) VivoLogic (R) export files into a
%fileformat that is appropriate for rsaToolbox - see quick reference at program start
%================================================================================================

clear all;
clc;
disp('===============================================================================================');
disp('vivometricsImportAuto1.m');
disp('===============================================================================================');
disp('Import filter for VivioMetrics (R) VivoLogic (R) data export. - (c) 2009 by Stefan M. Schulz');
disp('===============================================================================================');
disp('Quick Reference:');
disp('Two exports are required to use this tool:');
disp('The EKG R-peak (RR) export file has to include the following columns:');
disp('INDEX,YYYY/MM/DD,H: M: S: MS,RR');
disp('The the respiration export file has to include the following columns:');
disp('INDEX,YYYY/MM/DD,H: M: S: MS,ViVol,VeVol,Tt');
disp('Exports must be saved in CSV format!');
disp('Note that the files should never contain additional data!');
disp('Internalt format (i.e. column assignment) is crucial for proper function!');
disp('Note that the exported data is converted to the following units:');
disp('IBI [ms], VT [ml], TTOT [sec].');
disp('===============================================================================================');

[fileName,pathName] = uigetfile({'*.csv','comma delimited files (*.csv)'},['Select any file from batch list.']);
if isequal([fileName,pathName],[0,0])
    batchList=fileName;
    disp('Please, select a valid file.');
    disp('vivoMetricsImport aborts.');
    disp('______________________________________________________________________');
    break;break;
    % Otherwise construct the fullfilename and Check and load the file.
else
    %analyse filenames
    cd(pathName);
    dateienResp=dir('*_Resp.csv');
    dateienRR=dir('*_RR.csv');
    
    for i=1:length(dateienResp)

        fileResp=getfield(dateienResp(i,1),'name');
        filePrefixResp=fileResp(1:end-9);
        fileRR=getfield(dateienRR(i,1),'name');
        filePrefixRR=fileRR(1:end-7);
      
        if length(filePrefixResp)==length(filePrefixRR) & filePrefixResp==filePrefixRR
        else
            disp('Inconsistencies in batch file list found.');
            disp('vivoMetricsImport aborts - please check your data!');
            disp('______________________________________________________________________');
            break;break;break;
        end;
    end;
    batchList=dateienResp;
    disp('File list for batch processing successfully created.');
    cd(pathName);
    disp(['Data will be imported from ',pathName]);
    mkdir('data_generated_for_rsaToolbox');
    disp(['Data will be saved to ',pathName,'data_generated_for_rsaToolbox\..']);
    disp(['Check file ',pathName,'data_generated_for_rsaToolbox\description.txt for a summary of descriptive information.']);     
    disp('===============================================================================================');

    fid = fopen([pathName,'data_generated_for_rsaToolbox\description.txt'],'a');
    fprintf(fid,'%s\t','prefix_filename','IBI Mean [ms]','IBI SD','VT Mean [l]','VT SD','TTOT Mean [s]','TTOT SD','Number of intervals with one or more missing breathing cycles','Number of intervals with one or more missing IBI');
    fprintf(fid,'\n');
    fclose(fid);

    for j=1:length(batchList)
        keep j batchList pathName;
        
        filename01=getfield(batchList(j,1),'name');
        filePrefix01=filename01(1:end-9);
        filename02=[filePrefix01,'_RR.csv'];
        
        disp(['Importing ',filename01]);
        
        file01=importdata([pathName,filename01]);
        file01=struct2cell(file01);
        respData=file01{1,1};
        respText=file01{2,1};
        respTime=char(respText{3:end,3});
        respTime=(str2num(respTime(:,1:2))*60*60*1000)+(str2num(respTime(:,4:5))*60*1000)+(str2num(respTime(:,7:8))*1000)+(str2num(respTime(:,10:12)));
        vt=(respData(2:end,1)+respData(2:end,2))/2;
        ttot=respData(2:end,3);
        %for optional use when RTBI was also exported
        %vt=(respData(2:end,2)+respData(2:end,3))/2;
        %ttot=respData(2:end,4);

       disp(['Importing ',filename02]);

        file02=importdata([pathName,filename02]);
        file02=struct2cell(file02);
        rrData=file02{1,1};
        rrText=file02{2,1};
        rrTime=char(rrText{3:end,3});
        rrTime=(str2num(rrTime(:,1:2))*60*60*1000)+(str2num(rrTime(:,4:5))*60*1000)+(str2num(rrTime(:,7:8))*1000)+(str2num(rrTime(:,10:12)));

        %restoring missing data, and producing flags to keep track of it
        rrDataFlag=isnan(rrData(:,1));
        for n=(find(isnan(rrData(:,1))))'
            rrData(n,1)=(rrTime(n,:)-rrTime(n-1,:))/1000;
        end;

        respTimeStartNum=respTime(1,1);

        n=1;
        while rrTime(n,1)<respTime(1,1)
            n=n+1;
        end;
        syncTime=(rrTime(n,1)-respTime(1,1));
        syncTimeMs=syncTime/1000;

        ibi=rrData(n+1:end,1);
        ibi=cat(1,syncTimeMs,ibi);
        rrDataFlag=cat(1,1,rrDataFlag(n+1:end,1));

        respTimeD=diff(respTime);
        m=1;
        ttotC=[];
        flagTtot=[];
        for n=1:length(respTimeD(:,1))
            ttotC=cat(1,ttotC,ttot(n,1));
            flagTtot=cat(1,flagTtot,0);
            if round(respTimeD(m,1))>round(ttot(n,1)*1000)
                flagTtot=cat(1,flagTtot,1);
                ttotC=cat(1,ttotC,(respTime(m+1,1)/1000-respTime(m,1)/1000-ttot(m,1)));
            end;
            m=m+1;
        end;
        ttotC=cat(1,ttotC,ttot(end,1));
        flagTtot=cat(1,flagTtot,0);

        if ~isempty(find(flagTtot==1))
            insertAtPos=[find(flagTtot==0);find(flagTtot==1)];
            vt(end+1:end+length(find(flagTtot==1)),1)=NaN;
            [vt] = sortrows([insertAtPos,vt],1);
            vt=vt(:,2);
        end;

        ttot=ttotC;%sec
        vt=vt/1000;%l
        ibi=ibi*1000;%ms

        dlmwrite([pathName,'data_generated_for_rsaToolbox\',filePrefix01,'_TTOT.csv'],ttot,'\t');
        dlmwrite([pathName,'data_generated_for_rsaToolbox\',filePrefix01,'_VT.csv'],vt,'\t');
        dlmwrite([pathName,'data_generated_for_rsaToolbox\',filePrefix01,'_IBI.csv'],ibi,'\t');
        disp(['Saving TTOT [s], VT [l], IBI [ms] to separate files at ',pathName,'data_generated_for_rsaToolbox\']);
        disp(['Saving ',filePrefix01,'_TTOT.csv']);
        disp(['Saving ',filePrefix01,'_VT.csv']);
        disp(['Saving ',filePrefix01,'_IBI.csv']);

        dlmwrite([pathName,'data_generated_for_rsaToolbox\',filePrefix01,'_IBIflag.csv'],rrDataFlag,'\t');
        disp(['Saving information about missing ibi (flag: 1=missing) at ',pathName,'data_generated_for_rsaToolbox\']);
        disp(['Saving ',filePrefix01,'_IBIflag.csv']);

        dlmwrite([pathName,'data_generated_for_rsaToolbox\',filePrefix01,'_TTOTflag.csv'],flagTtot,'\t');
        disp(['Saving information about missing breathing cycles (flag: 1=missing) at ',pathName,'data_generated_for_rsaToolbox\']);
        disp(['Saving ',filePrefix01,'_TTOTflag.csv']);

        fid = fopen([pathName,'data_generated_for_rsaToolbox\description.txt'],'a');
        fprintf(fid,'%s\t',filePrefix01);
        fprintf(fid,'%s\t',num2str(mean(ibi(find(rrDataFlag~=1),1))));
        fprintf(fid,'%s\t',num2str(std(ibi(find(rrDataFlag~=1),1))));
        fprintf(fid,'%s\t',num2str(num2str(mean(vt(find(flagTtot~=1),1)))));
        fprintf(fid,'%s\t',num2str(std(vt(find(flagTtot~=1),1))));
        fprintf(fid,'%s\t',num2str(mean(ttot(find(flagTtot~=1),1))));
        fprintf(fid,'%s\t',num2str(std(ttot(find(flagTtot~=1),1))));
        fprintf(fid,'%s\t',num2str(length(find(flagTtot==1))));
        fprintf(fid,'%s\t',num2str(length(find(rrDataFlag==1))-1));
        fprintf(fid,'\n');
        fclose(fid);
        
        disp('===============================================================================================');
        disp(['Descriptive overview of the data based on valid information in files with prefix ',filePrefix01,':']);
        disp(['IBI [ms]: M=',num2str(mean(ibi(find(rrDataFlag~=1),1))),', SD=',num2str(std(ibi(find(rrDataFlag~=1),1)))]);
        disp(['VT   [l]: M=',num2str(mean(vt(find(flagTtot~=1),1))),', SD=',num2str(std(vt(find(flagTtot~=1),1)))]);
        disp(['TTOT [s]: M=',num2str(mean(ttot(find(flagTtot~=1),1))),', SD=',num2str(std(ttot(find(flagTtot~=1),1)))]);
        disp(['There are ',num2str(length(find(flagTtot==1))),' intervals with one or more missing breathing cycles.']);
        disp(['There are ',num2str(length(find(rrDataFlag==1))-1),' intervals with one or more missing ibi.']);
        disp('===============================================================================================');
        
    end;
end;

clear all;
disp('===============================================================================================');
disp('WARNING: Do not use these files to compute means etc. for IBI, VT or TTOT!');
disp('This import filter automatically fills in missing data and adds information');
disp('to allow rsaToolbox to exhaust the given information.');
disp('===============================================================================================');
disp('Import filter for Vivometrics data export - terminated succesfully.');
disp('===============================================================================================');
