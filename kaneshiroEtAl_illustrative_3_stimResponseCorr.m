% kaneshiroEtAl_illustrative_3_stimResponseCorr.m
% --------------------------------------------------
% This script performs stimulus-response correlation of RC1 activations for all
% stimuli (Figure 3A).

% MIT License
%
% Copyright (c) 2019 Blair Kaneshiro, Duc T. Nguyen, Anthony M. Norcia,
% Jacek P. Dmochowski, and Jonathan Berger
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

clear all; close all; clc
addpath('Code/'); addpath('Data/');

conditions = {'orig', 'meas', 'rev', 'phase'};
nTrials = 24;

for c = 1:length(conditions) % Iterate through stimulus conditions
    
    % Load RCA data for current stimulus condition
    condtUse = conditions{c};
    rcaFilename = ['rcaOut_' condtUse '_allSongs.mat'];
    disp(['Loading ' rcaFilename]); load(rcaFilename);
    
    for s = 1:4 % Iterate through songs
        
        currRCData = eegRC1{s}; % Time x trials
        currRCData = currRCData(1:(end-1),:);
        
        disp(' ')
        disp('Computing stimulus-response correlation.')
        
        % Maximize correlation between the RC-EEG and the stimulus amplitude
        % envelope by regressing a Toeplitz matrix of the zero-mean envelope onto
        % the EEG trials.
        currEnv = AmplEnv(s).zEnv;
        currEnv = abs(diff(currEnv)); % Compute absolute envelope fluctuations
        
        % This is the time x delay (plus intercept) Toeplitz representation of the
        % stimulus feature.
        S = createFeatureToeplitzMatrix(currEnv, fs, 1); % T x 127
        
        % Repeat the envelope matrix nTrials times.
        S_all = repmat(S, nTrials, 1); % 24T x 127
        
        % Concatenate the RC trials into a single vector
        RC_all = currRCData(:); % 24T x 1 (was T x 24)
        
        % Precompute pinv(envAllTrain)
        pinvS_all = pinv(S_all); % 127 x 24T
        
        % Initialize the output variable
        allCorr = nan(nTrials,1);
        
        % Compute the temporal filter
        H = pinvS_all * RC_all;
        
        % Get predicted RC1 activations
        RC_all_hat = S_all * H;
        
        % Reshape back to matrix
        RC_hat = reshape(RC_all_hat, [], nTrials);
        
        % For each trial, correlate actual and predicted RC data
        for t = 1:nTrials
            allCorr(t) = corr(currRCData(:, t), RC_hat(:, t));
        end
        
        % Print mean and SEM to console
        disp([condtUse ', song ' num2str(s) ', RC1:'])
        disp(['Mean SRCorr = ' sprintf('%.4f', mean(allCorr)) ...
            ', SEM = ' sprintf('%.4f', std(allCorr)/sqrt(nTrials))])
    end
    clear eegRC1
end
