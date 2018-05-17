function varargout = image_processing_assgnmnt_1(varargin)
% IMAGE_PROCESSING_ASSGNMNT_1 MATLAB code for image_processing_assgnmnt_1.fig
%      IMAGE_PROCESSING_ASSGNMNT_1, by itself, creates a new IMAGE_PROCESSING_ASSGNMNT_1 or raises the existing
%      singleton*.
%
%      H = IMAGE_PROCESSING_ASSGNMNT_1 returns the handle to a new IMAGE_PROCESSING_ASSGNMNT_1 or the handle to
%      the existing singleton*.
%
%      IMAGE_PROCESSING_ASSGNMNT_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGE_PROCESSING_ASSGNMNT_1.M with the given input arguments.
%
%      IMAGE_PROCESSING_ASSGNMNT_1('Property','Value',...) creates a new IMAGE_PROCESSING_ASSGNMNT_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before image_processing_assgnmnt_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to image_processing_assgnmnt_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help image_processing_assgnmnt_1

% Last Modified by GUIDE v2.5 19-Apr-2018 22:30:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @image_processing_assgnmnt_1_OpeningFcn, ...
                   'gui_OutputFcn',  @image_processing_assgnmnt_1_OutputFcn, ...
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

% --- Executes just before image_processing_assgnmnt_1 is made visible.
function image_processing_assgnmnt_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to image_processing_assgnmnt_1 (see VARARGIN)

% Choose default command line output for image_processing_assgnmnt_1
handles.output = hObject;
imProcessor;    % Running an instance of imProcessor Class....
handles.imProcessing = imProcessor; % Storing objects of imProcessor in handles variable...

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes image_processing_assgnmnt_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = image_processing_assgnmnt_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function file_operations_Callback(hObject, eventdata, handles)
% hObject    handle to file_operations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function open_image_Callback(hObject, eventdata, handles)
% hObject    handle to open_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.main_axes);
handles.imProcessing = handles.imProcessing.getImg;
handles.imProcessing = handles.imProcessing.showOriginal;
% set(handles.image_information, 'String',...
% matlab.unittest.diagnostics.ConstraintDiagnostic.getDisplayableString(handles.imProcessing.imgInfo));
guidata(hObject, handles);

% --------------------------------------------------------------------
function new_image_Callback(hObject, eventdata, handles)
% hObject    handle to new_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.main_axes,'reset');
handles.imProcessing = handles.imProcessing.getImg;
handles.imProcessing = handles.imProcessing.showOriginal;
% set(handles.image_information, 'String',...
% matlab.unittest.diagnostics.ConstraintDiagnostic.getDisplayableString(handles.imProcessing.imgInfo));
guidata(hObject, handles);

% --------------------------------------------------------------------
function save_image_Callback(hObject, eventdata, handles)
% hObject    handle to save_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.writeNsaveImage;
guidata(hObject, handles);

% --------------------------------------------------------------------
function save_image_as_Callback(hObject, eventdata, handles)
% hObject    handle to save_image_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function print_image_Callback(hObject, eventdata, handles)
% hObject    handle to print_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function clear_axes_Callback(hObject, eventdata, handles)
% hObject    handle to clear_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handlesType = {'Analyzer Window', 'Auxialary Window', 'Both Windows'};
[s, v] = listdlg('ListString', handlesType, 'SelectionMode', 'single',...
    'ListSize', [250 100], 'InitialValue', [1], 'Name', 'Window Selection',...
    'PromptString', 'Please select window to clear:',...
    'OKString', 'Select', 'CancelString', 'Cancel');

if v == 1;
    
    switch s;
        
        case 1;
            cla(handles.analyzer_window, 'reset');
        case 2;
            cla(handles.auxiliary_window, 'reset');
        case 3;
            cla(handles.analyzer_window, 'reset');
            cla(handles.auxiliary_window, 'reset');
        otherwise;
            
    end
    
end

% --------------------------------------------------------------------
function close_GUI_Callback(hObject, eventdata, handles)
% hObject    handle to close_GUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch questdlg('Are you sure you want to close? All unsaved data will be lost.',...
                  'Close', 'Yes', 'No', 'No');
    case 'Yes';
        close(gcf); % Closes the current figure handle...
    case 'No';
        % ------
end


% --- Executes on button press in draw_negative.
function draw_negative_Callback(hObject, eventdata, handles)
% hObject    handle to draw_negative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.getNegative;
guidata(hObject, handles);

% --- Executes on button press in log_transform.
function log_transform_Callback(hObject, eventdata, handles)
% hObject    handle to log_transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.getLogTransform;
guidata(hObject, handles);

% --- Executes on button press in power_transform.
function power_transform_Callback(hObject, eventdata, handles)
% hObject    handle to power_transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.analyzer_window);
handles.imProcessing.constant = 1;
handles.imProcessing.gam_ma = 1;
handles.imProcessing = handles.imProcessing.getPowerTransform;
guidata(hObject, handles);


% --- Executes on button press in stretch_contrast.
function stretch_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to stretch_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.contrastStretching;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --- Executes on button press in intensity_pass.
function intensity_pass_Callback(hObject, eventdata, handles)
% hObject    handle to intensity_pass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.intensityPass;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);

% --- Executes on button press in intensity_boost.
function intensity_boost_Callback(hObject, eventdata, handles)
% hObject    handle to intensity_boost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.intensityBoost;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --- Executes on button press in thresholder.
function thresholder_Callback(hObject, eventdata, handles)
% hObject    handle to thresholder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.thresholdingImage;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);



function const_for_LogTransform_Callback(hObject, eventdata, handles)
% hObject    handle to const_for_LogTransform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of const_for_LogTransform as text
%        str2double(get(hObject,'String')) returns contents of const_for_LogTransform as a double
% handles.imProcessing.constant = get(hObject, 'Value');
handles.imProcessing.constant = get(hObject, 'Value');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function const_for_LogTransform_CreateFcn(hObject, eventdata, handles)
% hObject    handle to const_for_LogTransform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function const_for_PowerTransform_Callback(hObject, eventdata, handles)
% hObject    handle to const_for_PowerTransform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of const_for_PowerTransform as text
%        str2double(get(hObject,'String')) returns contents of const_for_PowerTransform as a double
handles.imProcessing.constant = get(hObject, 'Value');
handles.imProcessing.gam_ma = get(hObject, 'Value');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function const_for_PowerTransform_CreateFcn(hObject, eventdata, handles)
% hObject    handle to const_for_PowerTransform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function image_information_CreateFcn(hObject, eventdata, handles)
% hObject    handle to image_information (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function sldr_4_log_constant_Callback(hObject, eventdata, handles)
% hObject    handle to sldr_4_log_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
axes(handles.analyzer_window);
handles.imProcessing.constant = uint8(get(hObject, 'Value'));
handles.imProcessing = handles.imProcessing.showVariant;
% imshow(get(hObject, 'Value')*handles.imProcessing.imgProcessed);
set(handles.current_log_const, 'String', sprintf('Constant : %f', get(hObject, 'Value')));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sldr_4_log_constant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldr_4_log_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sldr_4_power_constant_Callback(hObject, eventdata, handles)
% hObject    handle to sldr_4_power_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.imProcessing.constant = get(hObject, 'Value');
handles.imProcessing = handles.imProcessing.getPowerTransform;
set(handles.current_power_const, 'String', sprintf('Constant : %f',get(hObject, 'Value')));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sldr_4_power_constant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldr_4_power_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function bit_plane_slicer_Callback(hObject, eventdata, handles)
% hObject    handle to bit_plane_slicer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.imProcessing.bitPlane = 8 - get(hObject, 'Value');
handles.imProcessing = handles.imProcessing.bitPlaneSlicer;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
set(handles.bit_plane_indicator, 'String', sprintf('Bit Plane : %d', 8 - get(hObject, 'Value')));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bit_plane_slicer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bit_plane_slicer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function bit_plane_indicator_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bit_plane_indicator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function horizontal_shear_Callback(hObject, eventdata, handles)
% hObject    handle to horizontal_shear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.imProcessing.shearConstant = get(hObject, 'Value');
handles.imProcessing = handles.imProcessing.shearHorizontal;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
set(handles.horizontal_shear_constant, 'String', sprintf('Shear : %f', get(hObject, 'Value')));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function horizontal_shear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to horizontal_shear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function horizontal_shear_constant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to horizontal_shear_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function vertical_shear_Callback(hObject, eventdata, handles)
% hObject    handle to vertical_shear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.imProcessing.shearConstant = get(hObject, 'Value');
handles.imProcessing = handles.imProcessing.shearVertical;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
set(handles.vertical_shear_constant, 'String', sprintf('Shear : %f', get(hObject, 'Value')));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function vertical_shear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vertical_shear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function vertical_shear_constant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vertical_shear_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function rotate_image_Callback(hObject, eventdata, handles)
% hObject    handle to rotate_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.imProcessing.theta = get(hObject, 'Value');
handles.imProcessing = handles.imProcessing.rotateImg;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
set(handles.theta_indicator, 'String', sprintf('Theta : %f', get(hObject, 'Value')*(180/pi)));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function rotate_image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotate_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function theta_indicator_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_indicator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in blend_image.
function blend_image_Callback(hObject, eventdata, handles)
% hObject    handle to blend_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.getAuxImg;
guidata(hObject, handles);

% --- Executes on slider movement.
function image_blender_Callback(hObject, eventdata, handles)
% hObject    handle to image_blender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.imProcessing.constant = get(hObject, 'Value');
handles.imProcessing = handles.imProcessing.blendImg;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
set(handles.blender_constant, 'String', sprintf('Blender : %f', get(hObject, 'Value')));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function image_blender_CreateFcn(hObject, eventdata, handles)
% hObject    handle to image_blender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function blender_constant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blender_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function current_log_const_CreateFcn(hObject, eventdata, handles)
% hObject    handle to current_log_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function current_power_const_CreateFcn(hObject, eventdata, handles)
% hObject    handle to current_power_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function sldr_4_gamma_Callback(hObject, eventdata, handles)
% hObject    handle to sldr_4_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.imProcessing.gam_ma = get(hObject, 'Value');
handles.imProcessing = handles.imProcessing.getPowerTransform;
set(handles.current_gamma, 'String', sprintf('Gamma : %f',get(hObject, 'Value')));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sldr_4_gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldr_4_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function brightness_control_Callback(hObject, eventdata, handles)
% hObject    handle to brightness_control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.imProcessing.constant = get(hObject, 'Value');
handles.imProcessing = handles.imProcessing.brightnessControl;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
set(handles.brightness_level, 'String', sprintf('Level : %f', get(hObject, 'Value')));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function brightness_control_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brightness_control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function brightness_level_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brightness_level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function current_gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to current_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function spatial_filtering_Callback(hObject, eventdata, handles)
% hObject    handle to spatial_filtering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function histogram_techniques_Callback(hObject, eventdata, handles)
% hObject    handle to histogram_techniques (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function histogram_estimation_Callback(hObject, eventdata, handles)
% hObject    handle to histogram_estimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure;
handles.imProcessing = handles.imProcessing.drawHist;
guidata(hObject, handles);


% --------------------------------------------------------------------
function hist_equalization_Callback(hObject, eventdata, handles)
% hObject    handle to hist_equalization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure;
handles.imProcessing = handles.imProcessing.drawHist;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.myHistEqualization;
guidata(hObject, handles);


% --------------------------------------------------------------------
function image_smoothing_Callback(hObject, eventdata, handles)
% hObject    handle to image_smoothing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function box_kernel_filter_Callback(hObject, eventdata, handles)
% hObject    handle to box_kernel_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.smoothByBox;
guidata(hObject, handles);


% --------------------------------------------------------------------
function gaussian_kernel_filter_Callback(hObject, eventdata, handles)
% hObject    handle to gaussian_kernel_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.smoothByGauss;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function image_sharpening_Callback(hObject, eventdata, handles)
% hObject    handle to image_sharpening (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function laplacian_kernel_Callback(hObject, eventdata, handles)
% hObject    handle to laplacian_kernel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.sharpenByLaplacian;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function unsharp_masking_Callback(hObject, eventdata, handles)
% hObject    handle to unsharp_masking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.unsharpMasking;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function fuzzy_edge_detection_Callback(hObject, eventdata, handles)
% hObject    handle to fuzzy_edge_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.fuzzyEdgeDetection;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);

% --------------------------------------------------------------------
function sobel_edge_detection_Callback(hObject, eventdata, handles)
% hObject    handle to sobel_edge_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.sobelEdgeDetector;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function frequency_domain_Callback(hObject, eventdata, handles)
% hObject    handle to frequency_domain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function frequency_domain_filtering_Callback(hObject, eventdata, handles)
% hObject    handle to frequency_domain_filtering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.getLowHighPassFilter;
handles.imProcessing = handles.imProcessing.fourierFiltering;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function frequency_domain_band_filtering_Callback(hObject, eventdata, handles)
% hObject    handle to frequency_domain_band_filtering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.getBandPassRejectFilter;
handles.imProcessing = handles.imProcessing.fourierBandSelectFiltering;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function noise_filtering_Callback(hObject, eventdata, handles)
% hObject    handle to noise_filtering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function arithmetic_mean_filter_Callback(hObject, eventdata, handles)
% hObject    handle to arithmetic_mean_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.arithmeticMeanFilter;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function geometric_mean_filter_Callback(hObject, eventdata, handles)
% hObject    handle to geometric_mean_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.geometricMeanFilter;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function harmonic_mean_filter_Callback(hObject, eventdata, handles)
% hObject    handle to harmonic_mean_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.harmonicMeanFilter;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function contraharmonic_mean_filter_Callback(hObject, eventdata, handles)
% hObject    handle to contraharmonic_mean_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.contraHarmonicMeanFilter;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function order_statistic_filtering_Callback(hObject, eventdata, handles)
% hObject    handle to order_statistic_filtering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.orderStatisticsFilter;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function tools_Callback(hObject, eventdata, handles)
% hObject    handle to tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function crop_image_Callback(hObject, eventdata, handles)
% hObject    handle to crop_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.selectROIorImg;
axes(handles.auxiliary_window);
handles.imProcessing = handles.imProcessing.showOriginal;
guidata(hObject, handles);


% --------------------------------------------------------------------
function view_original_Callback(hObject, eventdata, handles)
% hObject    handle to view_original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showOriginal;
guidata(hObject, handles);


% --------------------------------------------------------------------
function convert2gray_Callback(hObject, eventdata, handles)
% hObject    handle to convert2gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.analyzer_window);
[handles.imProcessing, handles.imProcessing.imgProcessed] = handles.imProcessing.convert2gray(handles.imProcessing.img);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);

% --------------------------------------------------------------------
function morphological_processing_Callback(hObject, eventdata, handles)
% hObject    handle to morphological_processing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function morph_erosion_Callback(hObject, eventdata, handles)
% hObject    handle to morph_erosion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.getKernelSize;
handles.imProcessing = handles.imProcessing.erosion;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);

% --------------------------------------------------------------------
function morph_dilation_Callback(hObject, eventdata, handles)
% hObject    handle to morph_dilation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.getKernelSize;
handles.imProcessing = handles.imProcessing.dilation;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function morph_opening_Callback(hObject, eventdata, handles)
% hObject    handle to morph_opening (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.getKernelSize;
handles.imProcessing = handles.imProcessing.opening;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function morph_closing_Callback(hObject, eventdata, handles)
% hObject    handle to morph_closing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.getKernelSize;
handles.imProcessing = handles.imProcessing.closing;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function boundary_extraction_Callback(hObject, eventdata, handles)
% hObject    handle to boundary_extraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.getKernelSize;
handles.imProcessing = handles.imProcessing.boundaryExtraction;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function morphological_gradient_Callback(hObject, eventdata, handles)
% hObject    handle to morphological_gradient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.getKernelSize;
handles.imProcessing = handles.imProcessing.morphologicalGradient;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function top_hat_transform_Callback(hObject, eventdata, handles)
% hObject    handle to top_hat_transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.getKernelSize;
handles.imProcessing = handles.imProcessing.topHatTransform;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);

% --------------------------------------------------------------------
function bottom_hat_transform_Callback(hObject, eventdata, handles)
% hObject    handle to bottom_hat_transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.imProcessing = handles.imProcessing.getKernelSize;
handles.imProcessing = handles.imProcessing.bottomHatTransform;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function morph_smoothing_Callback(hObject, eventdata, handles)
% hObject    handle to morph_smoothing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.getKernelSize;
handles.imProcessing = handles.imProcessing.morphSmoothing;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);

% --------------------------------------------------------------------
function image_segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to image_segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function line_detection_Callback(hObject, eventdata, handles)
% hObject    handle to line_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.lineDetection;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function laplacian_operator_Callback(hObject, eventdata, handles)
% hObject    handle to laplacian_operator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.laplacianOperator;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);
% --------------------------------------------------------------------
function gradient_operator_Callback(hObject, eventdata, handles)
% hObject    handle to gradient_operator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.gradientOperator;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function kirsch_compass_kernels_Callback(hObject, eventdata, handles)
% hObject    handle to kirsch_compass_kernels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.kirschCompassMask;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function marr_hildreth_algorithm_Callback(hObject, eventdata, handles)
% hObject    handle to marr_hildreth_algorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.imProcessing = handles.imProcessing.marrHildrethEdgeDetection;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);


% --------------------------------------------------------------------
function basic_global_thresholding_Callback(hObject, eventdata, handles)
% hObject    handle to basic_global_thresholding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imProcessing = handles.imProcessing.basicGlobalThresholding;
axes(handles.analyzer_window);
handles.imProcessing = handles.imProcessing.showProcessed;
guidata(hObject, handles);

