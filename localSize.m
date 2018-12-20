function [Sizes,Mod] = localSize(I, min_size, max_size, s)

%localSize obtains a local size estimation of objects within an image
%This function uses the method presented in [1].
%
%The method is based on applying the sphiral phase transfrom at different
%frequencies, computing in each case the modulation map. The image can
%be considered as a weighted sum of sines/cosines at different frequencies and
%directions. Then, the modulation map gives us how good was the tuning
%of the filter with respect to these sines/cosines representing the objects. These sizes
%are estimated determining the maximum response of the resultant modulation map.
%
% Usage: [Sizes,Mod] = localSize(I, min_size, max_size, s)
%
% Inputs:
%
%   I [NRows x NCols] Image map with NRows and NCols the number of rows 
%       and columns
%
%   min_size [1x1 double value] number of pixels of the smaller object in
%   the image
%
%   max_size [1x1 double value] number of pixels of the largest object in
%   the image
%
%   s [1 x 1 double value] resolution of the isotropic gaussian filter bank
%
% Outputs:
%   Sizes  [NRows x NCols]  Local size map
%   Mod [NRows x NCols]  Modulation term
%
%   Javier Vargas, 
%   02/10/2018
%   copyright @2018 
%   Department of Anatomy and Cell Biology
%   https://1aviervargas.wordpress.com/ 
%   $ Revision: 1.0.0.0 $
%   $ Date: 02/10/18 $

%
% THIS CODE IS GIVEN WITHOUT ANY GUARANTY AND WITHOUT ANY SUPPORT
%
% REFERENCES 
%
% [1] Juan Antonio Quiroga, Manuel Servin, "Isotropic n-dimensional fringe
% pattern normalization", Optics Communications, 224, Pages 221-227 (2003)

%image size
N = size(I,1);
numf =50;
mixPxF = (N/max_size)/2;
maxPxF = (N/min_size)/2;
step = (maxPxF-mixPxF)/numf;
f = linspace(mixPxF,maxPxF,numf);

amplitudes = zeros(numf,size(I,1)*size(I,2));
indx = repmat((1:numf)',1,size(I,1)*size(I,2));

%Image normalization. Mean 0 and std 1
I = double(I)-mean(I(:));
I = I/std(I(:));

index = 1;
for k=f
    [cn, m]=INorm(I, k, s);
    %figure(1), imagesc(m, [0 1]); colorbar 
    amplitudes(index,:) = m(:);                  
    index=index+1;
end

%Maximum or weighted mean
[val, pos] = max(amplitudes);
pos = sum((amplitudes.^3).*indx)./(sum(amplitudes.^3));

P = reshape(pos,size(I,1),size(I,2));

%We obtain the local size maps
Sizes = ((P-1)*step+mixPxF);
Sizes = (size(I,1)./(Sizes*2))*2; %objects are half of frequencies
%Modulation Map
Mod = reshape(val,size(I,1),size(I,2));

