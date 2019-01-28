function varargout = plotOnEgi129(data)
%plotOnEgi - Plots data on a standarized EGI net mesh
%function meshHandle = plotOnEgi(data)
%
%This function will plot data on the standardized EGI mesh with the
%arizona colormap.
%
%Data must be a 128 dimensional vector, but can have singleton dimensions,
%
% New version by Blair 20160309 - adding support for 129 channels.

data = squeeze(data);
datSz = size(data);

if datSz(1)<datSz(2)
    data = data';
end

if size(data,1) == 128
    disp('Doing 128 chan')
    tEpos = load('defaultFlatNet.mat');
    tEpos = [ tEpos.xy, zeros(128,1) ];
    
    tEGIfaces = mrC_EGInetFaces( false );
    
    nChan = 128;
    
% NEW - FOR 129 CHANNELS    
elseif size(data,1) == 129
    disp('Doing 129 chan')
    tEpos = load('defaultFlatNet.mat');
    tEpos.xy = [tEpos.xy; [0 0]]; % Add reference electrode
    tEpos = [ tEpos.xy, zeros(129,1) ];
    
    tEGIfaces = mrC_EGInetFaces( true );
    
    nChan = 129;
    
    
elseif size(data,1) == 256
    
    tEpos = load('defaultFlatNet256.mat');
    tEpos = [ tEpos.xy, zeros(256,1) ];
    
    tEGIfaces = mrC_EGInetFaces256( false );
    nChan = 256;
else
    error('Only good for 3 montages: Must input a 128, 129, or 256 vector')
end


patchList = findobj(gca,'type','patch');
netList   = findobj(patchList,'UserData','plotOnEgi');


if isempty(netList),
    handle = patch( 'Vertices', [ tEpos(1:nChan,1:2), zeros(nChan,1) ], ...
        'Faces', tEGIfaces,'EdgeColor', [ 0.5 0.5 0.5 ], ...
        'FaceColor', 'interp');
    axis equal;
    axis off;
else
    handle = netList;
end

set(handle,'facevertexCdata',data,'linewidth',1,'markersize',0.5,'marker','.');
set(handle,'userdata','plotOnEgi');

colormap(jmaColors('usadarkblue'));

if nargout >= 1
    varargout{1} = handle;
end
