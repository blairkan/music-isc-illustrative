function legend = plotTempoLines_RCA_coherence(freq, ylim, rgb10)
% legend = plotTempoLines_RCA_coherence(freq, ylim, rgb10)
% ------------------------------------------------------
% This function plots tempo frequencies as dashed lines in the current
% axis. User must specify frequencies and ylim. Colors are hard coded and
% require the rgb10 variable in colors.mat. The function outputs legend
% handle entries.

if ~isvector(freq), error('Input frequencies must be vector or scalar.'); end
if nargin < 3, error('Please input frequencies, ylim, and colors.'); end
freq = freq(freq<=15);
hold on
for f = 1:length(freq)
    legend(f) = plot([1 1]*freq(f), ylim, ':',...
        'color', rgb10(f+4,:), 'linewidth', 3');
end