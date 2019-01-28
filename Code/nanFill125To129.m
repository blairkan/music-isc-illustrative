function x129 = nanFill125To129(x125)
% x129 = nanFill125To129(x125)
% --------------------------------------
% Blair - March 9, 2016
% This function takes in a vector of length 125 (presumed to be from
% channels 1:124 plus reference), adds rows for missing channels 125:128,
% and returns a length-129 vector (reference at 129) for input to
% plotOnEGI129 function.

% Ensure electrode is row dimension
if size(x125,1) < size(x125,2)
    x125 = x125';
end

% disp(mat2str(size(x125)))

if size(x125,1) ~= 125
    error('Data appears to not have 125 channels.')
end

x129 = [x125(1:124,:); nan(4,size(x125,2)); x125(125,:)];