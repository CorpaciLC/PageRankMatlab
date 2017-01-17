function varargout = info(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @info_OpeningFcn, ...
                   'gui_OutputFcn',  @info_OutputFcn, ...
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

% --- Executes just before info is made visible.
function info_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
global override;
global matrGenerated;
global gui2Matrix;
matrGenerated = false;
override = false;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes info wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = info_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)
    n = round(get(handles.sizeSlide, 'Value'));
    dens = round(get(handles.denSlider, 'Value'));
    numberOfOnes = round(n*n*dens/100);
    global myMatrix;
    global matrGenerated;
    global override;
    matrGenerated = true;
    if override == false
       myMatrix = zeros(n);
       myMatrix(randperm(numel(myMatrix), numberOfOnes)) = 1;    
        if dens == 0
          cla(handles.axes1);
        end
         for i = 1:n
             myMatrix(i, i) = 0;
         end
    end
    
    imagesc((1:n)-0.5, (1:n)-0.5, myMatrix);
    set(handles.axes1, 'XTick', 0:max(1, round(n/20)):n, 'YTick', 0:max(1, round(n/20)):n);
    set(handles.axes1, 'XLim', [0 n], 'YLim', [0 n]);
    set(handles.axes1, 'XAxisLocation', 'top', 'YDir', 'Reverse');
    box on;
    colormap(flipud(colormap(gray)));
    global ranks;
    ranks = PageRank(myMatrix, get(handles.tolSlider, 'Value'));
    override = false;
    
function pushbutton2_Callback(hObject, eventdata, handles)
    set(handles.sizetb, 'string', '100');
    set(handles.densitytb, 'string', '0');
    set(handles.toltb, 'string', '0.005');
    set(handles.sizeSlide, 'Value', 100);
    set(handles.denSlider, 'Value', 0);
    set(handles.tolSlider, 'Value', 0.005);
    cla(handles.axes1);

function sizetb_Callback(hObject, eventdata, handles)
    size = str2double(get(hObject, 'string'));
    if isnan(size)
        errordlg('Matrix size must be a number', 'Try again', 'modal');
        return;
    end
    size = round(size);
    sliderSize = get(handles.sizeSlide, 'Max');
    if size > sliderSize
        size = 1000;
        errordlg('Size is too big. Use slider for limit management.', 'Too big', 'modal');
        set(hObject, 'string', '1000');
        set(handles.sizeSlide, 'Value', 1000);
        return;
    end
    set(handles.sizeSlide, 'Value', size);
    
function sizetb_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function densitytb_Callback(hObject, eventdata, handles)
    dens = str2double(get(hObject, 'string'));
    if isnan(dens)
        errordlg('Density must be a number', 'Try again', 'modal');
        return;
    end
    dens = round(dens);
    sliderSize = get(handles.denSlider, 'Max');
    if dens > sliderSize
        dens = 100;
        errordlg('Size is too big. Use slider for limit management.', 'Too big', 'modal');
        set(hObject, 'string', '100');
        set(handles.denSlider, 'Value', 100);
        return;
    end
    set(handles.denSlider, 'Value', dens);

% --- Executes during object creation, after setting all properties.
function densitytb_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Called when text is written in Tolerance TextBox
function toltb_Callback(hObject, eventdata, handles)
    toler = str2double(get(hObject, 'string'));
    if isnan(toler)
        errordlg('Tolerance level must be a number.', 'Try again', 'modal');
        return;
    end
    sliderSize = get(handles.tolSlider, 'Max');
    if toler > sliderSize
        toler = 0.1;
        errordlg('Size is too big. Use slider for limit management.', 'Too big', 'modal');
        set(hObject, 'string', '0.1');
        set(handles.tolSlider, 'Value', 0.1);
        return;
    end
    set(handles.tolSlider, 'Value', toler);
    
% --- Executes during object creation, after setting all properties.
function toltb_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function sizeSlide_Callback(hObject, eventdata, handles)
    szVal = get(hObject, 'Value');
    szVal = round(szVal);
    set(handles.sizetb, 'string', num2str(szVal));

% --- Executes during object creation, after setting all properties.
function sizeSlide_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function denSlider_Callback(hObject, eventdata, handles)
    sldValue = get(hObject, 'Value');
    sldValue = round(sldValue);
    set(handles.densitytb, 'string', num2str(sldValue));

% --- Executes during object creation, after setting all properties.
function denSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function tolSlider_Callback(hObject, eventdata, handles)
    slideValue = get(hObject, 'Value');
    set(handles.toltb, 'string', num2str(slideValue));

% --- Executes during object creation, after setting all properties.
function tolSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)    
    set(hObject, 'XTick', 0:5:100, 'YTick', 0:5:100);
    set(hObject, 'XLim', [0 100], 'YLim', [0 100]);
    box on;



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit5.
function edit5_ButtonDownFcn(hObject, eventdata, handles)
    set(handles.edit5, 'Enable', 'on');
    set(handles.edit5, 'string', '');
    set(handles.edit5, 'ForegroundColor', 'black');
    set(handles.edit5, 'FontAngle', 'normal');
    uicontrol(handles.edit5);


% --- Executes on button press in searchbtn.
function searchbtn_Callback(hObject, eventdata, handles)
    global matrGenerated;
    if matrGenerated == false
        errordlg('You need to generate a connection simulation first.', 'Error', 'modal');
        return;
    end
    searchString = get(handles.edit5, 'string');
    if ~isempty(searchString)
        [indices url] = searchBy(searchString, get(handles.sizeSlide, 'Value'));
    else indices = 1:round(get(handles.sizeSlide, 'Value'));
    end
    
    global myMatrix;
    if indices == 0
        errordlg('No results found.', 'Try again', 'modal');
        return;
    end
    
    [ranks url] = sortByPageRank(myMatrix, get(handles.tolSlider, 'Value'), indices);
    n = min(10, length(url));
    for i = 1:n
        labelStr = ['<html><a href="">' url{i} '</a></html>'];
        jLabel(i) = javaObjectEDT('javax.swing.JLabel', labelStr);
    end     
    [hjLabel(1), ~] = javacomponent(jLabel(1), [50+25 320 132 14], gcf);
    
    n2 = max(round(n/2), min(n, 5));
    for i = 2:n2
        [hjLabel(i), ~] = javacomponent(jLabel(i), [75 320-60*(i-1) 132 14], gcf);
    end
    if n > 5 
        for i = 6:n
            [hjLabel(i), ~] = javacomponent(jLabel(i), [405 320-60*(i-6) 132 14], gcf);
        end
    end
    url
    
    for i = 1:n
        hjLabel(i).setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.HAND_CURSOR));
        set(hjLabel(i), 'MouseClickedCallback', @(h, e)web([pwd '\Pages\' url{i}], '-browser'));
    end
    



function prIndex_Callback(hObject, eventdata, handles)
    global matrGenerated;
    if matrGenerated == false
        errordlg('You need to generate a connection simulation first.', 'Error', 'modal');
        return;    
    end
    input = str2double(get(hObject, 'string'));
    if isnan(input) || input > round(get(handles.sizeSlide, 'Value')) || input < 1
        set(handles.indexPR, 'string', 'Input > 1 && Input < N.');
        return;
    end
    global ranks;
    myResult = num2str(ranks(input));
    set(handles.indexPR, 'string', myResult);
    

% --- Executes during object creation, after setting all properties.
function prIndex_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on prIndex and none of its controls.
function prIndex_KeyPressFcn(hObject, eventdata, handles)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
    Gui2;
    
function myFunc(handles)
    global gui2Matrix;
    global myMatrix;
    myMatrix = gui2Matrix;
    global override;
    override = true;
    [n ~] = size(gui2Matrix);
    set(handles.sizetb, 'string', num2str(n));
    set(handles.sizeSlide, 'Value', n);
    nrOfOnes = sum(sum(gui2Matrix));
    nrOfZeros = n^2 - nrOfOnes;
    density = round(nrOfOnes/n^2 * 100);
    set(handles.densitytb, 'string', num2str(density));
    set(handles.denSlider, 'Value', density);
    
    
    
    
  
% --- Executes during object creation, after setting all properties.
function pushbutton4_CreateFcn(hObject, eventdata, handles)
    r = randi([0 1]);
    texts = {'Magic Button of Manual Matrix Input (MBMMI)', 'Make the Professor Feel Powerful by Manual Matrix Input (MPFPMMI)'};
    set(hObject, 'string', texts{r+1});
