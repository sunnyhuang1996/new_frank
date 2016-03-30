% report both the 4 measurements of error (SE, IE, DE, total) for each sentence and for the entire set of test data used in that section.
function [SE IE DE LEV_DIST] =Levenshtein(hypothesis,annotation_dir)
% Input:
%	hypothesis: The path to file containing the the recognition hypotheses
%	annotation_dir: The path to directory containing the annotations
%			(Ex. the Testing dir containing all the *.txt files)
% Outputs:
%	SE: proportion of substitution errors over all the hypotheses
%	IE: proportion of insertion errors over all the hypotheses
%	DE: proportion of deletion errors over all the hypotheses
%	LEV_DIST: proportion of overall error in all hypotheses

hypo = importdata(hypothesis);
annotate_list = dir([annotation_dir '/unkn_*.txt']);

for index=1:length(annotate_list)
    % initialize DE, IE, SE
    DE = 0;
    IE = 0;
    SE = 0;   
    annotate_file = [annotation_dir '/unkn_' num2str(index) '.txt'];

    REF = importdata(annotate_file);
    REF = strsplit(char(strtrim(regexprep(REF,'\d',''))), ' ');
    %disp(REF)
    n = numel(REF);
 
    hypo{index} = strsplit(char(strtrim(regexprep(hypo{index},'\d',''))), ' ');
    m = numel(hypo{index});
    
    %matrix of distance
    R = zeros(n+1, m+1);
    %backtracking matrix
    %B = zeros(n+1, m+1);
    % For all element in the top row or leftmost column, set them to
    % infinity except fot the top left corner
    R(1, :) = Inf;
    R(:, 1) = Inf;
    R(1, 1) = 0;
    
    for i =2:n+1
       
        for j=2:m+1
            del = R(i-1, j) + 1;
            sub = R(i-1, j-1);
            if ~strcmp(REF{i-1}, hypo{index}{j-1})
                sub = sub + 1;
            end
        
            ins = R(i, j-1) + 1;
         
            R(i, j) = min([del, sub, ins]);
            if R(i, j) == del
		B(i, j) = 1; % 1 --> up 
            elseif R(i, j) == ins
                B(i, j) = 2; % 2 --> left
            else
                B(i, j) = 3; % 3 --> left-up
            end
        end
        
    end
    i = n + 1;
    j = m + 1;
    while R(i, j) ~= 0
	if B(i, j) == 3
	    SE = SE + R(i, j) - R(i-1, j-1);
	    i = i - 1;
	    j = j - 1;    
	elseif B(i, j) == 2
	    IE = IE + R(i, j) - R(i, j-1);
	    j = j - 1;
	else
	    DE = DE + R(i, j) - R(i-1, j);
	    i = i - 1; 
	end
    end
    LEV_DIST = 100 * R / n;
    sentence_i = sprintf('------ sentence %d --------', index); 
    disp(sentence_i)
    %disp(R)
    disp(LEV_DIST)
    %disp(B)
    SE_report = sprintf('SE error: %d', 100 * SE / n);
    disp(SE_report)
    DE_report = sprintf('DE error: %d', 100 * DE / n);
    disp(DE_report)
    IE_report =  sprintf('IE error: %d', 100 * IE / n);
    disp(IE_report)
    total_report = sprintf('total error: %d', 100 * (SE + DE + IE) / n);
    disp(total_report)
end
