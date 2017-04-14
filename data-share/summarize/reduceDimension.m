function out = reduceDimension(mat, dimension, varargin)
%% In Progress...
%     % Reduce Matrix Dimension
%     % Retain only columns or rows where atleast 1 value matches condition
%     % Not useful: Atleast 1 trial had non-nan value in 1st column
%     if (nargin ==2)
%         %Set all spikes before PreWindow to NaN
%         [ro,co]=eval(['find(mat ' simpleConditionalExpression ' )']);
%         mat(ro,co)=NaN;
%     end
%       out=mat(:,any(~isnan(mat)));
%       %%to reduce rows
%       %out=mat(any(~isnan(mat),2),:);
  warning('Not yet implemented...');
  out=mat;
end