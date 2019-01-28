% kaneshiroEtAl_illustrative_1_plotRCs.m
% ------------------------------------------
% This script performs the following analyses on the RCA output data for
% user-selected stimulus condition, song number, and RC: 
% - Create topoplot of RC (forward-model projection)
% - Compute inter-trial correlation
% - Compute stimulus-response correlation
% - Compute inter-trial coherence
% - Compute stimulus-response coherence

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

%%%%% Specify stim condition, song, and RC to plot %%%%%%%%%%
condtUse = 'orig'; % 'orig', 'meas', 'rev', or 'phase'
songUse = 3; % Integer from 1:4
rcUse = 1; % Integer from 1:5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create filename and load the RCA data
rcaFilename = ['rcaOut_' condtUse '_allSongs.mat'];
disp(['Loading ' rcaFilename]); load(rcaFilename);

% Subset the EEG data for current condition, song, RC
currRCData = squeeze(dataOut{songUse}(:,rcUse,:)); % Time x trials
nTrials = size(currRCData, 2); % Number of trials (always 24)
pIdx = combnk(1:nTrials,2); % All unique pairs for this number of trials
nPairs = size(pIdx, 1); % Number of pairs (always 276)

%% Analysis 1: Plot RC topography

% The RCs were computed across all songs of a given stimulus condition, so
% are condition-specific but not song-specific. May reflect sign flip of
% paper figures.
figure(1)

disp('Plotting forward-model projection of RC topography.')
plotOnEgi129(nanFill125To129(A(:,rcUse))); 
set(gca, 'clim', [-0.4 0.4])
title(['Condition ' condtUse ', RC' num2str(rcUse)]); 
colormap(jmaColors('coolhotcortex')); colorbar