function [ output ] = parsestardoc( stardocChar )
%PARSESTARDOC Returns parsed star document as a struct. 
%  This is a private function accessible only to StarDocument class.
%  S = PARSESTARDOC('stardoc content') parses the star document returning
%  content between star document tokens as fields of Matlab struct instance.
%  A star docuent token satisfies the regular expression below
%  ':[A-Z]{2,10}:'. Example ':ADM:', ':UNIQ:'
%
%  Example:
%  s = parsestardoc(':ADM:val1:UNIQ:aq801bcs')
%
%  See also regexprep, struct

% Project      : DocCompliance
% File         : $Id: parsestardoc.m,v 1.2 2010/03/17 17:32:04 subrw5e Exp $
% Created      : Jan 8, 2010
% Revision     : $Revision: 1.2 $
% Last Changed : $LastChangedDate:: 2010-01-08 10:28:34 -0600 (Fri, 08 Jan 2010) $
% Author       : Chenchal Subraveti - chenchal.subraveti@vanderbilt.edu
% Copyright (c) 2010 Vanderbilt University Medical Center

% This function uses regular expressions.

    if(iscell(stardocChar))
        stardocChar=stardocChar{:};
    end

    tokenPattern='(:[A-Z]{2,10}:)|(:E_O_R:)';

    tokens=regexp(stardocChar,tokenPattern,'match');
    tokens=tokens(:);
    fields=regexprep(tokens,':','');
    %normalize
    exp=strcat('\s*',tokens);
    rep=strcat('\n',tokens);
    stardocChar=regexprep(stardocChar,exp,rep);

    structMatch=strcat('(?<',fields(1:end-1),'>.*)\n+', '?(', tokens(2:end), ')');
    structMatch=strcat(tokens{1}, structMatch{:});

    output=regexp(stardocChar,structMatch,'names');


end