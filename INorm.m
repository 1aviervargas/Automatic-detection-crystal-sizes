%INorm pattern normalization
% [cn, m]=INorm(c, R, S) computes the normalized version of interferogram 
% c=b+m*cos(phi), cn=cos(phi) and an estimation of the modulation m.
% R is the radius in fringes/filed of a DC filter to elliminate the DC
% signal b from the igram c

% Ref: Juan Antonio Quiroga, Manuel Servin, "Isotropic n-dimensional fringe
% pattern normalization", Optics Communications, 224, Pages 221-227 (2003)

%   AQ, 03/02/11
%   Copyright 2009 OM4M
%   $ Revision: 1.0.0.0 $
%   $ Date: 03-02-2011 $
%
% Revised by Javier Vargas
%   Copyright 2011 LINES-INTA
%   $ Revision: 1.0.0.0 $
%   $ Date: 06-02-2011 $
%
% Revised agin by Javier Vargas
%   Copyright 2019 Department of Anatomy and Cell Biology-McGill
%   $ Revision: 1.0.0.0 $
%   $ Date: 19-12-2018 $

function [varargout]=INorm(varargin)

try
    
    %Pattern to process
    c = varargin{1};
    [NR, NC]=size(c);
    [u,v]=meshgrid(1:NC, 1:NR);
    
    %Temporal variables
    u0=floor(NC/2)+1; v0=floor(NR/2)+1;
    u=u-u0; v=v-v0;
        
    R = varargin{2};
    S = varargin{3};
    
    [Theta Radial] = cart2pol(u,v);    
    Hr=1-exp(-(u.^2+v.^2)/(2*0.05^2)); %Gaussian DC filter with sigma=0.01
    H=exp(-((Radial-R).^2)/(2*S^2)); %Annular filter with radius=R and sigma=S
    H = Hr.*H;
    [cn m] = Normalize(c,H);
    
    varargout{1}=cn;
    varargout{2}=m;
    
catch ME
    throw(ME);
end

function [cn m] = Normalize(c,H)

try
    C=fft2(c);
    %H is already fftshifted from design, if fftshift is used instead, for even
    %dimensions there is no problem, however for odd dimensions fftshift(H)
    %will place the frequency origin (u0,v0) in (1, NR) instead of (1,1)
    %see help for ifftshift
    CH=C.*ifftshift(H);
    
    ch=ifft2(CH);
    
    %compute quafrature
    s=abs(SPHT(ch));
    
    %normalized igram
    cn=cos(atan2(s,ch));
    %modulation
    m=abs(ch+1i*s);         
    
catch ME
    throw(ME);
end
    
    
    

function sd=SPHT(c)
%SPHT spiral phase transform
% sd=SPHT(c) computes the quadrture term of c still affected by the
% direction phase factor. Therefore for a real c=b*cos(phi)
% sd=SPHT(c)=i*exp(i*dir)*b*sin(phi)
% Ref: Kieran G. Larkin, Donald J. Bone, and Michael A. Oldfield, "Natural
% demodulation of two-dimensional fringe patterns. I. General background of the spiral phase quadrature transform," J. Opt. Soc. Am. A 18, 1862-1870 (2001) 

%   AQ, 19/8/09
%   Copyright 2009 OM4M
%   $ Revision: 1.0.0.0 $
%   $ Date: 19-08-2009 $

try
    
    TH=max(abs(c(:)));
    if mean(real(c(:)))>0.01*TH
        warning('OM4M:SPHT:OutOfRange', ...
            'input must be DC filtered');
    end
    
    [NR, NC]=size(c);
    [u,v]=meshgrid(1:NC, 1:NR);
    u0=floor(NC/2)+1;
    v0=floor(NR/2)+1;       
    
    u=u-u0;
    v=v-v0;       
    
    H=(u+1i*v)./abs(u+1i*v);
    H(v0, u0)=0; %crop the nan
    
    C=fft2(c);
    %H is already fftshifted from design, if fftshift is used instead, for even
    %dimensions there is no problem, however for odd dimensions fftshift(H)
    %will place the frequency origin (u0,v0) in (1, NR) instead of (1,1)
    %see help for ifftshift
    CH=C.*ifftshift(H);
    
    %the complex conjugate is due to the changein sign for rows from xy 
    %(cartesian) to ij (pixel) systems that generates a change in the
    %sin(dir) signal in both systems
    sd=conj(ifft2(CH));               
        
catch ME
    throw(ME);
end