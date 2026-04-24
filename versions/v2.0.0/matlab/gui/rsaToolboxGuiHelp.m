function varargout = rsaToolboxGuiHelp(varargin)
% RSATOOLBOXGUIHELP M-file for rsaToolboxGuiHelp.fig
%      RSATOOLBOXGUIHELP, by itself, creates a new RSATOOLBOXGUIHELP or raises the existing
%      singleton*.
%
%      H = RSATOOLBOXGUIHELP returns the handle to a new RSATOOLBOXGUIHELP or the handle to
%      the existing singleton*.
%
%      RSATOOLBOXGUIHELP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RSATOOLBOXGUIHELP.M with the given input arguments.
%
%      RSATOOLBOXGUIHELP('Property','Value',...) creates a new RSATOOLBOXGUIHELP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rsaToolboxGuiHelp_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rsaToolboxGuiHelp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rsaToolboxGuiHelp

% Last Modified by GUIDE v2.5 16-Oct-2008 14:29:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rsaToolboxGuiHelp_OpeningFcn, ...
                   'gui_OutputFcn',  @rsaToolboxGuiHelp_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before rsaToolboxGuiHelp is made visible.
function rsaToolboxGuiHelp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rsaToolboxGuiHelp (see VARARGIN)

% Choose default command line output for rsaToolboxGuiHelp
handles.output = hObject;

%helpTextString{1,1}=get(handles.helpText,'String');
helpTextString={'rsaToolbox v2.0.0'};
helpTextString=[helpTextString;{'=================================================================='}];
helpTextString=[helpTextString;{'rsaToolbox allows assessment and correction of RSA'}];
helpTextString=[helpTextString;{'for individual effects of breathing (TTOT and VT).'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'We hope rsaToolbox is convenient to make these procedures more common.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'===============CONTACT============================================'}];
helpTextString=[helpTextString;{'In case you have suggestions for improvement, want to collaborate,'}];
helpTextString=[helpTextString;{'exchange ideas, or simply feel lost with these cryptic instructions,'}];
helpTextString=[helpTextString;{'please write:'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'Dr. Stefan M. Schulz'}];
helpTextString=[helpTextString;{'Department of Psychology I'}];
helpTextString=[helpTextString;{'University of Wuerzburg'}];
helpTextString=[helpTextString;{'Marcusstrasse 9-11'}];
helpTextString=[helpTextString;{'97070 Wuerzburg'}];
helpTextString=[helpTextString;{'Germany'}];
helpTextString=[helpTextString;{'Phone: +49(0)931-31-80184'}];
helpTextString=[helpTextString;{'Fax:   +49(0)931-31-82733'}];
helpTextString=[helpTextString;{'Email: <schulz@psychologie.uni-wuerzburg.de>'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'===============USAGE============================================='}];
helpTextString=[helpTextString;{'The quick reference shown at program start in the'}];
helpTextString=[helpTextString;{'"event monitor" provides an overview for step'}];
helpTextString=[helpTextString;{'by step operations. However, in most cases,'}];
helpTextString=[helpTextString;{'batch modes will be much more convenient:'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'===============INPUT DATA========================================'}];
helpTextString=[helpTextString;{'Input data must meet the following requirements:'}];
helpTextString=[helpTextString;{'Each data set must include the following data,'}];
helpTextString=[helpTextString;{'saved to comma separated files (*.csv) with one column per file'}];
helpTextString=[helpTextString;{'- TTOT in seconds'}];
helpTextString=[helpTextString;{'- VT in liter'}];
helpTextString=[helpTextString;{'- IBI in milliseconds'}];
helpTextString=[helpTextString;{'We recommend to begin filenames with a unique study identifier'}];
helpTextString=[helpTextString;{'followed by a counter for the participant number and session.'}];
helpTextString=[helpTextString;{'For the different data (i.e., TTOT, VT, and IBI), this prefix'}];
helpTextString=[helpTextString;{'should be extended with identifiers for the different types of data'}];
helpTextString=[helpTextString;{'An example TTOT would be: studyA_p001_s001_TTOT.csv'}];
helpTextString=[helpTextString;{'VT must match the corresponding TTOT scores.'}];
helpTextString=[helpTextString;{'Note that the first value in the list of IBI is used to synchronize'}];
helpTextString=[helpTextString;{'the onset of this data vector with the onset of the first breath (TTOT)'}];
helpTextString=[helpTextString;{'This score is therefore omitted in the analysis.'}];
helpTextString=[helpTextString;{'Furthermore, any value in the list of IBI or TTOT may be excluded'}];
helpTextString=[helpTextString;{'by creating additional flagging files,'}];
helpTextString=[helpTextString;{'prefix_IBI_flag.csv, and prefix_TTOT_flag.csv, respectively.'}];
helpTextString=[helpTextString;{'This can be used to omit irregular breaths, ectopic heartbeats,'}];
helpTextString=[helpTextString;{'or other irregular data from the analysis.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'Example with 4 breaths and 6 IBI:'}];
helpTextString=[helpTextString;{'prefix_TTOT=[1.5;2.1;2.2;1.8];'}];
helpTextString=[helpTextString;{'prefix_TTOTflag=[0;0;1;0];'}];
helpTextString=[helpTextString;{'prefix_IBI=[124;823;820;903;959;846];'}];
helpTextString=[helpTextString;{'prefix_IBIflag=[1;0;0;0;0;0];'}];
helpTextString=[helpTextString;{'prefix_VT=[0.834;0.8615;0.854;0.7715;0.8175;0.671]'}];
helpTextString=[helpTextString;{'In this example, the third breath has been excluded, maybe because'}];
helpTextString=[helpTextString;{'sighing was observed during this breath.'}];
helpTextString=[helpTextString;{'Note that the first entry in IBIflag is also set to 1.'}];
helpTextString=[helpTextString;{'Again, this is because the first IBI is always used to synchronize'}];
helpTextString=[helpTextString;{'the start of the first breath (TTOT) with the start of our IBI data.'}];
helpTextString=[helpTextString;{'In this example, the first IBI has most likely started before'}];
helpTextString=[helpTextString;{'the beginning of the first breath. However, it extends 124ms'}];
helpTextString=[helpTextString;{'into the first breath.'}];
helpTextString=[helpTextString;{'Therefore, the first valid IBI is the one starting after 124ms.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'Note that you do not have to use the flag files.'}];
helpTextString=[helpTextString;{'You can skip this step when loading data manually.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'===============BATCH MODE========================================'}];
helpTextString=[helpTextString;{'The most convenient mode of operation for rsToolbox is the batch mode.'}];
helpTextString=[helpTextString;{'Ideally, you prepare your data, and then the three different batch modes'}];
helpTextString=[helpTextString;{'allow for processing all data within a given folder.'}];
helpTextString=[helpTextString;{'One advantage is that this forces you to get your original data in'}];
helpTextString=[helpTextString;{'shape, because otherwise the batch mode will fail. This greatly'}];
helpTextString=[helpTextString;{'helps finding and correcting errors in your original data and improves'}];
helpTextString=[helpTextString;{'your results.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'What do you need?'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'Ideally, you prepare five files for each data set (i.e. one recording for'}];
helpTextString=[helpTextString;{'a given participant in line with the following schema:'}];
helpTextString=[helpTextString;{'participantNumber_sessionNumber_suffix.csv '}];
helpTextString=[helpTextString;{'In the end you should have files matching the set provided in'}];
helpTextString=[helpTextString;{'folder ..\rsaToolbox\dataExample\participant_01\experimentalData\..'}];
helpTextString=[helpTextString;{'participant_01_Sit_IBI.csv'}];
helpTextString=[helpTextString;{'participant_01_Sit_IBIflag.csv'}];
helpTextString=[helpTextString;{'participant_01_Sit_TTOT.csv'}];
helpTextString=[helpTextString;{'participant_01_Sit_TTOTflag.csv'}];
helpTextString=[helpTextString;{'participant_01_Sit_VT.csv'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'Please note a few particularities about these files:'}];
helpTextString=[helpTextString;{'The first cell in participant_01_Sit_IBI.csv contains a time in ms that'}];
helpTextString=[helpTextString;{'guarantees that the onset of the IBI in the second cell exactly matches'}];
helpTextString=[helpTextString;{'the onset of the first breath (that is the onset of the first cell'}];
helpTextString=[helpTextString;{'in file participant_01_Sit_TTOT.csv'}];
helpTextString=[helpTextString;{'Of course this is not a REAL IBI.'}];
helpTextString=[helpTextString;{'In batch mode, flag data is used, when the program finds it'}];
helpTextString=[helpTextString;{'in the corresponding folder (see below).'}];
helpTextString=[helpTextString;{'In case there is no flag data for IBI the program will omit the'}];
helpTextString=[helpTextString;{'first cell in your IBI data.'}];
helpTextString=[helpTextString;{'If you use the flag file, the first cell in flag file'}];
helpTextString=[helpTextString;{'(here: participant_01_Sit_IBIflag.csv) must contain a 1,'}];
helpTextString=[helpTextString;{'hence the respective IBI score will NOT be used to compute RSA.'}];
helpTextString=[helpTextString;{'Notably, flagging this score with a zero, will force rsaToolbox'}];
helpTextString=[helpTextString;{'to include this score (e.g., in the rare case of an exactly'}];
helpTextString=[helpTextString;{'matching start of IBI and TTOT'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'If you have vivologic software, it is possible to generate these files'}];
helpTextString=[helpTextString;{'automatically from vivologic exports (see below).'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'Once you have your files prepared, you are ready to run batches on one or'}];
helpTextString=[helpTextString;{'multiple data sets. In folder ..\rsaToolbox\dataExample\participant_01\experimentalData\..'}];
helpTextString=[helpTextString;{'there are for example four data sets for different experimental conditions.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'===============BATCH OPTION: Compute simple RSA and RSA/VT======='}];
helpTextString=[helpTextString;{'This allows for a fast and simple overview of data in a given folder.'}];
helpTextString=[helpTextString;{'The procedure generates two output files'}];
helpTextString=[helpTextString;{'in the folder containing the input data:'}];
helpTextString=[helpTextString;{'outputPerInputFile.txt contains descriptive data, one line for each data set.'}];
helpTextString=[helpTextString;{'The heading should be self-explanatory.'}];
helpTextString=[helpTextString;{'outputPerInputFilePerBreath.txt contains data for each (valid) breathing cycle separately.'}];
helpTextString=[helpTextString;{'Again, the heading should be self-explanatory.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'===============BATCH OPTION: Compute intercept and B============='}];
helpTextString=[helpTextString;{'The simplest way of creating slope and intercept'}];
helpTextString=[helpTextString;{'for TTOT correction is to put all paced breathing data'}];
helpTextString=[helpTextString;{'in one folder.'}];
helpTextString=[helpTextString;{'Next, click "Batch Processing" --> "Compute intercept and B"'}];
helpTextString=[helpTextString;{'Then navigate to the folder with your paced breathing data'}];
helpTextString=[helpTextString;{'and double click on one of the files.'}];
helpTextString=[helpTextString;{'rsaToolbox uses all matching sets of TTOT, VT, IBI'}];
helpTextString=[helpTextString;{'(and optionally, flagging data) in this folder'}];
helpTextString=[helpTextString;{'to compute slope and intercept of the individual regression'}];
helpTextString=[helpTextString;{'of TTOT upon RSA/VT across the full range of paced breathing'}];
helpTextString=[helpTextString;{'data available.'}];
helpTextString=[helpTextString;{'The results are shown in the "event monitor" of the GUI,'}];
helpTextString=[helpTextString;{'the regression is graphically shown on the right side of the GUI,'}];
helpTextString=[helpTextString;{'and the results of the regression (intercept, uncorrected B) are'}];
helpTextString=[helpTextString;{'updated in the boxes on the right pane of rsaToolbox for further usage.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'Important: This batch combines all data sets within a given folder.'}];
helpTextString=[helpTextString;{'Typically this will separate data sets for ONE subject for different'}];
helpTextString=[helpTextString;{'paced breathing frequencies.'}];
helpTextString=[helpTextString;{'Please compare the example in folder ..\rsaToolbox\dataExample\participant_01\pacedBreathing\..'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'For this combined data set, the following output will be generated'}];
helpTextString=[helpTextString;{'in the folder containing the input data:'}];
helpTextString=[helpTextString;{'paced_breathing_RSA.txt contains RSA; one column per input data set.'}];
helpTextString=[helpTextString;{'paced_breathing_RSAbyVT.txt contains RSA divided by the respective VT; one column per input data set.'}];
helpTextString=[helpTextString;{'regressionParameters.txt contains intercept, uncorrected_B, R_squared, df, p'}];
helpTextString=[helpTextString;{'for a linear regression of RSA/VT upon TTOT for the combined data set.'}];
helpTextString=[helpTextString;{'regressionPlot.eps is a figure in postscript format, to be used in your publication.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'===============BATCH OPTION: Apply intercept and B==============='}];
helpTextString=[helpTextString;{'To apply the correction based on a given slope and intercept'}];
helpTextString=[helpTextString;{'(see above or enter manually) to one or many experimental'}];
helpTextString=[helpTextString;{'recordings, put files containing matching TTOT, VT, IBI'}];
helpTextString=[helpTextString;{'(and optionally, flagging data) in one folder.'}];
helpTextString=[helpTextString;{'Next, click "Batch Processing" --> "Apply intercept and B".'}];
helpTextString=[helpTextString;{'Then navigate to the folder with your paced experimental data'}];
helpTextString=[helpTextString;{'and double click on one of the files.'}];
helpTextString=[helpTextString;{'rsaToolbox then computes TTOT corrected RSA/Vt sequentially'}];
helpTextString=[helpTextString;{'for each input data set in the folder. In addition, RSA and'}];
helpTextString=[helpTextString;{'RSA/Vt are saved to files, to allow a comparison of the'}];
helpTextString=[helpTextString;{'corrected data to traditional output variables.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'The batch generates two output files'}];
helpTextString=[helpTextString;{'in the folder containing the input data:'}];
helpTextString=[helpTextString;{'outputPerInputFile_forCorrectedData contains descriptive data, one line for each data set.'}];
helpTextString=[helpTextString;{'The heading should be self-explanatory. Additional information on data after'}];
helpTextString=[helpTextString;{'the correction based on a given intercept and B has been applied is included.'}];
helpTextString=[helpTextString;{'outputPerInputFilePerBreath_forCorrectedData contains data for each (valid) breathing cycle separately.'}];
helpTextString=[helpTextString;{'Again, the heading should be self-explanatory.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'Note that a graphical visualization of the correction will only'}];
helpTextString=[helpTextString;{'appear when you perform this operation manually, and not in batch mode'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'===============OPTIONS==========================================='}];
helpTextString=[helpTextString;{'rsaToolbox provides advanced options. Clicking on the menu entry'}];
helpTextString=[helpTextString;{'toggles them on vs. off (as indicated by a checked sign).'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'So called "Infant Option" includes one additional IBI at the beginning'}];
helpTextString=[helpTextString;{'of each breath. This helps accommodate for issues due to phase shifting and'}];
helpTextString=[helpTextString;{'short breaths in infants, greatly increasing the number of valid breaths to'}];
helpTextString=[helpTextString;{'determine RSA scores for a given breath.'}];
helpTextString=[helpTextString;{'For an application, please see '}];
helpTextString=[helpTextString;{'Ritz T, Bosquet Enlow M, Schulz SM, Kitts R, Staudenmayer J, Wright RJ (2012)'}];
helpTextString=[helpTextString;{'Respiratory Sinus Arrhythmia as an Index of Vagal Activity During Stress'}];
helpTextString=[helpTextString;{'in Infants: Respiratory Influences and their Control. PLoS One 7(12):e52729.'}];
helpTextString=[helpTextString;{'doi: 10.1371/journal.pone.0052729. Epub 2012 Dec 26.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'So called "Expert Mode" gives you control over various methods for dealing with'}];
helpTextString=[helpTextString;{'breaths where no valid RSA can be determined.'}];
helpTextString=[helpTextString;{'If you do not have a special reason, use option 2 when'}];
helpTextString=[helpTextString;{'determining intercept and B based on paced breathing data, and'}];
helpTextString=[helpTextString;{'use option 4 when running one of the other computations (i.e. when applying intercept an B to'}];
helpTextString=[helpTextString;{'some data or when computing simple RSA and RSA/VT'}];
helpTextString=[helpTextString;{'In addition, you can choose different file formats for the pictures generated when'}];
helpTextString=[helpTextString;{'running the batch "Apply intercept and B".'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'===============CONVERT DATA EXPORTS FROM VIVOLOGIC==============='}];
helpTextString=[helpTextString;{'It is possible to batch-convert exports from Vivometrics software'}];
helpTextString=[helpTextString;{'Vivologic into the five files needed for using rsaToolbox.'}];
helpTextString=[helpTextString;{'The batch converts all exports within a given folder.'}];
helpTextString=[helpTextString;{'The exports have to meet a number of requirements.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'For both variants of the import tool, please note the following:'}];
helpTextString=[helpTextString;{'- The file names must consist of an exactly matching prefix and'}];
helpTextString=[helpTextString;{'  the suffix "_Resp" for the respiration export, and the suffix'}];
helpTextString=[helpTextString;{'  "_RR" for the IBI export. The file format must be comma delimited *.csv.!'}];
helpTextString=[helpTextString;{'- Note that the files must never contain additional data!'}];
helpTextString=[helpTextString;{'- Internal format (i.e. column assignment) is crucial for proper function!'}];
helpTextString=[helpTextString;{'- Note that the exported data is converted to the following units:'}];
helpTextString=[helpTextString;{'  IBI [ms], VT [ml], TTOT [sec].'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'For option "Vivometrics Data Import", please note the following:'}];
helpTextString=[helpTextString;{'- The file "prefix_RR.csv", i.e. the EKG R-peak (RR) export file'}];
helpTextString=[helpTextString;{'  has to include the following columns:'}];
helpTextString=[helpTextString;{'  INDEX,YYYY/MM/DD,H: M: S: MS,RR'}];
helpTextString=[helpTextString;{'- The file "prefix_Resp.csv", i.e., the respiration export file'}];
helpTextString=[helpTextString;{'  has to include the following columns:'}];
helpTextString=[helpTextString;{'  INDEX,YYYY/MM/DD,H: M: S: MS,ViVol,VeVol,Tt'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'For option "Vivometrics Data Import II", please note the following:'}];
helpTextString=[helpTextString;{'- The file "prefix_RR.csv", i.e. the EKG R-peak (RR) export file'}];
helpTextString=[helpTextString;{'  has to include the following columns:'}];
helpTextString=[helpTextString;{'  Index,Timestamp,RR,...'}];
helpTextString=[helpTextString;{'- The file "prefix_Resp.csv", i.e., the respiration export file'}];
helpTextString=[helpTextString;{'  has to include the following columns:'}];
helpTextString=[helpTextString;{'  Index,Timestamp,Insp Vol,Exp Vol,Vent,Vt/Ti,Resp Rate,Te,Ti,Ti/Te,Ti/Tt,Tpef/Te,Tt,...'}];
helpTextString=[helpTextString;{'  The last 12 characters of Timestamp are in the following format: 10:50:18.349'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'Common errors leading to problems with batch generating the files'}];
helpTextString=[helpTextString;{'required for rsaToolbox include:'}];
helpTextString=[helpTextString;{'- Errors in filenames.'}];
helpTextString=[helpTextString;{'- Additions to the suffix of the filenames.'}];
helpTextString=[helpTextString;{'- Onset of EKG and respiration exports does not match.'}];
helpTextString=[helpTextString;{'- Export files include computations or notes.'}];
helpTextString=[helpTextString;{'- Data has been sorted after exporting.'}];
helpTextString=[helpTextString;{'- Exports include additional columns or columns are missing.'}];
helpTextString=[helpTextString;{'- Problems with artifact marking:'}];
helpTextString=[helpTextString;{'  - When the internal artifact option of vivologic is used,'}];
helpTextString=[helpTextString;{'    IBI will be replaced with an asterisk (*). It is necessary'}];
helpTextString=[helpTextString;{'    to delete all asterisks from the data! rsaToolbox cannot import the'}];
helpTextString=[helpTextString;{'    data otherwise. A simple text-editor can be used to replace * with nothing.'}];
helpTextString=[helpTextString;{'  - In all exports it is important to leave the first two data columns'}];
helpTextString=[helpTextString;{'    IN THE FILE. The H:M:S or Timestamp informaiton is required for proper function!'}];
helpTextString=[helpTextString;{'    Only delete the content of cells in the rest of the line!'}];
helpTextString=[helpTextString;{'    Make sure to leave the cell delimiter in the file (i.e. the commas)!'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'For an example of data containing proper artifact treatment, see'}];
helpTextString=[helpTextString;{'..rsaToolbox\dataExample\participant_01\experimentalData\vivologicExport\artifact\..'}];
helpTextString=[helpTextString;{'You may compare this to the matching files of participant_01_sit in folder'}];
helpTextString=[helpTextString;{'..rsaToolbox\dataExample\participant_01\experimentalData\vivologicExport'}];
helpTextString=[helpTextString;{'where no data has been deleted.'}];
helpTextString=[helpTextString;{' '}];
helpTextString=[helpTextString;{'Turing the so called "Expert Mode" provides the option to interpolate data that'}];
helpTextString=[helpTextString;{'was previously deleted during artifact correction. Three additional data sets'}];
helpTextString=[helpTextString;{'are created according to the following criteria:'}];
helpTextString=[helpTextString;{'Linear interpolation of IBI derived as the rounded mean of the adjacent'}];
helpTextString=[helpTextString;{'(previous and following) IBI when the artifact is more than 1SD, or 2SD or 3SD'}];
helpTextString=[helpTextString;{'(larger than the mean IBI of the whole series of IBI.'}];
helpTextString=[helpTextString;{'(Note that IBI marked as artifact are excluded from computing the mean and SD.'}];
helpTextString=[helpTextString;{'================================================================='}];
set(handles.helpText,'String',helpTextString);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rsaToolboxGuiHelp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rsaToolboxGuiHelp_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function helpText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to helpText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in helpText.
function helpText_Callback(hObject, eventdata, handles)
% hObject    handle to helpText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns helpText contents as cell array
%        contents{get(hObject,'Value')} returns selected item from helpText

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    delete(handles.figure1);


