% kaneshiroEtAl_illustrative_4_stimResponseCoh.m
% ------------------------------------------
% This script performs stimulus-response coherence and cross power spectral
% density of RC1 activations for intact, measure, and reversed stimuli
% (Figure 4; Supplementary Figures 4-6).

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

conditions = {'orig', 'meas', 'rev'};
nTrials = 24;

for c = 1:length(conditions)
    condtUse = conditions{c};
    rcaFilename = ['rcaOut_' condtUse '_allSongs.mat'];
    disp(['Loading ' rcaFilename]); load(rcaFilename);
    
    for s = 1:4
        % Subset the EEG data for current condition, song, RC
        currRCData = eegRC1{s}; % Time x trials
        currRCData = currRCData(1:(end-1),:);
        nTrials = size(currRCData, 2); % Number of trials (always 24)
        
        % Index of frequency of interest for current song
        idxFOI = idxFreqOfInterest(s);
        
        % Current song's tempo and (sub-)harmonics. We consider from 1/4x the beat
        % frequency (whole note) to 8x the beat frequency (32nd note). We will plot
        % frequencies up to 15 Hz.
        tempoFreqs = tempoHz(s) * 2.^(-2:3);
        tempoStr = {'t/4', 't/2', 't', '2t', '4t', '8t'};
        load('colors.mat', 'rgb10') % For plotting tempo lines
        grayCol = [.5 .5 .5];
        xl = [0 15];
        
        disp(' ')
        disp('Computing stimulus-response coherence.')
        
        % Compute stimulus-response coherence and cross power spectral
        % density. Using 5-second segments with Hamming window, with 50%
        % overlap between windows and FFT length of 1,024.
        currEnv = AmplEnv(s).zEnv;
        currEnv = abs(diff(currEnv)); currEnv = currEnv - mean(currEnv);
        SRCoh = nan(513, nTrials); SRCpsd = SRCoh;
        % Compute coherence between each trial and the envelope.
        for t = 1:nTrials
            [SRCoh(:, t), fAx] = mscohere(...
                currEnv, currRCData(:, t),...
                5*fs, [], [], fs);
            [SRCpsd(:, t), ~] = cpsd(...
                currEnv, currRCData(:, t),...
                5*fs, [], [], fs);
        end
        
        % Plot magnitude-squared coherence, cpsd phase angles, and histogram of
        % cpsd phase angles.
        figure('Position', [10 10 900 400])
        subplot(1, 3, 1:2) % Magnitude-squared coherence
        SRCohYLim = [-0.01 0.25];
        freqOfInterest = fAx(idxFOI);
        shadedErrorBar(fAx, SRCoh', {@mean,@std}); hold on
        p=plot(freqOfInterest, mean(SRCoh(idxFOI,:)), 'r*');
        ll=plotTempoLines_RCA_coherence(tempoFreqs, SRCohYLim, rgb10);
        text(freqOfInterest, mean(SRCoh(idxFOI,:)),...
            [' Peak freq: ' sprintf('%.3f', freqOfInterest) 'Hz'],...
            'horizontalalignment', 'left')
        xlim([0 15]); ylim(SRCohYLim);
        box off; ylabel('Mscohere'); xlabel('Frequency (Hz)')
        title([condtUse ' song ' num2str(s) ' RC1 SRCoherence'])
        legend(ll, tempoStr(1:length(ll)), 'location', 'northeast')
        uistack(ll, 'bottom')
        
        subplot(1, 3, 3) % Polar histogram of angles at freq of interest
        polarhistogram(angle(SRCpsd(idxFOI,:)), 10,...
            'edgecolor', 'k', 'DisplayStyle', 'stairs', 'linewidth', 2);
        rlim([0 20])
        title(['Cpsd phase angles at ' sprintf('%.3f', freqOfInterest) ' Hz'],...
            'fontsize', 10)
        set(gca, 'thetatick', 0:90:270,...
            'thetaticklabel', {'0', '\pi/2', '\pi', '3\pi/2'})
        
        % Print mean and SEM coherence to console.
        disp([condtUse ', song ' num2str(s) ', RC1:'])
        disp(['Frequency of interest = ' sprintf('%.4f', freqOfInterest) 'Hz.'])
        disp(['Mean SRCohere at frequency of interest: ' sprintf('%.4f', mean(SRCoh(idxFOI,:)))...
            ', SEM = ' sprintf('%.4f', std(SRCoh(idxFOI,:))/sqrt(nTrials))])
        
        clear SRCoh SRCpsd currRCData
        
    end
    clear eegRC1
end
