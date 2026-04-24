%rsaExpOp        

warning off MATLAB:divideByZero;

    global col_IBImin;
    global col_IBImax;
    global col_IBIno;
    global col_IBImean;
    global col_HRperBreathTemp;
    global col_IBIdiff;
    global col_IBIdiffType;

    global col_vt;
    global col_ttot;
    global col_IBIrv;
    global col_IBIdiffZero;
    global col_IBIrvZero;
    
    global col_ttotZero;
    global col_vtZero;
    global col_IBIdiffZeroDataOK;
    global col_ttotDataOK;
    global col_vtDataOK;
    global col_ttotEnoughIBIButFailedPVC;
    global col_vtEnoughIBIButFailedPVC;
    global col_ttotNotEnoughIBI;
    global col_vtNotEnoughIBI;

    global initi;

if initi~=1
    col_IBImin=[];
    col_IBImax=[];
    col_IBIno=[];
    col_IBImean=[];
    col_HRperBreathTemp=[];
    col_IBIdiff=[];
    col_IBIdiffType=[];

    col_vt=[];
    col_ttot=[];
    col_IBIrv=[];
    col_IBIdiffZero=[];
    col_IBIrvZero=[];

    col_ttotZero;
    col_vtZero;
    col_IBIdiffZeroDataOK;
    col_ttotDataOK;
    col_vtDataOK;
    col_ttotEnoughIBIButFailedPVC;
    col_vtEnoughIBIButFailedPVC;
    col_ttotNotEnoughIBI;
    col_vtNotEnoughIBI;
    
    initi=1;
end;

flagTtotTemp=flagTtotExp{m};

IBIminTemp=IBImin;
IBIminTemp(find(flagTtotTemp==1))=[];
IBImaxTemp=IBImax;
IBImaxTemp(find(flagTtotTemp==1))=[];
IBInoTemp=IBIno;
IBInoTemp(find(flagTtotTemp==1))=[];
IBImeanTemp=IBImean;
IBImeanTemp(find(flagTtotTemp==1))=[];
HRperBreathTemp=(1000./IBImeanTemp)*60;
IBIdiffTemp=IBIdiff;
IBIdiffTemp(find(flagTtotTemp==1))=[];
IBIdiffTypeTemp=IBIdiffType;
IBIdiffTypeTemp(find(flagTtotTemp==1))=[];

col_IBImin=appendLine(col_IBImin,IBIminTemp');
col_IBImax=appendLine(col_IBImax,IBImaxTemp');
col_IBIno=appendLine(col_IBIno,IBInoTemp');
col_IBImean=appendLine(col_IBImean,IBImeanTemp');
col_HRperBreathTemp=appendLine(col_HRperBreathTemp,HRperBreathTemp');
col_IBIdiff=appendLine(col_IBIdiff,IBIdiffTemp');
col_IBIdiffType=appendLine(col_IBIdiffType,IBIdiffTypeTemp');

vtTemp=vtExp{m};
vtTemp(find(flagTtotTemp==1))=[];
col_vt=appendLine(col_vt,vtTemp');
ttotTemp=(ttotCum{m})*1000;
ttotTemp(find(flagTtotTemp==1))=[];
col_ttot=appendLine(col_ttot,ttotTemp');

IBIrv=IBIdiffTemp./vtTemp;
%dlmwrite([expOp,'_recNo_',num2str(m),'IBIrv.csv'],IBIrv);
col_IBIrv=appendLine(col_IBIrv,IBIrv');

IBIdiffZero=IBIdiffTemp;
IBIdiffZero(find(IBIdiffTypeTemp~=1&(IBIdiffTypeTemp~=5)&~isnan(IBIdiffTypeTemp)))=0;
%dlmwrite([expOp,'_recNo_',num2str(m),'_IBIdiffzero.csv'],IBIdiffZero);
col_IBIdiffZero=appendLine(col_IBIdiffZero,IBIdiffZero'); %only perfect data meeting most conservative criterion others set to zero or deleted

IBIrvZero=IBIdiffZero./vtTemp;
%dlmwrite([expOp,'_recNo_',num2str(m),'IBIrvZero.csv'],IBIrvZero);
col_IBIrvZero=appendLine(col_IBIrvZero,IBIrvZero'); %only perfect data meeting most conservative criterion others set to zero or deleted

%=====================
        %flagging:
        %1=most conservative criterion
        %2=most lenient criterien
        %3=exclusion criterion: if only one or no R-peak is found in the current breathing cycle
        %4=%exclusion criterion: PVC not met
        %5=most conservative criterion and missing IBI
        %6=most lenient criterion and missing IBI
        %7=exclusion criterion (if only one or no R-peak is found in the current breathing cycle) and missing IBI
        %8=exclusion criterion (PVC not met) and missing IBI

dataOK=find(IBIdiffTypeTemp==1 | IBIdiffTypeTemp==2 |IBIdiffTypeTemp==5 | IBIdiffTypeTemp==6); %nearly perfect data meeting most conservative criterion or most lenient criterion
notEnoughIBI=find(IBIdiffTypeTemp==3 | IBIdiffTypeTemp==7);
enoughIBIButFailedPVC=find(IBIdiffTypeTemp==4 | IBIdiffTypeTemp==8);

lenientNotMet=find(IBIdiffTypeTemp==2 | IBIdiffTypeTemp==6);
withoutNotEnoughIBI=find(IBIdiffTypeTemp==1 | IBIdiffTypeTemp==2 | IBIdiffTypeTemp==5 | IBIdiffTypeTemp==6 | IBIdiffTypeTemp==4 | IBIdiffTypeTemp==8);
withoutEnoughIBIButFailedPVC=find(IBIdiffTypeTemp==1 | IBIdiffTypeTemp==2 | IBIdiffTypeTemp==5 | IBIdiffTypeTemp==6 | IBIdiffTypeTemp==3 | IBIdiffTypeTemp==7);
%=====================

%all(Zero)
xxx=IBIdiffZero(find(~isnan(IBIdiffZero)),1);
yyy=vtTemp(find(~isnan(IBIdiffZero)),1);
zzz=ttotTemp(find(~isnan(IBIdiffZero)),1);
meanRsaAll=mean(xxx,1);
[rRsaAllVt,tRsaAllVt,pRsaAllVt]=spear(xxx,yyy);
[rRsaAllVtPearson,pRsaAllVtPearson]=corrcoef(xxx,yyy);
[rRsaAllTtot,tRsaAllTtot,pRsaAllTtot]=spear(xxx,zzz);
[rRsaAllTtotPearson,pRsaAllTtotPearson]=corrcoef(xxx,zzz);

rrr=IBIrvZero(find(~isnan(IBIrvZero)),1);
meanRvAll=mean(rrr,1);
zzz=ttotTemp(find(~isnan(IBIrvZero)),1);
[rRvAllTtot,tRvAllTtot,pRvAllTtot]=spear(rrr,zzz);
[rRvAllTtotPearson,pRvAllTtotPearson]=corrcoef(rrr,zzz);

yyy=vtTemp(find(~isnan(IBIdiffZero)),1);
yyy=yyy(find(~isnan(yyy)),1);
meanVTAll=mean(yyy,1);%added 2009/08/06 --> %    col_ttotZero;
%col_ttotZero=appendLine(col_ttotZero,yyy');

zzz=ttotTemp(find(~isnan(IBIdiffZero)),1);
zzz=zzz(find(~isnan(zzz)),1);
meanTTOTAll=mean(zzz,1);%added 2009/08/06 --> %    col_vtZero;
%col_vtZero=appendLine(col_vtZero,zzz');

xxx=IBIdiffZero(find(~isnan(IBIdiffZero)),1);
xxx=xxx(find(~isnan(xxx)),1);
meanIBIdiffAll=mean(xxx,1);%added 2009/10/04

aaa=IBImin(find(~isnan(IBIdiffZero)),1);
aaa=aaa(find(~isnan(aaa)),1);
meanIBIminAll=mean(aaa,1);%added 2009/10/04

bbb=IBImax(find(~isnan(IBIdiffZero)),1);
bbb=bbb(find(~isnan(bbb)),1);
meanIBImaxAll=mean(bbb,1);%added 2009/10/04

hhh=HRperBreathTemp(find(~isnan(IBIdiffZero)),1);
hhh=hhh(find(~isnan(hhh)),1);
meanHRperBreathTempAll=mean(hhh,1);%added 2009/11/10

mmm=IBImean(find(~isnan(IBIdiffZero)),1);
mmm=mmm(find(~isnan(mmm)),1);
meanIBImeanAll=mean(mmm,1);%added 2010/01/27


%notEnoughIBI - added 2009/09/24
yyy=vtTemp(notEnoughIBI,1);
yyy=yyy(find(~isnan(yyy)),1);
meanVtNotEnoughIBI=mean(yyy,1); % --> %    col_vtNotEnoughIBI;
col_vtNotEnoughIBI=appendLine(col_vtNotEnoughIBI,yyy');
zzz=ttotTemp(notEnoughIBI,1);
zzz=zzz(find(~isnan(zzz)),1);
meanTtotNotEnoughIBI=mean(zzz,1); % --> %    col_ttotNotEnoughIBI;
col_ttotNotEnoughIBI=appendLine(col_ttotNotEnoughIBI,zzz');

xxx=IBIdiffZero(notEnoughIBI,1);
xxx=xxx(find(~isnan(xxx)),1);
meanIBIdiffNotEnoughIBI=mean(xxx,1);%added 2009/10/04

aaa=IBImin(notEnoughIBI,1);
aaa=aaa(find(~isnan(aaa)),1);
meanIBIminNotEnoughIBI=mean(aaa,1);%added 2009/10/04

bbb=IBImax(notEnoughIBI,1);
bbb=bbb(find(~isnan(bbb)),1);
meanIBImaxNotEnoughIBI=mean(bbb,1);%added 2009/10/04

hhh=HRperBreathTemp(notEnoughIBI,1);
hhh=hhh(find(~isnan(hhh)),1);
meanHRperBreathTempNotEnoughIBI=mean(hhh,1);%added 2009/11/10

mmm=IBImean(notEnoughIBI,1);
mmm=mmm(find(~isnan(mmm)),1);
meanIBImeanNotEnoughIBI=mean(mmm,1);%added 2010/01/27


%enoughIBIButFailedPVC - added 2009/09/24
yyy=vtTemp(enoughIBIButFailedPVC,1);
yyy=yyy(find(~isnan(yyy)),1);
meanVtEnoughIBIButFailedPVC=mean(yyy,1); % --> %    col_ttotEnoughIBIButFailedPVC;
col_ttotEnoughIBIButFailedPVC=appendLine(col_ttotEnoughIBIButFailedPVC,yyy');

zzz=ttotTemp(enoughIBIButFailedPVC,1);
zzz=zzz(find(~isnan(zzz)),1);
meanTtotEnoughIBIButFailedPVC=mean(zzz,1); % --> %    col_vtEnoughIBIButFailedPVC;
col_vtEnoughIBIButFailedPVC=appendLine(col_vtEnoughIBIButFailedPVC,zzz');

xxx=IBIdiffZero(enoughIBIButFailedPVC,1);
xxx=xxx(find(~isnan(xxx)),1);
meanIBIdiffEnoughIBIButFailedPVC=mean(xxx,1);%added 2009/10/04

aaa=IBImin(enoughIBIButFailedPVC,1);
aaa=aaa(find(~isnan(aaa)),1);
meanIBIminEnoughIBIButFailedPVC=mean(aaa,1);%added 2009/10/04

bbb=IBImax(enoughIBIButFailedPVC,1);
bbb=bbb(find(~isnan(bbb)),1);
meanIBImaxEnoughIBIButFailedPVC=mean(bbb,1);%added 2009/10/04

hhh=HRperBreathTemp(enoughIBIButFailedPVC,1);
hhh=hhh(find(~isnan(hhh)),1);
meanHRperBreathTempEnoughIBIButFailedPVC=mean(hhh,1);%added 2009/11/10

mmm=IBImean(enoughIBIButFailedPVC,1);
mmm=mmm(find(~isnan(mmm)),1);
meanIBImeanEnoughIBIButFailedPVC=mean(mmm,1);%added 2010/01/27


%withoutNotEnoughIBI
xxx=IBIdiffZero(withoutNotEnoughIBI);
xxx=xxx(find(~isnan(xxx)),1);
meanRsaWithoutNotEnoughIBI=mean(xxx,1);

rrr=IBIrvZero(withoutNotEnoughIBI);
rrr=rrr(find(~isnan(xxx)),1);
meanRvWithoutNotEnoughIBI=mean(rrr,1);

yyy=vtTemp(withoutNotEnoughIBI);%added 2009/08/06
yyy=yyy(find(~isnan(yyy)),1);%added 2009/08/06
meanVTWithoutNotEnoughIBI=mean(yyy,1);%added 2009/08/06
zzz=ttotTemp(withoutNotEnoughIBI);%added 2009/08/06
zzz=zzz(find(~isnan(zzz)),1);%added 2009/08/06
meanTTOTWithoutNotEnoughIBI=mean(zzz,1);%added 2009/08/06

%see above
xxx=IBIdiffZero(withoutNotEnoughIBI,1);
xxx=xxx(find(~isnan(xxx)),1);
meanIBIdiffWithoutNotEnoughIBI=mean(xxx,1);%added 2009/10/04

aaa=IBImin(withoutNotEnoughIBI,1);
aaa=aaa(find(~isnan(aaa)),1);
meanIBIminWithoutNotEnoughIBI=mean(aaa,1);%added 2009/10/04

bbb=IBImax(withoutNotEnoughIBI,1);
bbb=bbb(find(~isnan(bbb)),1);
meanIBImaxWithoutNotEnoughIBI=mean(bbb,1);%added 2009/10/04

hhh=HRperBreathTemp(withoutNotEnoughIBI,1);
hhh=hhh(find(~isnan(hhh)),1);
meanHRperBreathTempWithoutNotEnoughIBI=mean(hhh,1);%added 2009/11/10

mmm=IBImean(withoutNotEnoughIBI,1);
mmm=mmm(find(~isnan(mmm)),1);
meanIBImeanWithoutNotEnoughIBI=mean(mmm,1);%added 2010/01/27


%withoutEnoughIBIButFailedPVC
xxx=IBIdiffZero(withoutEnoughIBIButFailedPVC);
xxx=xxx(find(~isnan(xxx)),1);
meanRsaWithoutEnoughIBIButFailedPVC=mean(xxx,1);

rrr=IBIrvZero(withoutEnoughIBIButFailedPVC);
rrr=rrr(find(~isnan(xxx)),1);
meanRvWithoutEnoughIBIButFailedPVC=mean(rrr,1);

yyy=vtTemp(withoutEnoughIBIButFailedPVC);%added 2009/08/06
yyy=yyy(find(~isnan(yyy)),1);%added 2009/08/06
meanVTWithoutEnoughIBIButFailedPVC=mean(yyy,1);%added 2009/08/06
zzz=ttotTemp(withoutEnoughIBIButFailedPVC);%added 2009/08/06
zzz=zzz(find(~isnan(zzz)),1);%added 2009/08/06
meanTTOTWithoutEnoughIBIButFailedPVC=mean(zzz,1);%added 2009/08/06

%see above
xxx=IBIdiffZero(withoutEnoughIBIButFailedPVC,1);
xxx=xxx(find(~isnan(xxx)),1);
meanIBIdiffWithoutEnoughIBIButFailedPVC=mean(xxx,1);%added 2009/10/04

aaa=IBImin(withoutEnoughIBIButFailedPVC,1);
aaa=aaa(find(~isnan(aaa)),1);
meanIBIminWithoutEnoughIBIButFailedPVC=mean(aaa,1);%added 2009/10/04

bbb=IBImax(withoutEnoughIBIButFailedPVC,1);
bbb=bbb(find(~isnan(bbb)),1);
meanIBImaxWithoutEnoughIBIButFailedPVC=mean(bbb,1);%added 2009/10/04

hhh=HRperBreathTemp(withoutEnoughIBIButFailedPVC,1);
hhh=hhh(find(~isnan(hhh)),1);
meanHRperBreathTempWithoutEnoughIBIButFailedPVC=mean(hhh,1);%added 2009/11/10

mmm=IBImean(withoutEnoughIBIButFailedPVC,1);
mmm=mmm(find(~isnan(mmm)),1);
meanIBImeanWithoutEnoughIBIButFailedPVC=mean(mmm,1);%added 2010/01/27


%dataOK
xxx=IBIdiffZero(dataOK,1); %   -->  col_IBIdiffZeroDataOK;
col_IBIdiffZeroDataOK=appendLine(col_IBIdiffZeroDataOK,xxx');
xxx=xxx(find(~isnan(xxx)),1);
meanRsaDataOk=mean(xxx,1);
yyy=vtTemp(dataOK,1);
yyy=yyy(find(~isnan(xxx)),1);
[rRsaDataOkVt,tRsaDataOkVt,pRsaDataOkVt]=spear(xxx,yyy);
[rRsaDataOkVtPearson,pRsaDataOkVtPearson]=corrcoef(xxx,yyy);

zzz=ttotTemp(dataOK,1);
zzz=zzz(find(~isnan(xxx)),1);
[rRsaDataOkTtot,tRsaDataOkTtot,pRsaDataOkTtot]=spear(yyy,zzz);
[rRsaDataOkTtotPearson,pRsaDataOkTtotPearson]=corrcoef(yyy,zzz);

rrr=IBIrvZero(dataOK,1);
rrr=rrr(find(~isnan(xxx)),1);
meanRvDataOk=mean(rrr,1);
[rRvDataOkTtot,tRvDataOkTtot,pRvDataOkTtot]=spear(rrr,zzz);
[rRvDataOkTtotPearson,pRvDataOkTtotPearson]=corrcoef(rrr,zzz);

yyy=vtTemp(dataOK,1);%added 2009/08/06
yyy=yyy(find(~isnan(yyy)),1);%added 2009/08/06
meanVTDataOk=mean(yyy,1);%added 2009/08/06 --> %    col_vtDataOK;
col_vtDataOK=appendLine(col_vtDataOK,yyy');

zzz=ttotTemp(dataOK,1);%added 2009/08/06
zzz=zzz(find(~isnan(zzz)),1);%added 2009/08/06
meanTTOTDataOk=mean(zzz,1);%added 2009/08/06 -->  %    col_ttotDataOK;
col_ttotDataOK=appendLine(col_ttotDataOK,zzz');

%see above
xxx=IBIdiffZero(dataOK,1);
xxx=xxx(find(~isnan(xxx)),1);
meanIBIdiffDataOK=mean(xxx,1);%added 2009/10/04

aaa=IBImin(dataOK,1);
aaa=aaa(find(~isnan(aaa)),1);
meanIBIminDataOK=mean(aaa,1);%added 2009/10/04

bbb=IBImax(dataOK,1);
bbb=bbb(find(~isnan(bbb)),1);
meanIBImaxDataOK=mean(bbb,1);%added 2009/10/04

hhh=HRperBreathTemp(dataOK,1);
hhh=hhh(find(~isnan(hhh)),1);
meanHRperBreathTempDataOK=mean(hhh,1);%added 2009/11/10

mmm=IBImean(dataOK,1);
mmm=mmm(find(~isnan(mmm)),1);
meanIBImeanDataOK=mean(mmm,1);%added 2010/01/27


%==============================================================
fid = fopen('meanOutput.txt','a');
fprintf(fid,'%s\t',expOp);
fprintf(fid,'%s\t',num2str(length(IBIdiffTemp)));
fprintf(fid,'%s\t',num2str(length(dataOK)));
fprintf(fid,'%s\t',num2str(length(notEnoughIBI)));
fprintf(fid,'%s\t',num2str(length(enoughIBIButFailedPVC)));
fprintf(fid,'%s\t',num2str(length(lenientNotMet)));
fprintf(fid,'%s\t',num2str(length(find(flagTtotTemp==1))));
fprintf(fid,'%d\t',[meanRsaAll,meanRsaWithoutNotEnoughIBI,meanRsaWithoutEnoughIBIButFailedPVC,meanRsaDataOk]);
fprintf(fid,'%d\t',[meanRvAll,meanRvWithoutNotEnoughIBI,meanRvWithoutEnoughIBIButFailedPVC,meanRvDataOk]);
fprintf(fid,'%d\t',[rRsaAllVt,tRsaAllVt,pRsaAllVt,rRsaAllTtot,tRsaAllTtot,pRsaAllTtot,rRvAllTtot,tRvAllTtot,pRvAllTtot]);
fprintf(fid,'%d\t',[rRsaDataOkVt,tRsaDataOkVt,pRsaDataOkVt,rRsaDataOkTtot,tRsaDataOkTtot,pRsaDataOkTtot,rRvDataOkTtot,tRvDataOkTtot,pRvDataOkTtot]);
fprintf(fid,'%d\t',[meanIBIdiffAll,meanIBIminAll,meanIBImaxAll]);
fprintf(fid,'%d\t',[meanIBIdiffNotEnoughIBI,meanIBIminNotEnoughIBI,meanIBImaxNotEnoughIBI]);
fprintf(fid,'%d\t',[meanIBIdiffEnoughIBIButFailedPVC,meanIBIminEnoughIBIButFailedPVC,meanIBImaxEnoughIBIButFailedPVC]);
fprintf(fid,'%d\t',[meanIBIdiffWithoutNotEnoughIBI,meanIBIminWithoutNotEnoughIBI,meanIBImaxWithoutNotEnoughIBI]);
fprintf(fid,'%d\t',[meanIBIdiffWithoutEnoughIBIButFailedPVC,meanIBIminWithoutEnoughIBIButFailedPVC,meanIBImaxWithoutEnoughIBIButFailedPVC]);
fprintf(fid,'%d\t',[meanIBIdiffDataOK,meanIBIminDataOK,meanIBImaxDataOK]);
%added 2009/08/06 and added 2009/09/24
fprintf(fid,'%d\t',[meanVTAll,meanVTWithoutNotEnoughIBI,meanVTWithoutEnoughIBIButFailedPVC,meanVTDataOk,meanVtEnoughIBIButFailedPVC,meanVtEnoughIBIButFailedPVC]);
fprintf(fid,'%d\t',[meanTTOTAll,meanTTOTWithoutNotEnoughIBI,meanTTOTWithoutEnoughIBIButFailedPVC,meanTTOTDataOk,meanTtotNotEnoughIBI,meanTtotEnoughIBIButFailedPVC]);
%end of added 2009/08/06 and added 2009/09/24
%added 2009/11/10
fprintf(fid,'%d\t',[meanHRperBreathTempAll,meanHRperBreathTempWithoutNotEnoughIBI,meanHRperBreathTempWithoutEnoughIBIButFailedPVC,meanHRperBreathTempDataOK,meanHRperBreathTempNotEnoughIBI,meanHRperBreathTempEnoughIBIButFailedPVC]);
%end of added 2009/11/10
%fprintf(fid,'%d\t',[rRsaAllVtPearson,pRsaAllVtPearson,rRsaAllTtotPearson,pRsaAllTtotPearson,rRvAllTtotPearson,pRvAllTtotPearson]);
%fprintf(fid,'%d\t',[rRsaDataOkVtPearson,pRsaDataOkVtPearson,rRsaDataOkTtotPearson,pRsaDataOkTtotPearson,rRvDataOkTtotPearson,pRvDataOkTtotPearson]);
%added 2010/01/27
fprintf(fid,'%d\t',[meanIBImeanAll,meanIBImeanNotEnoughIBI,meanIBImeanEnoughIBIButFailedPVC,meanIBImeanWithoutNotEnoughIBI,meanIBImeanWithoutEnoughIBIButFailedPVC,meanIBImeanDataOK]);
%end of added 2010/01/27
fprintf(fid,'\n');
fclose(fid);

fid = fopen('col_prefix.txt','a');
fprintf(fid,'%s\t',expOp);
fclose(fid);

dlmwrite('col_IBImin.txt',col_IBImin');
dlmwrite('col_IBImax.txt',col_IBImax');
dlmwrite('col_IBIno.txt',col_IBIno');
dlmwrite('col_IBImean.txt',col_IBImean');
dlmwrite('col_HRperBreathTemp.txt',col_HRperBreathTemp');
dlmwrite('col_IBIdiffType.txt',col_IBIdiffType');

dlmwrite('col_IBIdiff.txt',col_IBIdiff');
dlmwrite('col_IBIrv.txt',col_IBIrv');
dlmwrite('col_IBIdiffZero.txt',col_IBIdiffZero');
dlmwrite('col_IBIrvZero.txt',col_IBIrvZero');
dlmwrite('col_IBIdiffZeroDataOK.txt',col_IBIdiffZeroDataOK');

dlmwrite('col_ttot.txt',col_ttot');
dlmwrite('col_vt.txt',col_vt');
dlmwrite('col_ttotDataOK.txt',col_ttotDataOK');
dlmwrite('col_vtDataOK.txt',col_vtDataOK');
dlmwrite('col_ttotEnoughIBIButFailedPVC.txt',col_ttotEnoughIBIButFailedPVC');
dlmwrite('col_vtEnoughIBIButFailedPVC.txt',col_vtEnoughIBIButFailedPVC');
dlmwrite('col_ttotNotEnoughIBI.txt',col_ttotNotEnoughIBI');
dlmwrite('col_vtNotEnoughIBI.txt',col_vtNotEnoughIBI');
