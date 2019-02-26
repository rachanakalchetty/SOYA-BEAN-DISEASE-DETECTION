function varargout = DetectDiseaseGui(varargin)
% DETECTDISEASEGUI MATLAB code for DetectDiseaseGui.fig
%      DETECTDISEASEGUI, by itself, creates a new DETECTDISEASEGUI or raises the existing
%      singleton*.
%
%      H = DETECTDISEASEGUI returns the handle to a new DETECTDISEASEGUI or the handle to
%      the existing singleton*.
%
%      DETECTDISEASEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DETECTDISEASEGUI.M with the given input arguments.
%
%      DETECTDISEASEGUI('Property','Value',...) creates a new DETECTDISEASEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DetectDiseaseGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DetectDiseaseGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DetectDiseaseGui

% Last Modified by GUIDE v2.5 22-Mar-2018 14:36:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DetectDiseaseGui_OpeningFcn, ...
                   'gui_OutputFcn',  @DetectDiseaseGui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DetectDiseaseGui is made visible.
function DetectDiseaseGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DetectDiseaseGui (see VARARGIN)

% Choose default command line output for DetectDiseaseGui
handles.output = hObject;
ss = ones(300,400);
axes(handles.axes1);
imshow(ss);
axes(handles.axes2);
imshow(ss);
axes(handles.axes3);
imshow(ss);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DetectDiseaseGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DetectDiseaseGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes on button press in LI.
function LI_Callback(hObject, eventdata, handles)
% hObject    handle to LI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
[filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'}, 'Pick a Leaf Image File');
I = imread([pathname,filename]);
I = imresize(I,[256,256]);
I2 = imresize(I,[300,400]);
axes(handles.axes1);
imshow(I2);title('Query Image');
ss = ones(300,400);
axes(handles.axes2);
imshow(ss);
axes(handles.axes3);
imshow(ss);
handles.ImgData1 = I;
guidata(hObject,handles);

% --- Executes on button press in EC.
function EC_Callback(hObject, eventdata, handles)
% hObject    handle to EC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I3 = handles.ImgData1;
I4 = imadjust(I3,stretchlim(I3));
I5 = imresize(I4,[300,400]);
axes(handles.axes2);
imshow(I5);title(' Contrast Enhanced ');
handles.ImgData2 = I4;
guidata(hObject,handles);


% --- Executes on button press in SI.
function SI_Callback(hObject, eventdata, handles)
% hObject    handle to SI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I6 = handles.ImgData2;
I = I6;
%% Extract Features

% Function call to evaluate features
%[feat_disease seg_img] =  EvaluateFeatures(I)

% Color Image Segmentation
% Use of K Means clustering for segmentation
% Convert Image from RGB Color Space to L*a*b* Color Space 
% The L*a*b* space consists of a luminosity layer 'L*', chromaticity-layer 'a*' and 'b*'.
% All of the color information is in the 'a*' and 'b*' layers.
cform = makecform('srgb2lab');
% Apply the colorform
lab_he = applycform(I,cform);

% Classify the colors in a*b* colorspace using K means clustering.
% Since the image has 3 colors create 3 clusters.
% Measure the distance using Euclidean Distance Metric.
ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
nColors = 3;
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
%[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
% Label every pixel in tha image using results from K means
pixel_labels = reshape(cluster_idx,nrows,ncols);
%figure,imshow(pixel_labels,[]), title('Image Labeled by Cluster Index');

% Create a blank cell array to store the results of clustering
segmented_images = cell(1,3);
% Create RGB label using pixel_labels
rgb_label = repmat(pixel_labels,[1,1,3]);

for k = 1:nColors
    colors = I;
    colors(rgb_label ~= k) = 0;
    segmented_images{k} = colors;
end



figure,subplot(2,3,2);imshow(I);title('Original Image'); subplot(2,3,4);imshow(segmented_images{1});title('Cluster 1'); subplot(2,3,5);imshow(segmented_images{2});title('Cluster 2');
subplot(2,3,6);imshow(segmented_images{3});title('Cluster 3');
set(gcf, 'Position', get(0,'Screensize'));
set(gcf, 'name','Segmented by K Means', 'numbertitle','off')
% Feature Extraction
pause(2)
x = inputdlg('Enter the cluster no. containing the disease affected part only:');
i = str2double(x);
% Extract the features from the segmented image
seg_img = segmented_images{i};
% Convert to grayscale if image is RGB
if ndims(seg_img) == 3
   img = rgb2gray(seg_img);
end

% Create the Gray Level Cooccurance Matrices (GLCMs)
glcms = graycomatrix(img);

% Derive Statistics from GLCM
stats = graycoprops(glcms,'Contrast Correlation Energy Homogeneity');
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;
Mean = mean2(seg_img);
Standard_Deviation = std2(seg_img);
Entropy = entropy(seg_img);
RMS = mean2(rms(seg_img));
%Skewness = skewness(img)
Variance = mean2(var(double(seg_img)));
a = sum(double(seg_img(:)));
Smoothness = 1-(1/(1+a));
Kurtosis = kurtosis(double(seg_img(:)));
Skewness = skewness(double(seg_img(:)));
% Inverse Difference Movement
m = size(seg_img,1);
n = size(seg_img,2);
in_diff = 0;
for i = 1:m
    for j = 1:n
        temp = seg_img(i,j)./(1+(i-j).^2);
        in_diff = in_diff+temp;
    end
end
IDM = double(in_diff);

feat_disease = [Contrast,Correlation,Energy,Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness, IDM];
I7 = imresize(seg_img,[300,400]);
axes(handles.axes3);
imshow(I7);title('Segmented Image');
handles.ImgData3 = feat_disease;
% Update GUI
guidata(hObject,handles);

% --- Executes on button press in CI.
function CI_Callback(hObject, eventdata, handles)
% hObject    handle to CI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
test = handles.ImgData3;
% Load All The Features
%load('Train_Data_Rep.mat')
load('Train_Data_Rep.mat')

% Put the test features into variable 'test'

result = multisvm(Train_Feat,Train_Label,test);
% Visualize Results
if result == 0
    R1 = 'Frogeye';
    PS1 = 'Flutriafol 11.8% ';
    PS2 = 'Prothioconazole 41.0%';
    DS1 = '210 ml - 410ml/acre';
    DS2 = '140ml - 160ml/acre';
    set(handles.ClassificationResult,'string',R1);
    set(handles.DD,'string',R1);
    set(handles.PS1,'string',PS1);
    set(handles.PS2,'string',PS2);
    set(handles.DS1,'string',DS1);
    set(handles.DS2,'string',DS2);
    helpdlg(' Frogeye ');
    disp(' Frogeye ');
elseif result == 1
    R2 = 'Powdery Mildew';
    PS1 = 'Azoxystrobin 23% SC';
    PS2 = 'Flusilazole 40%EC';
    DS1 = '200ml/acre';
    DS2 = '50ml/acre';
    set(handles.ClassificationResult,'string',R2);
    set(handles.DD,'string',R2);
    set(handles.PS1,'string',PS1);
    set(handles.PS2,'string',PS2);
    set(handles.DS1,'string',DS1);
    set(handles.DS2,'string',DS2);
    helpdlg(' Powdery Mildew ');
    disp('Powdery Mildew');
elseif result == 2
    R3 = 'Rust';
    PS1 = 'Propiconazole 25% EC';
    PS2 = 'Hexadhan';
    DS1 = '200ml/acre';
    DS2 = '300 ml/acre ';
    set(handles.ClassificationResult,'string',R3);
    set(handles.DD,'string',R3);
    set(handles.PS1,'string',PS1);
    set(handles.PS2,'string',PS2);
    set(handles.DS1,'string',DS1);
    set(handles.DS2,'string',DS2);
    helpdlg(' Rust ');
    disp(' Rust ');
elseif result == 3
    R4 = 'Downy Mildew';
    PS1 = 'Mancozeb 75% WB';
    PS2 = 'Azoxystrobin 23% SC';
    DS1 = '600-800g/acre';
    DS2 = '200ml/acre';
    set(handles.ClassificationResult,'string',R4);
    set(handles.DD,'string',R4);
    set(handles.PS1,'string',PS1);
    set(handles.PS2,'string',PS2);
    set(handles.DS1,'string',DS1);
    set(handles.DS2,'string',DS2);
    helpdlg(' Downy Mildew ');
    disp('Downy Mildew');
elseif result == 4
    R5 = 'Cercospora Leaf Blight';
    PS1 = 'Cyproconazole 8.9%';
    PS2 = 'Thiophanate-methyl ';
    DS1 = '80ml - 160ml/acre';
    DS2 = '290ml - 590ml/acre';
    set(handles.ClassificationResult,'string',R5);
    set(handles.DD,'string',R5);
    set(handles.PS1,'string',PS1);
    set(handles.PS2,'string',PS2);
    set(handles.DS1,'string',DS1);
    set(handles.DS2,'string',DS2);
    helpdlg(' Cercospora Leaf Blight ');
    disp('Cercospora Leaf Blight');
end
% Update GUI
guidata(hObject,handles);


function ClassificationResult_Callback(hObject, eventdata, handles)
% hObject    handle to ClassificationResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ClassificationResult as text
%        str2double(get(hObject,'String')) returns contents of ClassificationResult as a double


% --- Executes during object creation, after setting all properties.
function ClassificationResult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClassificationResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AF.
function AF_Callback(hObject, eventdata, handles)
% hObject    handle to AF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Area_Callback(hObject, eventdata, handles)
% hObject    handle to Area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Area as text
%        str2double(get(hObject,'String')) returns contents of Area as a double


% --- Executes during object creation, after setting all properties.
function Area_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all


function DD_Callback(hObject, eventdata, handles)
% hObject    handle to DD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DD as text
%        str2double(get(hObject,'String')) returns contents of DD as a double


% --- Executes during object creation, after setting all properties.
function DD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PS1_Callback(hObject, eventdata, handles)
% hObject    handle to PS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PS1 as text
%        str2double(get(hObject,'String')) returns contents of PS1 as a double


% --- Executes during object creation, after setting all properties.
function PS1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DS1_Callback(hObject, eventdata, handles)
% hObject    handle to DS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DS1 as text
%        str2double(get(hObject,'String')) returns contents of DS1 as a double


% --- Executes during object creation, after setting all properties.
function DS1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PS2_Callback(hObject, eventdata, handles)
% hObject    handle to PS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PS2 as text
%        str2double(get(hObject,'String')) returns contents of PS2 as a double


% --- Executes during object creation, after setting all properties.
function PS2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DS2_Callback(hObject, eventdata, handles)
% hObject    handle to DS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DS2 as text
%        str2double(get(hObject,'String')) returns contents of DS2 as a double


% --- Executes during object creation, after setting all properties.
function DS2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
