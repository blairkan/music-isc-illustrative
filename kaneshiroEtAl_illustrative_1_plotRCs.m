% kaneshiroEtAl_illustrative_1_plotRCs.m
% ------------------------------------------
% This script visualizes the forward-model projections of the RC1 weights
% as scalp topographies (Figure 1B). There is one topoplot per stimulus
% condition.

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

for c = 1:length(conditions)
    condtUse = conditions{c};
    % Create filename and load the RCA data
    rcaFilename = ['rcaOut_' condtUse '_allSongs.mat'];
    disp(['Loading ' rcaFilename]); load(rcaFilename);

    % The RCs were computed across all songs of a given stimulus condition, so
    % are condition-specific but not song-specific. May reflect sign flip of
    % paper figures.
    figure(1); subplot(2, 2, c)
    
    disp(['Figure ' num2str(c) ': Plotting forward-model projection of ' condtUse ' RC topography.'])
    if strcmp(condtUse, 'rev'), A = -A; end
    plotOnEgi129(nanFill125To129(A(:,1))); % Always RC1
    set(gca, 'clim', [-0.4 0.4])
    title(['Condition ' condtUse ', RC1']);
    colormap(jmaColors('coolhotcortex')); colorbar
    clear A
    disp(' ')
end