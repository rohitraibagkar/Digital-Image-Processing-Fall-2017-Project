classdef imProcessor
    % The class created for image processing.
    %   Detailed explanation goes here
    
    properties
        
        img                 % the variable where input image will be stored...
        auxImg
        imgProcessed        % the variable where processed image will be stored...
        randNumArray        % array to store random numbers...
        imgInfo             % variable to store image information...
        
        threshold           % the variable where value of threshold pixel will be stored...
        constant            % constant multiplier for log and gamma operations...
        gam_ma              % gamma value for power transform...
        bitPlane            % Stores the numbe of bit
        shearConstant       % stores constant for shear
        theta               % stores angle for rotation
        
        fileName            % property where filename of input image is stored...
        pathName            % property where path of input image is stored...
        filterIndex         % property where filterindex of input image is stored...
        
        meanVal             % property of imProcessor class where mean of histogram is stored...
        stdDev              % property of imProcessor class where standard deviaton is stored...
        norm_hist_data      % property of imProcessor class where normalized histogram data is saved...
        
        kernelSize          % property of imProcessor class where size of kernel is stored...
        arraySum            % property of imProcessor class where sum of array is stored...
        arrayProduct        % stores product of array elements
        arrayOfDifference   % stores difference of array elements.
        
        gaussKernel         % property of imProcessor class where gaussian kernel is stored...
        laplacianKernel     % property of imProcessor class where laplacian kernel is stored...
        laplacianKernelType % property of imProcessor class where laplacian kernel type is stored...
        
        cutOff              % property where cutoff frequency is stored...
        lowPass             % Low pass filter...
        highPass            % High pass filter...
        laplacianFDomain    % laplacian filter in Frequency domain...
        
        c0                  % center of band
        W                   % width of band
        bandPass            % band-pass filter
        bandReject          % band-reject filter
        
        sortedArray         % Sorted array of subregion
        medianIntensity     % median intensity for order-statistics filter
        minIntensity        % min intensity for order-statistics filter
        maxIntensity        % max intensity for order-statistics filter
        midIntensity        % midpoint intensity for order-statistics filter
        alphaTrimmedArray   % contains alpha-trimmed array output of subregion
        
    end     % end of imProcessor class properties...
    
    methods
        
        function imProcess = getImg (imProcess) % this function helps to get image...
            
            [imProcess.fileName, imProcess.pathName, imProcess.filterIndex] = uigetfile('All files', 'Please Select Input Image');
            imProcess.img = imread(imProcess.fileName);  % the command takes image and stores in to global variable..
            imProcess.imgInfo = imfinfo(imProcess.fileName);
            imProcess.imgProcessed = uint8(zeros(size(imProcess.img)));
            clc;
            %disp(imProcess.imgInfo);
            
        end
        
        function imProcess = writeNsaveImage (imProcess) % This finction saves the image
            
            imgName = sprintf('%s_modified.%s', imProcess.fileName, imProcess.imgInfo.Format);
            imwrite(imProcess.imgProcessed, imgName, imProcess.imgInfo.Format);
            
        end
        
        function imProcess = selectROIorImg (imProcess) % this function selects ROI 
            
            regionSelection = {'Select region of interest of Processed Image', 'Select complete processed Image'};
            [s, v] = listdlg('ListString', regionSelection, 'SelectionMode', 'single',...
                            'ListSize', [250 100], 'InitialValue', [1], 'Name', 'Select Region',...
                            'PromptString', 'Please select region of interest :',...
                            'OKString', 'Select', 'CancelString', 'Cancel');
            
            if v == 1
                
                switch s;
                    case 1;
                        imProcess.img = imcrop(imProcess.imgProcessed);
                    case 2;
                        imProcess.img = imProcess.imgProcessed;
                    otherwise
                        
                end
            end
            
        end
        
        function imProcess = showOriginal(imProcess)    % functon to show original image...
            
            imshow(imProcess.img);
            
        end
        
        function imProcess = showProcessed(imProcess)   % function to show only processed image...
            
            imshow(imProcess.imgProcessed);
            
        end
        
        function imProcess = showVariant(imProcess)     % function to variant in log transforms...
            
            if imProcess.constant
                imProcess.constant = uint8(imProcess.constant);
                imshow(imProcess.constant * imProcess.imgProcessed);
            end
            
        end
        
        function imProcess = thrshldPixlVal (imProcess) % this function gets threshold value of pixel for thresholding...
           
            options.Resize='on';
            options.WindowStyle='normal';
            options.Interpreter='tex';
            imProcess.threshold = str2double(inputdlg({'Enter threshold value of Pixel...'},...
                                            'Threshold Pixel value', [1 50], {'0'}, options));
           
        end
        
        function imProcess = getRandNum (imProcess) % gets random number matrix...
            
            imProcess.randNumArray = rand (numrows(imProcess.img), numcols(imProcess.img));
            
        end
        
        % ================= function for problem statement 1 ======================
        
        function imProcess = drawHist (imProcess) % Draws histogram
            
            pixelvals = unique(imProcess.img);
            mySum = 0;
            sumOfProb = zeros(size(pixelvals));
            newPixelVals = zeros(size(pixelvals));
            hist_data = zeros(size(pixelvals));
            imProcess.norm_hist_data = zeros(size(pixelvals));
                        
            for n = 1:1:numrows(pixelvals);
                for x = 1:1:numrows(imProcess.img);
                    for y = 1:1:numcols(imProcess.img);
                        
                        if pixelvals(n,:) == imProcess.img(x,y);
                            hist_data(n,:) = hist_data(n,:) + 1;
                            imProcess.norm_hist_data(n,:) = (hist_data(n,:))/(numrows(imProcess.img)*numcols(imProcess.img));
                        end
                    end
                end
            end
            
            imProcess.meanVal = 0;
            imProcess.stdDev = 0;
            
            for n = 1:1:numrows(pixelvals);
                imProcess.meanVal = imProcess.meanVal + (pixelvals(n,:)*imProcess.norm_hist_data(n,:));
            end
            
            for n = 1:1:numrows(pixelvals);
                imProcess.stdDev = imProcess.stdDev +(((pixelvals(n,:) - imProcess.meanVal)^2)*imProcess.norm_hist_data(n,:));
            end
            
            imProcess.stdDev = sqrt(double(imProcess.stdDev));
            
            subplot(2,1,1);     bar(pixelvals, hist_data);
            xlabel('Intensity Scales (Values of Pixels)');
            ylabel('Number of Pixels');
            title('Unnormalized Histogram');
            grid on;
            grid minor;
            legend(sprintf('Mean = %d\nStd. Deviation = %f', imProcess.meanVal, imProcess.stdDev));
            subplot(2,1,2);     bar(pixelvals, imProcess.norm_hist_data);
            xlabel('Intensity Scales (Values of Pixels)');
            ylabel('Distribution of Pixels');
            title('Normalized Histogram');
            grid on;
            grid minor;
            legend(sprintf('Mean = %d\nStd. Deviation = %f', imProcess.meanVal, imProcess.stdDev));
            
        end     % end of Histogram drawing function...
        % ================== end of function for problem statement 1 ==============
        
        % ================== function for histogram equalization ==========
        
        function imProcess = myHistEqualization (imProcess) % Equalizes the histogram
            
            mySum = 0;
            pixelvals = unique(imProcess.img);
            sumOfProb = zeros(size(imProcess.norm_hist_data));
            newPixelVals = zeros(size(imProcess.norm_hist_data));
            for n = 1:1:numrows(imProcess.norm_hist_data)
                mySum  = mySum + imProcess.norm_hist_data(n);
                newPixelVals(n,:) = mySum*(2^imProcess.imgInfo.BitDepth -1);
                sumOfProb(n, :) = mySum;
            end
            
            for n = 1:1:numrows(pixelvals)
                for x = 1:1:numrows(imProcess.img)
                    for y = 1:1:numcols(imProcess.img)
                        if imProcess.img(x,y) == pixelvals(n,:)
                            imProcess.imgProcessed(x,y) = newPixelVals(n,:);
                        end
                    end
                end
            end
            imProcess.imgProcessed = uint8(imProcess.imgProcessed);
            imProcess.showProcessed;
            
        end
        
        % ================== end of function for histogram eq.=============
        
        % ================== Affine transformations =======================
        
        function imProcess = shearVertical (imProcess) % Vertial Shear
            
            for z = 1:1:size(imProcess.img, 3);
                for x = 1:1:size(imProcess.img, 1);
                    for y = 1:1:size(imProcess.img, 2);
                        
                        sampleArray(uint64(x + imProcess.shearConstant*y), y) = imProcess.img(x,y);
                        
                    end
                end
            end
            
            imProcess.imgProcessed = sampleArray;
            
        end
        
        function imProcess = shearHorizontal (imProcess) % Horizontal Shear
            
            for z = 1:1:size(imProcess.img, 3);
                for x = 1:1:size(imProcess.img, 1);
                    for y = 1:1:size(imProcess.img, 2);
                        
                        sampleArray(x, uint64(imProcess.shearConstant*x + y)) = imProcess.img(x,y);
                        
                    end
                end
            end
            
            imProcess.imgProcessed = sampleArray;
            
        end
        
        function imProcess = rotateImg (imProcess) % Image Rotation
            
            for z = 1:1:size(imProcess.img, 3);
                for x = 1:1:size(imProcess.img, 1);
                    for y = 1:1:size(imProcess.img, 2);
                        
                        xPrime = uint64((x*cos(imProcess.theta)) - (y*sin(imProcess.theta)) + size(imProcess.img, 1)*sqrt(2));
                        yPrime = uint64((x*sin(imProcess.theta)) + (y*cos(imProcess.theta)) + size(imProcess.img, 1)*sqrt(2));
                        sampleArray(xPrime, yPrime) = imProcess.img(x,y);
                        
                    end
                end
            end
            
            imProcess.imgProcessed = sampleArray;
            
        end
        
        function imProcess = getAuxImg (imProcess) % gets auxialiary image
            
            imProcess.auxImg = imProcess.img;
            imProcess = imProcess.getImg;
            
        end
        
        function imProcess = blendImg (imProcess) % blends the two images...
            
            imProcess.imgProcessed = imProcess.constant*imProcess.img + (1-imProcess.constant)*imProcess.auxImg;
            
        end
        
        function imProcess = brightnessControl (imProcess) % brightness control of images
            
            imProcess.imgProcessed = imProcess.constant + imProcess.img;
            
        end
        
        % ================== End of Affine transformations ================
        
        % ================== Piecewise linear transformation ==============
        
        function imProcess = thresholdingImage (imProcess)
            
            imProcess = imProcess.thrshldPixlVal;
            imProcess.imgProcessed = imProcess.img;
            
            for z = 1:1:size(imProcess.imgProcessed, 3);
                for x = 1:1:size(imProcess.imgProcessed, 1);
                    for y = 1:1:size(imProcess.imgProcessed, 2);
                        
                        if imProcess.imgProcessed(x,y,z) >= imProcess.threshold;
                            imProcess.imgProcessed(x,y,z) = 255;
                        elseif imProcess.imgProcessed(x,y,z) < imProcess.threshold;
                            imProcess.imgProcessed(x,y,z) = 0;
                        end
                        
                    end
                end
            end
            
        end
        
        function imProcess = contrastStretching (imProcess)
            
            pixelVals = unique(imProcess.img);
            imProcess.imgProcessed = imProcess.img;
            
            for z = 1:1:size(imProcess.imgProcessed, 3);
                for x = 1:1:size(imProcess.imgProcessed, 1);
                    for y = 1:1:size(imProcess.imgProcessed, 2);
                        
                        imProcess.imgProcessed(x, y, z) = (imProcess.img(x,y,z) - min(pixelVals))*(255/(max(pixelVals) - min(pixelVals)));
                        
                    end
                end
            end
            
            
        end
        
        function imProcess = intensityPass (imProcess)
            
            prompt = {'Enter low intensity value: ',...
                'Enter high intensity value: '};
            title = 'Intensity Band';
            num_lines = [1 60];
            default_ans = {'80', '180'};
            options.Resize='on';    options.WindowStyle='normal';   options.Interpreter='tex';
            intensityBand = inputdlg(prompt, title, num_lines, default_ans, options);
            low = str2double(intensityBand{1,:});   high = str2double(intensityBand{2,:});
            
            for z = 1:1:size(imProcess.img, 3);
                for x = 1:1:size(imProcess.img, 1);
                    for y = 1:1:size(imProcess.img, 2);
                        
                        if (imProcess.img(x,y,z) >= low) && (imProcess.img(x,y,z) <= high)
                            
                            imProcess.imgProcessed(x,y,z) = imProcess.img(x,y,z);
                        end
                        
                    end
                end
            end
            
        end
        
        function imProcess = intensityBoost (imProcess)
            
            prompt = {'Enter low intensity value: ','Enter high intensity value: ', 'Enter boost level value:'};
            title = 'Intensity Band';
            num_lines = [1 60];
            default_ans = {'80', '180', '240'};
            options.Resize='on';    options.WindowStyle='normal';   options.Interpreter='tex';
            intensityBand = inputdlg(prompt, title, num_lines, default_ans, options);
            low = str2double(intensityBand{1,:});   high = str2double(intensityBand{2,:});
            boostLevel = str2double(intensityBand{3,:});
            
            imProcess.imgProcessed = imProcess.img;
            
            for z = 1:1:size(imProcess.img, 3);
                for x = 1:1:size(imProcess.img, 1);
                    for y = 1:1:size(imProcess.img, 2);
                        
                        if (imProcess.img(x,y,z) >= low) && (imProcess.img(x,y,z) <= high)
                            
                            imProcess.imgProcessed(x,y,z) = uint8(boostLevel);
                        end
                        
                    end
                end
            end
            
        end
        
        function imProcess = bitPlaneSlicer (imProcess)
            
            imProcess.imgProcessed = imProcess.img;            
            
            for z = 1:1:size(imProcess.imgProcessed, 3);
                for x = 1:1:size(imProcess.imgProcessed, 1);
                    for y = 1:1:size(imProcess.imgProcessed, 2);
                        
                        if imProcess.imgProcessed(x,y,z) <= ((2^imProcess.bitPlane) - 1) && imProcess.imgProcessed(x,y,z) >= ((2^(imProcess.bitPlane-1)) - 1)
                            imProcess.imgProcessed(x,y,z) = imProcess.imgProcessed(x,y,z);
                        else
                            imProcess.imgProcessed(x,y,z) = 0;
                        end
                        
                    end
                end
            end
            
        end
        
        % ================== end of Piecewise linear transformation =======
        
        % ================== functions for problem statement 4 ============
        
        function imProcess = getNegative(imProcess)
            
            for z = 1:1:size(imProcess.img, 3);
                for x = 1:1:numrows(imProcess.img);
                    for y = 1:1:numcols(imProcess.img);
                        imProcess.imgProcessed(x,y,z) = uint16(((2^imProcess.imgInfo.BitDepth)-1) - imProcess.img(x,y,z));
                    end
                end
            end
            
            imProcess.showProcessed;
            
        end     % end of getNegative method of imProcessor...
        
        function imProcess = getLogTransform(imProcess)
            
            for z = 1:1:size(imProcess.img, 3);
                for x = 1:1:numrows(imProcess.img);
                    for y = 1:1:numcols(imProcess.img);
                        imProcess.imgProcessed(x,y,z) = uint8(log(1 + double(imProcess.img(x,y,z))));
                    end
                end
            end
            imProcess.showProcessed;
        end
        
        function imProcess = getPowerTransform(imProcess)
            
            imProcess.imgProcessed = uint8(imProcess.constant .* (double(imProcess.img) .^ imProcess.gam_ma));
            imProcess.showProcessed;
        end
        
        % ================== end of problem statement 4 ===================
        
        % ================== solution of Prob 5 ===========================
        
        function imProcess = sumOfArray (imProcess, myArray) % this function sums all the elements in the array...
            
            imProcess.arraySum = 0;
            for z = 1:1:size(myArray, 3)
                for x = 1:1:size(myArray, 1)
                    for y = 1:1:size(myArray, 2)
                        imProcess.arraySum = imProcess.arraySum + myArray(x,y,z); %sum of elements
                    end
                end
            end
            
        end
        
        function imProcess = getKernelSize (imProcess) % this function gets threshold value of pixel for thresholding...
           
            options.Resize='on';
            options.WindowStyle='normal';
            options.Interpreter='tex';
            imProcess.kernelSize = str2double(inputdlg({'Enter size of Kernel (Odd number only)...'},...
                                            'Kernel Size', [1 50], {'3'}, options));
           
        end
        
        function imProcess = smoothByBox(imProcess) % uses box filter to smooth the image...
            
            imProcess = imProcess.getKernelSize;
            boxKernel = ones(imProcess.kernelSize);
            imProcess = imProcess.sumOfArray(boxKernel);
            mySum = imProcess.arraySum;
            newImage = padarray(imProcess.img, [(size(boxKernel, 1) - 1)/2 (size(boxKernel, 2) - 1)/2]);
            for z = 1:1:size(newImage, 3);
                for x = 1:1:(size(newImage, 1) - (size(boxKernel, 1)-1));
                    for y = 1:1:(size(newImage, 2) - (size(boxKernel, 2)-1));
                        piece = newImage(x:x+(size(boxKernel, 1)-1), y:y+(size(boxKernel, 2)-1));
                        imProcess = imProcess.sumOfArray((boxKernel/mySum) .* double(piece));
                        imProcess.imgProcessed(x,y,z) = uint8(imProcess.arraySum);
                    end
                end
            end
            imProcess.showProcessed;
        end
        
        function imProcess = differenceDetector (imProcess, anyArray)
            
            rawArray = zeros(size(anyArray, 1), size(anyArray, 2));
            
            for x = 1:1:size(anyArray, 1)
                for y = 1:1:size(anyArray, 2)
                    
                    rawArray(x,y)= anyArray(x,y) - anyArray(size(anyArray, 1) - (size(anyArray, 1)-1)/2, size(anyArray, 2) - (size(anyArray, 2)-1)/2);
                    
                end
            end
            
            imProcess.arrayOfDifference = rawArray;
            
        end
        
        function imProcess = fuzzyEdgeDetection (imProcess)
            
            imProcess = imProcess.getKernelSize;
            boxKernel = ones(imProcess.kernelSize);
            imProcess.imgProcessed = imProcess.img;
            newImage = padarray(imProcess.img, [(size(boxKernel, 1) - 1)/2 (size(boxKernel, 2) - 1)/2]);
            
            for z = 1:1:size(newImage, 3);
                for x = 1:1:(size(newImage, 1) - (size(boxKernel, 1)-1));
                    for y = 1:1:(size(newImage, 2) - (size(boxKernel, 2)-1));
                        piece = newImage(x:x+(size(boxKernel, 1)-1), y:y+(size(boxKernel, 2)-1));
                        imProcess = imProcess.differenceDetector(double(piece) .* boxKernel);
                        
                        if imProcess.arrayOfDifference(1,2) == 0 && imProcess.arrayOfDifference(2,3) == 0;
                            imProcess.imgProcessed(x, y, z) = 255;
                        elseif imProcess.arrayOfDifference(2,3) == 0 && imProcess.arrayOfDifference(3,2) == 0;
                            imProcess.imgProcessed(x, y, z) = 255;
                        elseif imProcess.arrayOfDifference(3,2) == 0 && imProcess.arrayOfDifference(2,1) == 0;
                            imProcess.imgProcessed(x, y, z) = 255;
                        elseif imProcess.arrayOfDifference(2,1) == 0 && imProcess.arrayOfDifference(1,2) == 0;
                            imProcess.imgProcessed(x, y, z) = 255;
                        else
                            imProcess.imgProcessed(x, y, z) = 0;
                        end
                        
                    end
                end
            end
            
        end
        
        function imProcess = sobelEdgeDetector (imProcess)
            
            sobelX = [-1 -2 -1;0 0 0;1 2 1];    sobelY = [-1 0 1;-2 0 2;-1 0 1];
            boxKernel = ones(3);
            
            newImage = padarray(imProcess.img, [(size(boxKernel, 1) - 1)/2 (size(boxKernel, 2) - 1)/2]);
            
            for z = 1:1:size(newImage, 3);
                for x = 1:1:(size(newImage, 1) - (size(boxKernel, 1)-1));
                    for y = 1:1:(size(newImage, 2) - (size(boxKernel, 2)-1));
                        piece = newImage(x:x+(size(boxKernel, 1)-1), y:y+(size(boxKernel, 2)-1));
                        imProcess = imProcess.sumOfArray(double(piece).*sobelX);    gX = imProcess.arraySum;
                        imProcess = imProcess.sumOfArray(double(piece).*sobelY);    gY = imProcess.arraySum;
                        imProcess.imgProcessed(x, y, z) = sqrt((gX^2)+(gY^2));
                        
                    end
                end
            end
            
            
        end
        
        function imProcess = getGaussKernelSize (imProcess) % selects size of the gaussian kernel...
            
            prompt = {'Enter size of the filter (only Odd number):',...
                      'Enter constant, K:', 'Enter Sigma:'};
            title = 'Gaussian Filter Parameters';
            num_lines = [1 50];
            default_ans = {'3', '1', '1'};
            options.Resize='on';    options.WindowStyle='normal';   options.Interpreter='tex';
            kernelParameters = inputdlg(prompt, title, num_lines, default_ans, options);
            order = str2double(kernelParameters{1,:});  k = str2double(kernelParameters{2,:});  sig_ma = str2double(kernelParameters{3,:});
            
            filterGauss = zeros(order);
            
            for x = 1:1:size(filterGauss, 1)
                for y = 1:1:size(filterGauss, 2)
                    
                    radius = sqrt((x-(size(filterGauss, 1)-((size(filterGauss, 1)-1)/2)))^2 + (y-(size(filterGauss, 2)-((size(filterGauss, 2)-1)/2)))^2);
                    filterGauss(x, y) = k * exp(-(radius^2)/(2*sig_ma^2));
                    
                end
            end
            
            imProcess.gaussKernel = filterGauss;
            %disp(imProcess.gaussKernel);
            
        end
        
        function imProcess = smoothByGauss (imProcess) % smooths by the gaussian filter kernel...
            
            imProcess = imProcess.getGaussKernelSize;
            %disp(imProcess.gaussKernel);
            imProcess = imProcess.sumOfArray(imProcess.gaussKernel);
            mySum = imProcess.arraySum;
            newImage = padarray(imProcess.img, [(size(imProcess.gaussKernel, 1) - 1)/2 (size(imProcess.gaussKernel, 2) - 1)/2]);
            
            for z = 1:1:size(newImage, 3);
                for x = 1:1:(size(newImage, 1) - (size(imProcess.gaussKernel, 1)-1));
                    for y = 1:1:(size(newImage, 2) - (size(imProcess.gaussKernel, 2)-1));
                        piece = newImage(x:x+(size(imProcess.gaussKernel, 1)-1), y:y+(size(imProcess.gaussKernel, 2)-1));
                        imProcess = imProcess.sumOfArray((imProcess.gaussKernel/mySum) .* double(piece));
                        imProcess.imgProcessed(x,y,z) = uint8(imProcess.arraySum);
                    end
                end
            end
            imProcess = imProcess.showProcessed;
            
        end
        
        function imProcess = createLaplacianKernelFilter (imProcess) % creates laplacian filter kernel...
            
            imProcess = imProcess.getKernelSize;
            laplacianKernels = {'Laplacian Kernel : Type 1', 'Laplacian Kernel : Type 2',...
                                'Laplacian Kernel : Type 3', 'Laplacian Kernel : Type 4'};
            [s, v] = listdlg('ListString', laplacianKernels, 'SelectionMode', 'single',...
                            'ListSize', [250 100], 'InitialValue', [1], 'Name', 'Laplacian Kernel',...
                            'PromptString', 'Please select type of Laplacian Kernel :',...
                            'OKString', 'Select', 'CancelString', 'Cancel');
            
            if v == 1;
                
                switch s;
                    
                    case 1; % type B laplacian kernel including diagonal terms (c = -1)...
                        lapKernel = ones(imProcess.kernelSize);
                        total = (myArraySum(lapKernel) - 1);
                        lapKernel(size(lapKernel, 1) - (size(lapKernel, 1) - 1)/2, size(lapKernel, 2) - (size(lapKernel, 2) - 1)/2) = -total;
                        imProcess.laplacianKernel = lapKernel;
                        imProcess.laplacianKernelType = 'B';
                        
                    case 2; % type D laplacian kernel including diagonal terms (c = 1)...
                        lapKernel = ones(imProcess.kernelSize);
                        total = (myArraySum(lapKernel) - 1);
                        lapKernel = -lapKernel;
                        lapKernel(size(lapKernel, 1) - (size(lapKernel, 1) - 1)/2, size(lapKernel, 2) - (size(lapKernel, 2) - 1)/2) = total;
                        imProcess.laplacianKernel = lapKernel;
                        imProcess.laplacianKernelType = 'D';
                        
                    case 3; % type A, normal laplacian kernel (c = -1)...
                        lapKernel = zeros(imProcess.kernelSize);
                        lapKernel(size(lapKernel, 1) - (size(lapKernel, 1) - 1)/2, :) = 1;
                        lapKernel(:, size(lapKernel, 2) - (size(lapKernel, 2) - 1)/2) = 1;
                        total = (myArraySum(lapKernel) - 1);
                        lapKernel(size(lapKernel, 1) - (size(lapKernel, 1) - 1)/2, size(lapKernel, 2) - (size(lapKernel, 2) - 1)/2) = -total;
                        imProcess.laplacianKernel = lapKernel;
                        imProcess.laplacianKernelType = 'A';
                        
                    case 4; % type C, other normal laplacian kernel (c = 1)...
                        lapKernel = zeros(imProcess.kernelSize);
                        lapKernel(size(lapKernel, 1) - (size(lapKernel, 1) - 1)/2, :) = 1;
                        lapKernel(:, size(lapKernel, 2) - (size(lapKernel, 2) - 1)/2) = 1;
                        total = (myArraySum(lapKernel) - 1);
                        lapKernel = -lapKernel;
                        lapKernel(size(lapKernel, 1) - (size(lapKernel, 1) - 1)/2, size(lapKernel, 2) - (size(lapKernel, 2) - 1)/2) = total;
                        imProcess.laplacianKernel = lapKernel;
                        imProcess.laplacianKernelType = 'C';
                        
                    otherwise
                        disp('Please select Gaussian Kernel of right size ...');
                end
                disp(imProcess.laplacianKernel);
                %disp(imProcess.laplacianKernelType);
                
            end
            
        end
        
        function imProcess = sharpenByLaplacian(imProcess) % this function sharpens the image by laplacian kernel...
            
            imProcess = imProcess.createLaplacianKernelFilter;
            newImage = padarray(imProcess.img, [(size(imProcess.laplacianKernel, 1) - 1)/2 (size(imProcess.laplacianKernel, 2) - 1)/2]);
            
            for z = 1:1:size(newImage, 3);
                for x = 1:1:(size(newImage, 1) - (size(imProcess.laplacianKernel, 1)-1));
                    for y = 1:1:(size(newImage, 2) - (size(imProcess.laplacianKernel, 2)-1));
                        piece = newImage(x:x+(size(imProcess.laplacianKernel, 1)-1), y:y+(size(imProcess.laplacianKernel, 2)-1));
                        imProcess = imProcess.sumOfArray(imProcess.laplacianKernel .* double(piece));
                        imProcess.imgProcessed(x,y,z) = uint8(imProcess.arraySum);
                    end
                end
            end
            figure;
            imProcess = imProcess.showProcessed;
            switch imProcess.laplacianKernelType;
                case 'A'
                    imProcess.imgProcessed = imProcess.img - imProcess.imgProcessed;
                case 'B'
                    imProcess.imgProcessed = imProcess.img - imProcess.imgProcessed;
                case 'C'
                    imProcess.imgProcessed = imProcess.img + imProcess.imgProcessed;
                case 'D'
                    imProcess.imgProcessed = imProcess.img + imProcess.imgProcessed;
                otherwise
                    %do nothing
            end
            
        end
        
        function imProcess = unsharpMasking(imProcess) % does unsharp masking...
            
            smoothingMethod = {'Box Kernel', 'Gaussian Kernel'};
            [s, v] = listdlg('ListString', smoothingMethod, 'SelectionMode', 'single',...
                            'ListSize', [250 100], 'InitialValue', [1], 'Name', 'Gaussian Kernel',...
                            'PromptString', 'Please select type of Kernel for smoothing :',...
                            'OKString', 'Select', 'CancelString', 'Cancel');
            if v == 1;
                
                switch s;
                    case 1;
                        imProcess = imProcess.smoothByBox;
                    case 2;
                        imProcess = imProcess.smoothByGauss;
                    otherwise
                        % do nothing
                end
            end
            
            imProcess.imgProcessed = imProcess.img - imProcess.imgProcessed; % mask
            figure;
            imProcess = imProcess.showProcessed; % show mask
            imProcess.imgProcessed = imProcess.img + imProcess.imgProcessed;
            
        end
        
        % =========== Frequency Domain analysis of Image ==================
        
        function imProcess = getCutOff (imProcess) % this function gets cutoff frequency...
            
            options.Resize='on';
            options.WindowStyle='normal';
            options.Interpreter='tex';
            imProcess.cutOff = str2double(inputdlg({'Enter cut-off frequency ...'},...
                                            'Cut-Off Frequency', [1 50], {'.25'}, options));
            
        end
        
        function imProcess = getLowHighPassFilter (imProcess)
            
            [m,n] = freqspace([2*size(imProcess.img, 1) 2*size(imProcess.img, 2)], 'meshgrid');
            filterMask = zeros(2*size(imProcess.img, 1), 2*size(imProcess.img, 2));
            
            kernelType = {'Ideal', 'Gaussian', 'Butterworth', 'Laplacian'};
            [s, v] = listdlg('ListString', kernelType, 'SelectionMode', 'single',...
                            'ListSize', [250 100], 'InitialValue', [1], 'Name', 'Filter Type',...
                            'PromptString', 'Please select type of Filter for processing :',...
                            'OKString', 'Select', 'CancelString', 'Cancel');
            
            if v == 1;
                
                switch s;
                    case 1; % Ideal filter will be selected...
                        
                        imProcess = imProcess.getCutOff; % gets cut off frequency...
                        
                        for x = 1:1:size(filterMask, 1)
                            for y = 1:1:size(filterMask, 2)
                                filterElement = sqrt(m(x,y)^2 + n(x,y)^2);
                                
                                if filterElement <= imProcess.cutOff;
                                    filterMask(x,y) = 1;
                                elseif filterElement > imProcess.cutOff;
                                    filterMask(x,y) = 0;
                                else
                                    filterMask(x,y) = 0;
                                end
                                %lowPassFilter(x,y) = sqrt(m(x,y)^2 + n(x,y)^2);
                            end
                        end
                        
                        imProcess.lowPass = filterMask;
                        imProcess.highPass = 1 - filterMask;
                        
                    case 2; % Gaussian filter will be selected...
                        
                        imProcess = imProcess.getCutOff; % gets cut off frequency...
                        
                        for x = 1:1:size(filterMask, 1)
                            for y = 1:1:size(filterMask, 2)
                                D_square = m(x,y)^2 + n(x,y)^2;
                                filterMask(x, y) = exp(-D_square / 2*(imProcess.cutOff^2));
                                
                            end
                        end
                        
                        imProcess.lowPass = filterMask;
                        imProcess.highPass = 1 - filterMask;
                        
                    case 3; % Butterworth filter will be selected...
                        
                        imProcess = imProcess.getCutOff; % gets cut off frequency...
                        
                        options.Resize='on';    options.WindowStyle='normal';   options.Interpreter='tex';
                        filterOrder = str2double(inputdlg({'Enter order of Butterworth Filter ...'},...
                            'Order of Filter', [1 50], {'1'}, options)); % order of filter, n
                        
                        for x = 1:1:size(filterMask, 1)
                            for y = 1:1:size(filterMask, 2)
                                D = sqrt(m(x,y)^2 + n(x,y)^2);
                                filterMask(x, y) = 1/(1 + (D/imProcess.cutOff)^(2*filterOrder));
                                
                            end
                        end
                        
                        imProcess.lowPass = filterMask;
                        imProcess.highPass = 1 - filterMask;
                        
                    case 4; % Laplacian will be selected...
                        
                        for x = 1:1:size(filterMask, 1)
                            for y = 1:1:size(filterMask, 2)
                                D_square = m(x,y)^2 + n(x,y)^2;
                                filterMask(x, y) = 1 + 4*(pi^2)*D_square;
                                
                            end
                        end
                        
                        imProcess.laplacianFDomain = filterMask;
                        
                    otherwise
                        % do nothing
                end
            end
            
        end
        
        function imProcess = fourierFiltering (imProcess)
            
            imProcess.img = im2double(imProcess.img);
            paddedImg = padarray(imProcess.img, [size(imProcess.img, 1) size(imProcess.img,2)], 'post');
            
            for x = 1:1:size(paddedImg, 1)
                for y = 1:1:size(paddedImg, 2)
                    paddedImg(x, y) = paddedImg(x, y)*((-1)^(x + y));
                end
            end
            
            imgFouriered = fft2(paddedImg);
            processType = {'Smoothing', 'Sharpening', 'Use Laplacian', 'Unsharp Masking',...
                'High-Boost Filtering','High-Frequency-Emphasis Filtering', 'More general High-Frequency-Emphasis Filtering'};
            [s, v] = listdlg('ListString', processType, 'SelectionMode', 'single',...
                            'ListSize', [250 100], 'InitialValue', [1], 'Name', 'Processing Type',...
                            'PromptString', 'Please select type of processing :',...
                            'OKString', 'Select', 'CancelString', 'Cancel');
            
            if v == 1;
                
                switch s;
                    case 1; % low pass filtering is selected
                        processedImg = imgFouriered .* imProcess.lowPass;
                    case 2; % highpass filtering is selected
                        processedImg = imgFouriered .* imProcess.highPass;
                    case 3; % laplacian is selected
                        processedImg = imgFouriered .* imProcess.laplacianFDomain;
                    case 4; % low pass filtering for unsharp masking is selected...
                        processedImg = imgFouriered .* imProcess.lowPass;
                    case 5; % low pass filtering for highboost filtering is selected...
                        processedImg = imgFouriered .* imProcess.lowPass;
                    case 6; % high pass filtering for high-freq-emphasis filtering is selected...
                        options.Resize='on';    options.WindowStyle='normal';   options.Interpreter='tex';
                        kHiFreq = str2double(inputdlg({'Enter K for High-Frequency-Emphasis Filtering (K > 1)'},...
                            'High-Freq Emphasizer', [1 60], {'0.25'}, options));
                        processedImg = imgFouriered .* (1 + kHiFreq * imProcess.highPass);
                    case 7; % high pass filtering for more general high-freq-emphasis filtering is selected...
                        
                        prompt = {'Enter k1 >= 0, for High-Frequency-Emphasis Filtering:',...
                            'Enter k2 > 0, for High-Frequency-Emphasis Filtering:'};
                        title = 'High-Freq-Emphasis Parameters';
                        num_lines = [1 60];
                        default_ans = {'0.5', '0.75'};
                        options.Resize='on';    options.WindowStyle='normal';   options.Interpreter='tex';
                        kHiFreqPara = inputdlg(prompt, title, num_lines, default_ans, options);
                        k1 = str2double(kHiFreqPara{1,:});      k2 = str2double(kHiFreqPara{2,:});
                        
                        processedImg = imgFouriered .* (k1 + (k2 * imProcess.highPass));
                    otherwise
                        % do nothing
                end
            end
            
            processedImgReconstrctd = ifft2(processedImg);
            
            for x = 1:1:size(processedImgReconstrctd, 1)
                for y = 1:1:size(processedImgReconstrctd, 2)
                    
                    processedImgReconstrctd(x,y) = processedImgReconstrctd(x, y)*((-1)^(x+y));
                end
            end
            
            switch s;
                case 1;
                    imProcess.imgProcessed = processedImgReconstrctd(1:size(imProcess.img, 1), 1:size(imProcess.img, 2));
                case 2;
                    imProcess.imgProcessed = imProcess.img + processedImgReconstrctd(1:size(imProcess.img, 1), 1:size(imProcess.img, 2));
                case 3;
                    imProcess.imgProcessed = processedImgReconstrctd(1:size(imProcess.img, 1), 1:size(imProcess.img, 2));
                case 4;
                    gMask = imProcess.img - processedImgReconstrctd(1:size(imProcess.img, 1), 1:size(imProcess.img, 2));
                    imProcess.imgProcessed = imProcess.img + gMask;
                case 5;
                    options.Resize='on';    options.WindowStyle='normal';   options.Interpreter='tex';
                    kMask = str2double(inputdlg({'Enter K for High-boost Filtering (K > 1)'},...
                        'High-Boost Multiplier', [1 50], {'1.25'}, options));
                    
                    gMask = imProcess.img - processedImgReconstrctd(1:size(imProcess.img, 1), 1:size(imProcess.img, 2));
                    imProcess.imgProcessed = imProcess.img + kMask*gMask;
                    
                case 6;
                    imProcess.imgProcessed = processedImgReconstrctd(1:size(imProcess.img, 1), 1:size(imProcess.img, 2));
                case 7;
                    imProcess.imgProcessed = processedImgReconstrctd(1:size(imProcess.img, 1), 1:size(imProcess.img, 2));
            end
        end
        
        function imProcess = getBandParameters (imProcess)
            
            prompt = {'Enter the center of the Band, c0: ',...
                'Enter the width of the band, W: '};
            title = 'Band Parameters';
            num_lines = [1 60];
            default_ans = {'0.5', '0.5'};
            options.Resize='on';    options.WindowStyle='normal';   options.Interpreter='tex';
            bandPara = inputdlg(prompt, title, num_lines, default_ans, options);
            imProcess.c0 = str2double(bandPara{1,:});      imProcess.W = str2double(bandPara{2,:});
            
        end
        
        function imProcess = getBandPassRejectFilter (imProcess)
            
            imProcess = imProcess.getBandParameters;
            [m, n] = freqspace([2*size(imProcess.img, 1) 2*size(imProcess.img, 2)], 'meshgrid');
            filterMask = zeros(2*size(imProcess.img, 1), 2*size(imProcess.img, 2));
            
            filterType = {'Ideal Filter', 'Gaussian Filter', 'Butterworth Filter'};
            [s, v] = listdlg('ListString', filterType, 'SelectionMode', 'single',...
                'ListSize', [250 100], 'InitialValue', [1], 'Name', 'Filter Type',...
                'PromptString', 'Please select type of Filter for processing :',...
                'OKString', 'Select', 'CancelString', 'Cancel');
            
            if v == 1;
                
                switch s;
                    
                    case 1; % Ideal filter will be selected
                        
                        for x = 1:1:size(filterMask, 1)
                            for y = 1:1:size(filterMask, 2)
                                filterElement = sqrt(m(x,y)^2 + n(x,y)^2);
                                
                                if (filterElement >= (imProcess.c0 - (imProcess.W / 2))) && (filterElement <= (imProcess.c0 + (imProcess.W / 2)))
                                    filterMask(x, y) = 0;
                                else
                                    filterMask(x, y) = 1;
                                end
                                
                            end
                        end
                        
                        imProcess.bandReject = filterMask;
                        imProcess.bandPass = 1 - filterMask;
                        
                    case 2; % Gaussian filter will be selected
                        
                        for x = 1:1:size(filterMask, 1)
                            for y = 1:1:size(filterMask, 2)
                                D_square = m(x,y)^2 + n(x,y)^2;
                                filterMask(x, y) = 1 - exp(-(((D_square-imProcess.c0^2)/(imProcess.W*sqrt(D_square)))^2));
                                
                            end
                        end
                        
                        imProcess.bandReject = filterMask;
                        imProcess.bandPass = 1 - filterMask;
                        
                    case 3; % Butterworth filter will be selected
                        
                        options.Resize='on';    options.WindowStyle='normal';   options.Interpreter='tex';
                        filterOrder = str2double(inputdlg({'Enter order of Butterworth Filter ...'},...
                            'Order of Filter', [1 50], {'1'}, options)); % order of filter, n
                        
                        for x = 1:1:size(filterMask, 1)
                            for y = 1:1:size(filterMask, 2)
                                D = sqrt(m(x,y)^2 + n(x,y)^2);
                                filterMask(x, y) = 1/(1 + (((D*imProcess.W)/(D^2-imProcess.c0^2))^(2*filterOrder)));
                                
                            end
                        end
                        
                        imProcess.bandReject = filterMask;
                        imProcess.bandPass = 1 - filterMask;
                        
                    otherwise
                        % do nothing...
                end
            end
            
            figure;
            imshow(imProcess.bandReject);
            figure;
            imshow(imProcess.bandPass);
            
        end
        
        function imProcess = fourierBandSelectFiltering (imProcess)
                        
            imProcess.img = im2double(imProcess.img);
            paddedImg = padarray(imProcess.img, [size(imProcess.img, 1) size(imProcess.img,2)], 'post');
            
            for x = 1:1:size(paddedImg, 1)
                for y = 1:1:size(paddedImg, 2)
                    paddedImg(x, y) = paddedImg(x, y)*((-1)^(x + y));
                end
            end
            
            imgFouriered = fft2(paddedImg);
            
            processType = {'Band Reject Filtering', 'Band Pass Filtering'};
            [s, v] = listdlg('ListString', processType, 'SelectionMode', 'single',...
                            'ListSize', [250 100], 'InitialValue', [1], 'Name', 'Filtering Type',...
                            'PromptString', 'Please select type of Filtering :',...
                            'OKString', 'Select', 'CancelString', 'Cancel');
            
            if v == 1;
                
                switch s;
                    case 1; % band reject filtering is selected
                        processedImg = imgFouriered .* imProcess.bandReject;
                    case 2; % band pass filtering is selected
                        processedImg = imgFouriered .* imProcess.bandPass;
                        
                    otherwise
                        % do nothing
                end
            end
            
            processedImgReconstrctd = ifft2(processedImg);
            
            for x = 1:1:size(processedImgReconstrctd, 1)
                for y = 1:1:size(processedImgReconstrctd, 2)
                    
                    processedImgReconstrctd(x,y) = processedImgReconstrctd(x, y)*((-1)^(x+y));
                end
            end
            
            switch s;
                case 1;
                    imProcess.imgProcessed = processedImgReconstrctd(1:size(imProcess.img, 1), 1:size(imProcess.img, 2));
                case 2;
                    imProcess.imgProcessed = processedImgReconstrctd(1:size(imProcess.img, 1), 1:size(imProcess.img, 2));
%                     imProcess.imgProcessed = imProcess.img + processedImgReconstrctd(1:size(imProcess.img, 1), 1:size(imProcess.img, 2));
                otherwise
                    % do nothing...
            end
            
        end
        
        % ============= end of Frequency Domain Analysis ==================
        
        % ================== end of solution of Prob. 5 ===================
        
        
        % ================== Problem 6: Noise reduction ===================
        
        function imProcess = productOfArray (imProcess, myArray);
            
            product = 1;
            
            for x = 1:1:size(myArray, 1);
                for y = 1:1:size(myArray, 2);
                    
                    product = product * myArray(x,y);
                end
            end
            
            imProcess.arrayProduct = product;
            
        end
        
        function imProcess = arithmeticMeanFilter (imProcess) % smoothens local variations in the image...
            
            imProcess = imProcess.getKernelSize;
            boxKernel = ones(imProcess.kernelSize);
            myProduct = size(boxKernel, 1) * size(boxKernel, 2);
            newImage = padarray(imProcess.img, [(size(boxKernel, 1) - 1)/2 (size(boxKernel, 2) - 1)/2]);
            for z = 1:1:size(newImage, 3);
                for x = 1:1:(size(newImage, 1) - (size(boxKernel, 1)-1));
                    for y = 1:1:(size(newImage, 2) - (size(boxKernel, 2)-1));
                        piece = newImage(x:x+(size(boxKernel, 1)-1), y:y+(size(boxKernel, 2)-1));
                        imProcess = imProcess.sumOfArray((boxKernel/myProduct) .* double(piece));
                        imProcess.imgProcessed(x,y,z) = uint8(imProcess.arraySum);
                    end
                end
            end
            
        end
        
        function imProcess = geometricMeanFilter (imProcess) % smoothens local variations better than arithmetic mean filter...
            
            imProcess = imProcess.getKernelSize;
            boxKernel = ones(imProcess.kernelSize);
            myProduct = size(boxKernel, 1) * size(boxKernel, 2);
            newImage = padarray(imProcess.img, [(size(boxKernel, 1) - 1)/2 (size(boxKernel, 2) - 1)/2]);
            for z = 1:1:size(newImage, 3);
                for x = 1:1:(size(newImage, 1) - (size(boxKernel, 1)-1));
                    for y = 1:1:(size(newImage, 2) - (size(boxKernel, 2)-1));
                        piece = newImage(x:x+(size(boxKernel, 1)-1), y:y+(size(boxKernel, 2)-1));
                        imProcess = imProcess.productOfArray(boxKernel .* double(piece));
                        imProcess.imgProcessed(x,y,z) = (imProcess.arrayProduct^(1/myProduct));
                    end
                end
            end
            
        end
        
        function imProcess = harmonicMeanFilter (imProcess)
            
            % The harmonic mean filter works well for for salt noise but
            % fails for pepper noise. It does well also with other types of
            % noise like Gaussian noise...
            
            imProcess = imProcess.getKernelSize;
            boxKernel = ones(imProcess.kernelSize);
            myProduct = size(boxKernel, 1) * size(boxKernel, 2);
            newImage = padarray(imProcess.img, [(size(boxKernel, 1) - 1)/2 (size(boxKernel, 2) - 1)/2]);
            
            for z = 1:1:size(newImage, 3);
                for x = 1:1:(size(newImage, 1) - (size(boxKernel, 1)-1));
                    for y = 1:1:(size(newImage, 2) - (size(boxKernel, 2)-1));
                        piece = newImage(x:x+(size(boxKernel, 1)-1), y:y+(size(boxKernel, 2)-1));
                        imProcess = imProcess.sumOfArray(boxKernel ./ double(piece));
                        imProcess.imgProcessed(x,y,z) = uint8(myProduct/imProcess.arraySum);
                    end
                end
            end
            
        end
        
        function imProcess = contraHarmonicMeanFilter (imProcess)
            
            % Here Q, in this case, 'filterOrder' is called as order of the
            % filter. This filter is well suited for reducing or virtually
            % eliminating the effects of salt-and-pepper noise.
            
            % For positive values of Q, filter eliminates pepper noise. For
            % negative values of Q, the filter eliminates salt noise. It
            % cannot do both simultaneously.
            
            % Note that contraharmonic reduces to the arithmetic mean
            % filter if Q = 0, and harmonic mean filter if Q = -1.
            
            prompt = {'Enter size of the filter (only Odd number):', 'Enter order of the Filter, Q :'};
            title = 'Contraharmonic Mean Filter Parameters';
            num_lines = [1 50];
            default_ans = {'3', '1'};
            options.Resize='on';    options.WindowStyle='normal';   options.Interpreter='tex';
            filterParameters = inputdlg(prompt, title, num_lines, default_ans, options);
            filterSize = str2double(filterParameters{1,:}); filterOrder = str2double(filterParameters{2,:});
            
            boxKernel = ones(filterSize);
            newImage = padarray(imProcess.img, [(size(boxKernel, 1) - 1)/2 (size(boxKernel, 2) - 1)/2]);
            
            for z = 1:1:size(newImage, 3);
                for x = 1:1:(size(newImage, 1) - (size(boxKernel, 1)-1));
                    for y = 1:1:(size(newImage, 2) - (size(boxKernel, 2)-1));
                        piece = newImage(x:x+(size(boxKernel, 1)-1), y:y+(size(boxKernel, 2)-1));
                        region = double(piece) .* boxKernel;
                        imProcess = imProcess.sumOfArray(region .^ filterOrder);
                        denominator = imProcess.arraySum;
                        imProcess = imProcess.sumOfArray(region .^ (filterOrder + 1));
                        numerator = imProcess.arraySum;
                        imProcess.imgProcessed(x,y,z) = uint8(numerator/denominator);
                    end
                end
            end
            
        end
        
        function imProcess = orderStatFiltParamtr (imProcess, array)
            
            counter = 0;
            
            for x = 1:1:size(array, 1)
                for y = 1:1:size(array, 2)
                    
                    counter = counter + 1;
                    sortArray(counter) = array(x, y);
                    
                end
            end
            
            imProcess.sortedArray = sort(sortArray);
            imProcess.medianIntensity = median(imProcess.sortedArray);
            imProcess.minIntensity = min(imProcess.sortedArray);
            imProcess.maxIntensity = max(imProcess.sortedArray);
            imProcess.midIntensity = (imProcess.minIntensity + imProcess.maxIntensity)/2;
            
        end
        
        function imProcess = arrayTrimmer (imProcess, arrayInput, trimFactor) % this function trims the array for alpha-trimmed
            
            for iteration = 1:1:trimFactor/2
                arrayInput(:,iteration) = 0;
                arrayInput(:, size(arrayInput,2) -(iteration) +1) = 0;
                
            end
            
            imProcess.alphaTrimmedArray = arrayInput;
        end
        
        function imProcess = orderStatisticsFilter (imProcess)
            
            imProcess = imProcess.getKernelSize;
            %imProcess.imgProcessed = imProcess.img;
            boxKernel = ones(imProcess.kernelSize);
            
            filterType = {'Median Filter', 'Max Filter', 'Min Filter', 'Midpoint Filter', 'Alpha-trimmed Mean Filter'};
            [s, v] = listdlg('ListString', filterType, 'SelectionMode', 'single',...
                            'ListSize', [250 100], 'InitialValue', [1], 'Name', 'Filter Type',...
                            'PromptString', 'Please select type of Filter for processing :',...
                            'OKString', 'Select', 'CancelString', 'Cancel');
            
            if v == 1;
                switch s;
                    case 5;
                        options.Resize='on';    options.WindowStyle='normal';   options.Interpreter='tex';
                        trimFactor = str2double(inputdlg({'Enter trim factor, "d" for alpha-trimmed filter (only Even number):'},...
                            'Trim Factor', [1 50], {'2'}, options));
                end
            end
            
            newImage = padarray(imProcess.img, [(size(boxKernel, 1) - 1)/2 (size(boxKernel, 2) - 1)/2]);
            
            for z = 1:1:size(newImage, 3);
                for x = 1:1:(size(newImage, 1) - (size(boxKernel, 1)-1));
                    for y = 1:1:(size(newImage, 2) - (size(boxKernel, 2)-1));
                        piece = newImage(x:x+(size(boxKernel, 1)-1), y:y+(size(boxKernel, 2)-1));
                        imProcess = imProcess.orderStatFiltParamtr((boxKernel) .* double(piece));
                        
                        if v == 1;
                            
                            switch s;
                                case 1; % Median filter is selected...
                                    imProcess.imgProcessed(x,y,z) = uint8(imProcess.medianIntensity);
                                case 2; % Max filter is selected...
                                    imProcess.imgProcessed(x,y,z) = uint8(imProcess.maxIntensity);
                                case 3; % Min filter is selected...
                                    imProcess.imgProcessed(x,y,z) = uint8(imProcess.minIntensity);
                                case 4; % Midpoint filter is selected...
                                    imProcess.imgProcessed(x,y,z) = uint8(imProcess.midIntensity);
                                case 5; % Alpha-trimmed Mean filter is selected...
                                    imProcess = imProcess.arrayTrimmer(imProcess.sortedArray, trimFactor);
                                    imProcess = imProcess.sumOfArray(imProcess.alphaTrimmedArray);
                                    imProcess.imgProcessed(x,y,z) = (1/((size(boxKernel, 1)*size(boxKernel, 2))-trimFactor))*imProcess.arraySum;
                                otherwise
                                    % do nothing...
                            end
                        end
                        
                    end
                end
            end
            
        end
        
        % =============== end of Problem 6: Noise reduction ===============
        
    end     % end of imProcessor class methods...
end     % end of imProcessor class definition...
