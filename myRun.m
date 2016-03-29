% A phoneme sequence is a sequence of MFCC vectors that correspond to a single phoneme.
% Given an HMM model trained for some phoneme, 
% you compute the log-likelihood of the model generating that phoneme sequence using loglikHMM.m.

% addpath(genpath('/u/cs401/A3_ASR/code/FullBNT-1.0.7'));
dir_list = dir('/u/cs401/speechdata/Testing/');

HMM = importdata('./HMM.mat');
for i = 1:length(dir_list)
    
    file_list = dir(['/u/cs401/speechdata/Testing/' dir_list(i).name '/*.phn']);

    for index = 1:length(file_list)
        % loop through each phn file and corresponding mfcc file
        phn_name = ['/u/cs401/speechdata/Testing/' dir_list(i).name '/' file_list(index).name];

        mfcc_name = [strtok(phn_name, '.'), '.mfcc'];
        [start_time, end_time, phoneme] = textread(phn_name, '%u %u %s');

        mfcc_file = textread(mfcc_name);
        [max_line, mfcc_vector] = size(mfcc_file);
        [row, column] = size(phoneme);

        for line = 1:row
            start_t = (start_time(line) / 128) + 1;
            end_t = min((end_time(line) / 128) + 1, max_line);

            phoneme_matrix = mfcc_file(start_t:end_t, 1:end-1).';
            if strcmp('h#', phoneme)
                LL = loglikHMM(HMM.('silence'), phoneme_matrix);
                
            else
                LL = loglikHMM(HMM.(phoneme), phoneme_matrix);
            end
        end
        
    end
    
end

