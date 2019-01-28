function F = createFeatureToeplitzMatrix(f, nDelays, addIntercept)
% F = constructFeatureToeplitzMatrix(f, nDelays, addIntercept)
% -------------------------------------------------------------
% Blair - March 9, 2018
%
% This function constructs the Toeplitz (convolution) matrix of
% successively time-delayed features, e.g., as input to the SRC CCA
% algorithm. 
%
% Inputs: 
% - f: Feature vector (should be T x 1; will transpose if not)
% - nDelays: Number of delays (number of columns with leading zeros) to
%   include. These are in addition to the full (not delayed) instance of
%   the f vector in column 1.
% - addIntercept: Whether to additionally include the intercept column
%   (column of 1s) at the end. If not specified, will default to 1.
%
% Outputs: 
% - F: Feature matrix of size T x (nDelays + 1 + addIntercept)

%%%%% For debugging - comment out if running as function %%%%%
% ccc; 
% f = 1:20;
% nDelays = 10;
% addIntercept = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%% Make sure uncommented if running as function %%%%%%%%
if nargin < 3, addIntercept = 1; end
if nargin < 2, error('Toeplitz matrix: Must input both a feature vector and number of delays.'); end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isvector(f), error('Toeplitz matrix: Input feature vector needs to be a vector.'); end
f = f(:); T = length(f);
if nDelays >= T, warning('Toeplitz matrix: Number of delays exceeds length of feature vector; will have full column(s) of zeros.'); end

if addIntercept, disp('Toeplitz matrix: Adding intercept column of 1s.'); end

% Initialize the matrix
F = nan(T, nDelays+1+addIntercept);

for d = 1:(nDelays+1) % Fill in main body of matrix
    F(:,d) = [zeros(min(d-1,T),1); f(1:(end-(d-1)))];
end
if addIntercept, F(:, end) = 1; end % Add intercept if requested