%This script is provided to give three examples of the use of this
%software. To test the different cases just change the value of measure
%variable between 1 to 7

clc
clear all
close all

measure = 1;

switch measure
    
    case 1
               
        %687 px is 1um. This information is obtained from the image.
        s = 1/687;

        I = imread('I.png');        
        I = rgb2gray(I);
        % Here we remove the black bar at the bottom of the image. We only
        % keep the first 1700 rows and 1700 columns.
        I=(I(1:1700,1:1700));

        %We have to estimate the object size range. We estimate that in
        %this case we have objects with sizes between 400 pixels and 60
        %pixels.
        min_size = 8;
        max_size = 120;
 
        %Variance of the filter (resolution). 
        resol = 1.0;        
       
    case 2
      
        %740 px is 10um. This information is obtained from the image.
        s = 10/740;

        I = imread('Control.tif');
        % Here we remove the black bar at the bottom of the image. We only
        % keep the first 1700 rows and 1700 columns.
        I=(I(1:1700,1:1700)); 

        %We have to estimate the object size range. We estimate that in
        %this case we have objects with sizes between 400 pixels and 60
        %pixels.
        min_size = 50;
        max_size = 800;
 
        %Variance of the filter (resolution). 
        resol = 1.0;                
                    
    case 3
      
        %740 px is 10um. This information is obtained from the image.
        s = 10/88;

        I = imread('D-Tar.png');        
        I=rgb2gray(I);
        % Here we remove the black bar at the bottom of the image. We only
        % keep the first 300 rows and 300 columns.
        I=I(1:300,1:300);        

        %We have to estimate the object size range. We estimate that in
        %this case we have objects with sizes between 400 pixels and 60
        %pixels.
        min_size = 8;
        max_size = 100;
 
        %Variance of the filter (resolution). 
        resol = 1.0;        

    case 4
      
    
        %740 px is 10um. This information is obtained from the image.
        s = 10/657;

        I = imread('L-Tar.tif');        
        % Here we remove the black bar at the bottom of the image. We only
        % keep the first 1700 rows and 1700 columns.
        I=(I(1:1700,1:1700)); 

        %We have to estimate the object size range. We estimate that in
        %this case we have objects with sizes between 400 pixels and 60
        %pixels.
        min_size = 10;
        max_size = 200;
 
        %Variance of the filter (resolution). 
        resol = 1;
        
        
    case 5      
    
        %740 px is 10um. This information is obtained from the image.
        s = 10/658;

        I = imread('L-Tar.tif');        
        % Here we remove the black bar at the bottom of the image. We only
        % keep the first 1700 rows and 1700 columns.
        I=(I(1:1760,1:1760)); 

        %We have to estimate the object size range. We estimate that in
        %this case we have objects with sizes between 400 pixels and 60
        %pixels.
        min_size = 20;
        max_size = 300;
 
        %Variance of the filter (resolution). 
        resol = 1;
        
      
    case 6
               
        %687 px is 1um. This information is obtained from the image.
        s = 2/686;

        I = imread('10a.tif');        
        %I = rgb2gray(I);
        % Here we remove the black bar at the bottom of the image. We only
        % keep the first 1700 rows and 1700 columns.
        I=(I(1:1700,1:1700));

        %We have to estimate the object size range. We estimate that in
        %this case we have objects with sizes between 400 pixels and 60
        %pixels.
        min_size = 10;
        max_size = 40;
 
        %Variance of the filter (resolution). 
        resol = 1.0;               
            
    case 7
               
        %687 px is 1um. This information is obtained from the image.
        s = 2/686;

        I = imread('30a.tif');        
        %I = rgb2gray(I);
        % Here we remove the black bar at the bottom of the image. We only
        % keep the first 1700 rows and 1700 columns.
        I=(I(1:1700,1:1700));

        %We have to estimate the object size range. We estimate that in
        %this case we have objects with sizes between 400 pixels and 60
        %pixels.
        min_size = 6;
        max_size = 70;
 
        %Variance of the filter (resolution). 
        resol = 1.0;               
                                                      
end



[Sizes Mod]=localSize(I,min_size,max_size,resol);
figure, imagesc(I), colormap gray
set(gcf,'Color','white')
axis off

Mask = roipoly; 

%We convert from pixel units to physical units with s
Sizes = Sizes.*s;
SizesMasked = Mask.*Sizes;
ModMasked = Mod.*Mask;

%%

figure, imagesc(Mod), colormap jet, colorbar
set(gcf,'Color','white')
axis off
title('MODULATION MAP')

figure, imagesc(Sizes), colormap jet, colorbar
set(gcf,'Color','white')
axis off
title('LOCAL SIZE MAP')

figure, hist(Sizes(:),100);
grid on
xlabel('Crystal size(um)')
ylabel('Count')
set(gcf,'Color','white')
title('Histogram Full Image')


figure, imagesc(SizesMasked), colormap jet, colorbar
set(gcf,'Color','white')
axis off
title('LOCAL SIZE MAP Masked')

figure, imagesc(ModMasked), colormap jet, colorbar
set(gcf,'Color','white')
axis off
title('MODULATION MAP MASKED')

figure, hist(Sizes(Mask),100);
grid on
xlabel('Crystal size(um)')
ylabel('Count')
set(gcf,'Color','white')
title('Histogram Masked Image')


disp('Mean of sizes FULL Image: ');
mean(Sizes(:))
disp('STD of sizes FULL Image: ');
std(Sizes(:))
disp('-------------------------------');
disp('Mean of sizes Masked Image: ');
mean(Sizes(Mask))
disp('STD of sizes Masked Image: ');
std(Sizes(Mask))


