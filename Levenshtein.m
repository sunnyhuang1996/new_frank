% report both the 4 measurements of error (SE, IE, DE, total) for each sentence and for the entire set of test data used in that section.
function [SE, IE, DE, LEV_DIST] =Levenshtein(hypothesis,annotation_dir)
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
total_DE = 0;
total_SE = 0;
total_IE = 0;
total_n = 0;

for index=1:length(annotate_list)
    % initialize DE, IE, SE

    annotate_file = [annotation_dir '/unkn_' num2str(index) '.txt'];

    DE = 0;
    IE = 0;
    SE = 0;
    
    REF = importdata(annotate_file);
    REF = strsplit(char(strtrim(regexprep(REF,'\d',''))), ' ');
    %disp(REF)
    n = numel(REF);
    total_n = total_n + n;
    hypo{index} = strsplit(char(strtrim(regexprep(hypo{index},'\d',''))), ' ');
    m = numel(hypo{index});

    %matrix of distance
    R = zeros(n+1, m+1);
    %backtracking matrix
    B = zeros(n+1, m+1);
    % For all element in the top row or leftmost column, set them to
    % infinity except fot the top left corner
    R(1, :) = Inf;
    R(:, 1) = Inf;
    R(1, 1) = 0;
    
    for i =2:n+1
       
        for j=2:m+1
            del = R(i-1, j) + 1;
            sub = R(i-1, j-1);
            ref_word = upper(regexprep(REF{i-1}, '\W', ''));
            hypo_word = upper(regexprep(hypo{index}{j-1}, '\W', ''));
            if ~strcmp(ref_word, hypo_word)
%                 disp(REF{i-1})
%                 disp(hypo{index}{j-1})
%                 disp(ref_word)
%                 disp(hypo_word)
%                 disp('---------------')
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
	    total_SE = total_SE + R(i, j) - R(i-1, j-1);
	    i = i - 1;
	    j = j - 1;    
	elseif B(i, j) == 2
	    IE = IE + R(i, j) - R(i, j-1);
	    total_IE = total_IE +  R(i, j) - R(i, j-1);
	    j = j - 1;
	else
	    DE = DE + R(i, j) - R(i-1, j);
	    total_DE = total_DE + R(i, j) - R(i-1, j);
	    i = i - 1; 
	end
    end
%     LEV_DIST = 100 * R / n;
    sentence_i = sprintf('------ sentence %d --------', index); 
    disp(sentence_i)
    %disp(R)
%     %disp(LEV_DIST)
%     %disp(B)
    SE_report = sprintf('SE error: %d', 100 * SE / n);
    disp(SE_report)
    DE_report = sprintf('DE error: %d', 100 * DE / n);
    disp(DE_report)
    IE_report =  sprintf('IE error: %d', 100 * IE / n);
    disp(IE_report)
    total_report = sprintf('total error: %d, total error count: %d', 100 * (SE + DE + IE) / n, SE + DE + IE);
    disp(total_report)
end

SE_report = sprintf('SE error: %d', 100 * total_SE / total_n);
disp(SE_report)
 DE_report = sprintf('DE error: %d', 100 * total_DE / total_n);
 disp(DE_report)
 IE_report =  sprintf('IE error: %d', 100 * total_IE / total_n);
 disp(IE_report)
 total_report = sprintf('total error: %d, count: %d', 100 * (total_SE + total_DE + total_IE) / total_n, total_SE + total_DE + total_IE);
 disp(total_report)
 disp(total_n)
