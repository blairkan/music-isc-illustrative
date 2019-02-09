% kaneshiroEtAl_illustrative_2_interSubjectCorr.m
% --------------------------------------------------------
% This script performs inter-subject correlation of RC1 activations for all
% stimuli (Figure 1A).

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
nTrials = 24; pIdx = combnk(1:nTrials, 2); 

for c = 1:length(conditions) % Iterate through stimulus conditions
    
    % Load RCA data for current stimulus condition
    condtUse = conditions{c}; 
    rcaFilename = ['rcaOut_' condtUse '_allSongs.mat'];
    disp(['Loading ' rcaFilename]); load(rcaFilename);
    
    for s = 1:4 % Iterate through songs
        
        currRCData = eegRC1{s}; % Time x trials

        disp(' ')
        disp(['Computing inter-subject correlation: ' condtUse ' song ' num2str(s) '.'])
        
        % Correlate every trial with all other trials.
        ISCorr = nan(nTrials,1); % Initialize correlation output
        for i = 1:nTrials
            tempISC = nan(nTrials-1, 1);
            otherTrials = 1:nTrials; otherTrials(i) = [];
            for j = 1:length(otherTrials)
                tempISC(j) = corr(currRCData(:, i), currRCData(:, otherTrials(j)));
            end
            ISCorr(i) = mean(tempISC);
            clear tempISC
        end
        
        % Print mean and SEM to console
        disp([condtUse ', song ' num2str(s) ', RC1:'])
        disp(['Mean ISCorr = ' sprintf('%.4f', mean(ISCorr)) ...
            ', SEM = ' sprintf('%.4f', std(ISCorr)/sqrt(nTrials))])
        clear currRCData
    end
    clear eegRC1
end
