function varargout = SPHARMGUI(varargin)
    % SPHARMGUI M-file for SPHARMGUI.fig
    %      SPHARMGUI, by itself, creates a new SPHARMGUI or raises the existing
    %      singleton*.
    %
    %      H = SPHARMGUI returns the handle to a new SPHARMGUI or the handle to
    %      the existing singleton*.
    %
    %      SPHARMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in SPHARMGUI.M with the given input arguments.
    %
    %      SPHARMGUI('Property','Value',...) creates a new SPHARMGUI or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before SPHARMGUI_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to SPHARMGUI_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help SPHARMGUI

    % Last Modified by GUIDE v2.5 07-Jun-2017 17:14:54

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name', mfilename, ...
        'gui_Singleton', gui_Singleton, ...
        'gui_OpeningFcn', @SPHARMGUI_OpeningFcn, ...
        'gui_OutputFcn', @SPHARMGUI_OutputFcn, ...
        'gui_LayoutFcn', [], ...
        'gui_Callback', []);

    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end

    % End initialization code - DO NOT EDIT

    % --- Executes just before SPHARMGUI is made visible.
    function SPHARMGUI_OpeningFcn(hObject, eventdata, handles, varargin)
        % This function has no output args, see OutputFcn.
        % hObject    handle to figure
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
        % varargin   command line arguments to SPHARMGUI (see VARARGIN)

        % Choose default command line output for SPHARMGUI
        handles.output = hObject;
        handles.currentDir = cd;

        % Update handles structure
        guidata(hObject, handles);

        % UIWAIT makes SPHARMGUI wait for user response (see UIRESUME)
        % uiwait(handles.figure1);

        % --- Outputs from this function are returned to the command line.
        function varargout = SPHARMGUI_OutputFcn(hObject, eventdata, handles)
            % varargout  cell array for returning output args (see VARARGOUT);
            % hObject    handle to figure
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            % Get default command line output from handles structure
            varargout{1} = handles.output;

            %-----------------------------------------
            % Resize Objects & Landmarks GUI callbacks
            %-----------------------------------------

            % --- Executes on button press in resizeCheckBox.
            function resizeCheckBox_Callback(hObject, eventdata, handles)
                % hObject    handle to resizeCheckBox (see GCBO)
                % eventdata  reserved - to be defined in a future version of MATLAB
                % handles    structure with handles and user data (see GUIDATA)

                % Hint: get(hObject,'Value') returns toggle state of resizeCheckBox

                % function distancesButtonGroup_SelectionChangeFcn(hObject,eventdata)
                % switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
                %     case 'centroidRadioButton'
                %         % Code for when centroidRadioButton is selected.
                %         disp('centroidRadioButton Checked');
                %     case 'distancesRadioButton'
                %         % Code for when distancesRadioButton is selected.
                %         disp('distancesRadioButton Checked');
                %     % Continue with more cases as necessary.
                %     otherwise
                %         % Code for when there is no match.
                % end
                %

                % added to see if this fixes problem - McP 7 June 2017
                function distancesButtonGroup_ResizeFcn(hObject, eventdata, handles)

                    function distancePairsTextBox_Callback(hObject, eventdata, handles)
                        % hObject    handle to distancePairsTextBox (see GCBO)
                        % eventdata  reserved - to be defined in a future version of MATLAB
                        % handles    structure with handles and user data (see GUIDATA)

                        % Hints: get(hObject,'String') returns contents of distancePairsTextBox as text
                        %        str2double(get(hObject,'String')) returns contents of distancePairsTextBox as a double

                        % --- Executes during object creation, after setting all properties.
                        function distancePairsTextBox_CreateFcn(hObject, eventdata, handles)
                            % hObject    handle to distancePairsTextBox (see GCBO)
                            % eventdata  reserved - to be defined in a future version of MATLAB
                            % handles    empty - handles not created until after all CreateFcns called

                            % Hint: edit controls usually have a white background on Windows.
                            %       See ISPC and COMPUTER.
                            if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
                                set(hObject, 'BackgroundColor', 'white');
                            end

                            % --- Executes on button press in combineAndResizeButton.
                            function combineAndResizeButton_Callback(hObject, eventdata, handles)
                                % hObject    handle to combineAndResizeButton (see GCBO)
                                % eventdata  reserved - to be defined in a future version of MATLAB
                                % handles    structure with handles and user data (see GUIDATA)
                                a = get(handles.resizeCheckBox, 'Value');
                                c = get(handles.centroidRadioButton, 'Value');
                                d = get(handles.distancesRadioButton, 'Value');
                                text = get(handles.distancePairsTextBox, 'String');

                                % resizeMethod specified below in main If statement.
                                %       =0 (don't resize)
                                %       =1 (resize by centroidSize)
                                %       =2 (resize by distance pairs
                                distancePairs = [1 2];

                                if ((c == 1) && (d == 1))
                                    errordlg('Both centroid and distances chosen to resize.', 'GUI Problem!', 'modal');
                                end

                                if (a == 1)

                                    if (c == 1)
                                        resizeMethod = 1;
                                        handles.currentDir = MLCombineAndResize(handles.currentDir, resizeMethod, distancePairs, get(handles.sizeToFileCheckBox, 'Value'));
                                    else if (d == 1)
                                        resizeMethod = 2;
                                        % make distance pairs from text
                                        distancePairs = eval(text);
                                        handles.currentDir = MLCombineAndResize(handles.currentDir, resizeMethod, distancePairs, get(handles.sizeToFileCheckBox, 'Value'));
                                    end

                                end

                            else
                                resizeMethod = 0;
                                handles.currentDir = MLCombineAndResize(handles.currentDir, resizeMethod, distancePairs, get(handles.sizeToFileCheckBox, 'Value'));
                            end

                            guidata(hObject, handles);

                            %---------------------------------------
                            % Make Template GUI callbacks
                            %---------------------------------------

                            % --- Executes on button press in smoothTemplateCheckBox.
                            function smoothTemplateCheckBox_Callback(hObject, eventdata, handles)
                                % hObject    handle to smoothTemplateCheckBox (see GCBO)
                                % eventdata  reserved - to be defined in a future version of MATLAB
                                % handles    structure with handles and user data (see GUIDATA)

                                % Hint: get(hObject,'Value') returns toggle state of smoothTemplateCheckBox

                                function degreeTemplateTextBox_Callback(hObject, eventdata, handles)
                                    % hObject    handle to degreeTemplateTextBox (see GCBO)
                                    % eventdata  reserved - to be defined in a future version of MATLAB
                                    % handles    structure with handles and user data (see GUIDATA)

                                    % Hints: get(hObject,'String') returns contents of degreeTemplateTextBox as text
                                    %        str2double(get(hObject,'String')) returns contents of degreeTemplateTextBox as a double
                                    userEntry = str2double(get(hObject, 'string'));

                                    if isnan(userEntry)
                                        errordlg('You must enter an integer for the Degree.', 'Wrong Input', 'modal');
                                        return
                                    end

                                    % --- Executes during object creation, after setting all properties.
                                    function degreeTemplateTextBox_CreateFcn(hObject, eventdata, handles)
                                        % hObject    handle to degreeTemplateTextBox (see GCBO)
                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                        % handles    empty - handles not created until after all CreateFcns called

                                        % Hint: edit controls usually have a white background on Windows.
                                        %       See ISPC and COMPUTER.
                                        if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
                                            set(hObject, 'BackgroundColor', 'white');
                                        end

                                        % --- Executes on button press in makeTemplateButton.
                                        function makeTemplateButton_Callback(hObject, eventdata, handles)
                                            % hObject    handle to makeTemplateButton (see GCBO)
                                            % eventdata  reserved - to be defined in a future version of MATLAB
                                            % handles    structure with handles and user data (see GUIDATA)
                                            a = get(handles.smoothTemplateCheckBox, 'Value');
                                            smooth = 1;

                                            if (a == 1)
                                                smooth = 1;
                                            else
                                                smooth = 0;
                                            end

                                            b = get(handles.degreeTemplateTextBox, 'String');
                                            b = str2double(b);

                                            if isnan(b)
                                                errordlg('You must enter an integer for the Degree', 'Wrong Input', 'modal');
                                                return
                                            else
                                                b = fix(b);
                                                handles.currentDir = MLMakeTemplate(handles.currentDir, smooth, b);
                                            end

                                            guidata(hObject, handles);

                                            %---------------------------------------
                                            % Make Models GUI callbacks
                                            %---------------------------------------

                                            % --- Executes on button press in smoothModelCheckBox.
                                            function smoothModelCheckBox_Callback(hObject, eventdata, handles)
                                                % hObject    handle to smoothModelCheckBox (see GCBO)
                                                % eventdata  reserved - to be defined in a future version of MATLAB
                                                % handles    structure with handles and user data (see GUIDATA)

                                                % Hint: get(hObject,'Value') returns toggle state of smoothModelCheckBox

                                                % --- Executes on button press in modelsToFileCheckBox.
                                                function modelsToFileCheckBox_Callback(hObject, eventdata, handles)
                                                    % hObject    handle to modelsToFileCheckBox (see GCBO)
                                                    % eventdata  reserved - to be defined in a future version of MATLAB
                                                    % handles    structure with handles and user data (see GUIDATA)

                                                    % Hint: get(hObject,'Value') returns toggle state of modelsToFileCheckBox

                                                    function degreeModelTextBox_Callback(hObject, eventdata, handles)
                                                        % hObject    handle to degreeModelTextBox (see GCBO)
                                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                                        % handles    structure with handles and user data (see GUIDATA)

                                                        % Hints: get(hObject,'String') returns contents of degreeModelTextBox as text
                                                        %        str2double(get(hObject,'String')) returns contents of degreeModelTextBox as a double
                                                        userEntry = str2double(get(hObject, 'string'));

                                                        if isnan(userEntry)
                                                            errordlg('You must enter an integer for the Degree', 'Wrong Input', 'modal');
                                                            return
                                                        end

                                                        % --- Executes during object creation, after setting all properties.
                                                        function degreeModelTextBox_CreateFcn(hObject, eventdata, handles)
                                                            % hObject    handle to degreeModelTextBox (see GCBO)
                                                            % eventdata  reserved - to be defined in a future version of MATLAB
                                                            % handles    empty - handles not created until after all CreateFcns called

                                                            % Hint: edit controls usually have a white background on Windows.
                                                            %       See ISPC and COMPUTER.
                                                            if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
                                                                set(hObject, 'BackgroundColor', 'white');
                                                            end

                                                            % --- Executes on button press in makeModelsButton.
                                                            function makeModelsButton_Callback(hObject, eventdata, handles)
                                                                % hObject    handle to makeModelsButton (see GCBO)
                                                                % eventdata  reserved - to be defined in a future version of MATLAB
                                                                % handles    structure with handles and user data (see GUIDATA)
                                                                a = get(handles.smoothModelCheckBox, 'Value');
                                                                smooth = 1;

                                                                if (a == 1)
                                                                    smooth = 1;
                                                                else
                                                                    smooth = 0;
                                                                end

                                                                b = get(handles.degreeModelTextBox, 'String');
                                                                b = str2double(b);
                                                                c = get(handles.modelsToFileCheckBox, 'Value');

                                                                if (c == 1)
                                                                    toFile = 1;
                                                                else
                                                                    toFile = 0;
                                                                end

                                                                if isnan(b)
                                                                    errordlg('You must enter an integer for the Degree', 'Wrong Input', 'modal');
                                                                    return
                                                                else
                                                                    b = fix(b);
                                                                    handles.currentDir = MLMakeModels(handles.currentDir, smooth, b, toFile);
                                                                end

                                                                guidata(hObject, handles);

                                                                %---------------------------------------
                                                                % PCA GUI callbacks
                                                                %---------------------------------------

                                                                % --- Executes on button press in outputEigenmodesCheckBox.
                                                                function outputEigenmodesCheckBox_Callback(hObject, eventdata, handles)
                                                                    % hObject    handle to outputEigenmodesCheckBox (see GCBO)
                                                                    % eventdata  reserved - to be defined in a future version of MATLAB
                                                                    % handles    structure with handles and user data (see GUIDATA)

                                                                    % Hint: get(hObject,'Value') returns toggle state of outputEigenmodesCheckBox

                                                                    function keepPCAsToTextBox_Callback(hObject, eventdata, handles)
                                                                        % hObject    handle to keepPCAsToTextBox (see GCBO)
                                                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                                                        % handles    structure with handles and user data (see GUIDATA)

                                                                        % Hints: get(hObject,'String') returns contents of keepPCAsToTextBox as text
                                                                        %        str2double(get(hObject,'String')) returns contents of keepPCAsToTextBox as a double
                                                                        userEntry = str2double(get(hObject, 'string'));

                                                                        if isnan(userEntry)
                                                                            errordlg('You must enter an integer for the number of PCs to keep.', 'Wrong Input', 'modal');
                                                                            return
                                                                        end

                                                                        % --- Executes during object creation, after setting all properties.
                                                                        function keepPCAsToTextBox_CreateFcn(hObject, eventdata, handles)
                                                                            % hObject    handle to keepPCAsToTextBox (see GCBO)
                                                                            % eventdata  reserved - to be defined in a future version of MATLAB
                                                                            % handles    empty - handles not created until after all CreateFcns called

                                                                            % Hint: edit controls usually have a white background on Windows.
                                                                            %       See ISPC and COMPUTER.
                                                                            if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
                                                                                set(hObject, 'BackgroundColor', 'white');
                                                                            end

                                                                            % --- Executes on button press in runPCAButton.
                                                                            function runPCAButton_Callback(hObject, eventdata, handles)
                                                                                % hObject    handle to runPCAButton (see GCBO)
                                                                                % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                % handles    structure with handles and user data (see GUIDATA)
                                                                                a = get(handles.outputEigenmodesCheckBox, 'Value');
                                                                                eigenmodes = 1;

                                                                                if (a == 1)
                                                                                    eigenmodes = 1;
                                                                                else
                                                                                    eigenmodes = 0;
                                                                                end

                                                                                b = get(handles.keepPCAsToTextBox, 'String');
                                                                                b = str2double(b);
                                                                                b = fix(b);

                                                                                outputFormat = 'Amira'; % Amira is default

                                                                                if (get(handles.amiraFormatPCAButton, 'Value'))
                                                                                    outputFormat = 'Amira';
                                                                                elseif (get(handles.stlFormatPCAButton, 'Value'))
                                                                                    outputFormat = 'STL';
                                                                                end

                                                                                if isnan(b)
                                                                                    errordlg('You must enter an integer for the number of PCs to keep', 'Wrong Input', 'modal');
                                                                                    return
                                                                                elseif (b < 1)
                                                                                    errordlg('You must enter an integer >0 for the number of PCs to keep', 'Wrong Input', 'modal');
                                                                                    return
                                                                                else
                                                                                    handles.currentDir = MLPCACoeffs(handles.currentDir, eigenmodes, b, outputFormat);
                                                                                end

                                                                                guidata(hObject, handles);

                                                                                %---------------------------------------
                                                                                % Make Surfaces GUI callbacks
                                                                                %---------------------------------------

                                                                                function meshsizeTextBox_Callback(hObject, eventdata, handles)
                                                                                    % hObject    handle to meshsizeTextBox (see GCBO)
                                                                                    % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                    % handles    structure with handles and user data (see GUIDATA)

                                                                                    % Hints: get(hObject,'String') returns contents of meshsizeTextBox as text
                                                                                    %        str2double(get(hObject,'String')) returns contents of meshsizeTextBox as a double

                                                                                    % --- Executes during object creation, after setting all properties.
                                                                                    function meshsizeTextBox_CreateFcn(hObject, eventdata, handles)
                                                                                        % hObject    handle to meshsizeTextBox (see GCBO)
                                                                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                        % handles    empty - handles not created until after all CreateFcns called

                                                                                        % Hint: edit controls usually have a white background on Windows.
                                                                                        %       See ISPC and COMPUTER.
                                                                                        if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
                                                                                            set(hObject, 'BackgroundColor', 'white');
                                                                                        end

                                                                                        % --- Executes on button press in makeSurfacesButton.
                                                                                        function makeSurfacesButton_Callback(hObject, eventdata, handles)
                                                                                            % hObject    handle to makeSurfacesButton (see GCBO)
                                                                                            % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                            % handles    structure with handles and user data (see GUIDATA)

                                                                                            % get meshsize resolution
                                                                                            b = get(handles.meshsizeTextBox, 'String');
                                                                                            b = str2double(b);
                                                                                            % determine output format
                                                                                            outputFormat = 'Amira'; % Amira is default

                                                                                            if (get(handles.AmiraRadioButton, 'Value'))
                                                                                                outputFormat = 'Amira';
                                                                                            elseif (get(handles.STLRadioButton, 'Value'))
                                                                                                outputFormat = 'STL';
                                                                                            end

                                                                                            if isnan(b)
                                                                                                errordlg('You must enter an integer for the meshsize', 'Wrong Input', 'modal');
                                                                                                return
                                                                                            else
                                                                                                b = fix(b);
                                                                                                handles.currentDir = MLMakeSurfacesFromSPHARMModels(handles.currentDir, b, outputFormat);
                                                                                            end

                                                                                            guidata(hObject, handles);

                                                                                            %---------------------------------------
                                                                                            % Make Average Surface GUI callbacks
                                                                                            %---------------------------------------

                                                                                            % --- Executes on button press in outputAverageModelCheckBox.
                                                                                            function outputAverageModelCheckBox_Callback(hObject, eventdata, handles)
                                                                                                % hObject    handle to outputAverageModelCheckBox (see GCBO)
                                                                                                % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                                % handles    structure with handles and user data (see GUIDATA)

                                                                                                % Hint: get(hObject,'Value') returns toggle state of outputAverageModelCheckBox

                                                                                                function averageModelMeshSizeTextBox_Callback(hObject, eventdata, handles)
                                                                                                    % hObject    handle to averageModelMeshSizeTextBox (see GCBO)
                                                                                                    % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                                    % handles    structure with handles and user data (see GUIDATA)

                                                                                                    % Hints: get(hObject,'String') returns contents of averageModelMeshSizeTextBox as text
                                                                                                    %        str2double(get(hObject,'String')) returns contents of averageModelMeshSizeTextBox as a double

                                                                                                    % --- Executes during object creation, after setting all properties.
                                                                                                    function averageModelMeshSizeTextBox_CreateFcn(hObject, eventdata, handles)
                                                                                                        % hObject    handle to averageModelMeshSizeTextBox (see GCBO)
                                                                                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                                        % handles    empty - handles not created until after all CreateFcns called

                                                                                                        % Hint: edit controls usually have a white background on Windows.
                                                                                                        %       See ISPC and COMPUTER.
                                                                                                        if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
                                                                                                            set(hObject, 'BackgroundColor', 'white');
                                                                                                        end

                                                                                                        function averageSurfaceFileNameTextBox_Callback(hObject, eventdata, handles)
                                                                                                            % hObject    handle to averageSurfaceFileNameTextBox (see GCBO)
                                                                                                            % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                                            % handles    structure with handles and user data (see GUIDATA)

                                                                                                            % Hints: get(hObject,'String') returns contents of averageSurfaceFileNameTextBox as text
                                                                                                            %        str2double(get(hObject,'String')) returns contents of averageSurfaceFileNameTextBox as a double

                                                                                                            % --- Executes during object creation, after setting all properties.
                                                                                                            function averageSurfaceFileNameTextBox_CreateFcn(hObject, eventdata, handles)
                                                                                                                % hObject    handle to averageSurfaceFileNameTextBox (see GCBO)
                                                                                                                % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                                                % handles    empty - handles not created until after all CreateFcns called

                                                                                                                % Hint: edit controls usually have a white background on Windows.
                                                                                                                %       See ISPC and COMPUTER.
                                                                                                                if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
                                                                                                                    set(hObject, 'BackgroundColor', 'white');
                                                                                                                end

                                                                                                                % --- Executes on button press in averageModelButton.
                                                                                                                function averageModelButton_Callback(hObject, eventdata, handles)
                                                                                                                    % hObject    handle to averageModelButton (see GCBO)
                                                                                                                    % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                                                    % handles    structure with handles and user data (see GUIDATA)

                                                                                                                    % msgbox('Inside Average Model Button Callback fxn','Notice');

                                                                                                                    % get output average Model checkbox
                                                                                                                    a = get(handles.outputAverageModelCheckBox, 'Value');

                                                                                                                    % get meshsize resolution
                                                                                                                    b = get(handles.averageModelMeshSizeTextBox, 'String');
                                                                                                                    b = str2double(b);

                                                                                                                    filename = get(handles.averageSurfaceFileNameTextBox, 'String');

                                                                                                                    % determine output format
                                                                                                                    outputFormat = 'Amira'; % Amira is default

                                                                                                                    if (get(handles.AmiraAverageModelButton, 'Value'))
                                                                                                                        outputFormat = 'Amira';
                                                                                                                    elseif (get(handles.STLAverageModelButton, 'Value'))
                                                                                                                        outputFormat = 'STL';
                                                                                                                    end

                                                                                                                    if (a == 1)

                                                                                                                        if isnan(b)
                                                                                                                            errordlg('You must enter an integer for the meshsize', 'Wrong Input', 'modal');
                                                                                                                            return
                                                                                                                        else
                                                                                                                            b = fix(b);
                                                                                                                        end

                                                                                                                    end

                                                                                                                    handles.currentDir = MLMakeAverageModel(handles.currentDir, a, b, outputFormat, filename);

                                                                                                                    guidata(hObject, handles);

                                                                                                                    %---------------------------------------
                                                                                                                    % Make Differences Among Surface GUI callbacks
                                                                                                                    %---------------------------------------

                                                                                                                    function differencesAmongModelsMeshSizeTextBox_Callback(hObject, eventdata, handles)
                                                                                                                        % hObject    handle to differencesAmongModelsMeshSizeTextBox (see GCBO)
                                                                                                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                                                        % handles    structure with handles and user data (see GUIDATA)

                                                                                                                        % Hints: get(hObject,'String') returns contents of differencesAmongModelsMeshSizeTextBox as text
                                                                                                                        %        str2double(get(hObject,'String')) returns contents of differencesAmongModelsMeshSizeTextBox as a double

                                                                                                                        % --- Executes during object creation, after setting all properties.
                                                                                                                        function differencesAmongModelsMeshSizeTextBox_CreateFcn(hObject, eventdata, handles)
                                                                                                                            % hObject    handle to differencesAmongModelsMeshSizeTextBox (see GCBO)
                                                                                                                            % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                                                            % handles    empty - handles not created until after all CreateFcns called

                                                                                                                            % Hint: edit controls usually have a white background on Windows.
                                                                                                                            %       See ISPC and COMPUTER.
                                                                                                                            if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
                                                                                                                                set(hObject, 'BackgroundColor', 'white');
                                                                                                                            end

                                                                                                                            % --- Executes on button press in differencesAmongModelsButton.
                                                                                                                            function differencesAmongModelsButton_Callback(hObject, eventdata, handles)
                                                                                                                                % hObject    handle to differencesAmongModelsButton (see GCBO)
                                                                                                                                % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                                                                % handles    structure with handles and user data (see GUIDATA)

                                                                                                                                % msgbox('Inside Differences Among Models Button Callback fxn','Notice');

                                                                                                                                % get meshsize resolution
                                                                                                                                b = get(handles.differencesAmongModelsMeshSizeTextBox, 'String');
                                                                                                                                b = str2double(b);

                                                                                                                                if isnan(b)
                                                                                                                                    errordlg('You must enter an integer for the meshsize', 'Wrong Input', 'modal');
                                                                                                                                    return
                                                                                                                                else
                                                                                                                                    b = fix(b);
                                                                                                                                end

                                                                                                                                % determine output format
                                                                                                                                compare = 'Amira'; % Amira is default

                                                                                                                                if (get(handles.AmiraDifferencesAmongModelsButton, 'Value'))
                                                                                                                                    compare = 'Amira';
                                                                                                                                elseif (get(handles.STLDifferencesAmongModelsButton, 'Value'))
                                                                                                                                    compare = 'STL';
                                                                                                                                end

                                                                                                                                % define comparison model. 'average" or 'specify' are options
                                                                                                                                compareTo = 'average';

                                                                                                                                if (get(handles.AverageDifferencesAmongModelsRadioButton, 'Value'))
                                                                                                                                    compareTo = 'average';
                                                                                                                                elseif (get(handles.SpecifyDifferencesAmongModelsRadioButton, 'Value'))
                                                                                                                                    compareTo = 'specify';
                                                                                                                                end

                                                                                                                                handles.currentDir = MLDifferencesAmongModels(handles.currentDir, compareTo, compare, b);

                                                                                                                                guidata(hObject, handles);

                                                                                                                                % --- Executes on button press in distancesRadioButton.
                                                                                                                                function distancesRadioButton_Callback(hObject, eventdata, handles)
                                                                                                                                    % hObject    handle to distancesRadioButton (see GCBO)
                                                                                                                                    % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                                                                    % handles    structure with handles and user data (see GUIDATA)

                                                                                                                                    % Hint: get(hObject,'Value') returns toggle state of distancesRadioButton

                                                                                                                                    % --- Executes on button press in centroidRadioButton.
                                                                                                                                    function centroidRadioButton_Callback(hObject, eventdata, handles)
                                                                                                                                        % hObject    handle to centroidRadioButton (see GCBO)
                                                                                                                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                                                                                                                        % handles    structure with handles and user data (see GUIDATA)

                                                                                                                                        % Hint: get(hObject,'Value') returns toggle state of centroidRadioButton
