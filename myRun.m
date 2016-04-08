% A phoneme sequence is a sequence of MFCC vectors that correspond to a single phoneme.
% Given an HMM model trained for some phoneme, 
% you compute the log-likelihood of the model generating that phoneme sequence using loglikHMM.m.

addpath(genpath('/u/cs401/A3_ASR/code/FullBNT-1.0.7'));
phn_list = dir('/u/cs401/speechdata/Testing/*.phn');
count = struct();

<<<<<<< HEAD
HMM = importdata('./HMM_20iter_4Mixture_1State_7Dim.mat');
=======
HMM = importdata('./HMM_20iter_4Mixture_2State_14Dim_three_quarter_data.mat');
>>>>>>> dffe9b53782e9bae7339507f6a04ebae2e262224

for i = 1:length(phn_list)
        % loop through each phn file and corresponding mfcc file
        phn_name = ['/u/cs401/speechdata/Testing/' phn_list(i).name];
        disp(phn_name)
        mfcc_name = [strtok(phn_name, '.'), '.mfcc'];
        [start_time, end_time, phoneme] = textread(phn_name, '%u %u %s');

        mfcc_file = textread(mfcc_name);
        [max_line, mfcc_vector] = size(mfcc_file);
        [row, column] = size(phoneme);
        
        for line = 1:row
            if ~isfield(count, phoneme{line})
                if strcmp(phoneme{line}, 'h#') && ~isfield(count, 'silence')
                    count.('silence') = zeros(1, 2);
                elseif ~strcmp(phoneme{line}, 'h#')
                    count.(phoneme{line}) = zeros(1, 2);
                end
            end
            
            start_t = (start_time(line) / 128) + 1;
            end_t = min((end_time(line) / 128) + 1, max_line);

<<<<<<< HEAD
            phoneme_matrix = mfcc_file(start_t:end_t, 1:7).';
=======
            phoneme_matrix = mfcc_file(start_t:end_t, 1:14).';
>>>>>>> dffe9b53782e9bae7339507f6a04ebae2e262224
            
            % iterate thorugh each phonmeme HMM to find the max LL
            test_phones = fieldnames(HMM);
            max_LL = -Inf;
            for index=1:numel(test_phones)
                if max_LL < loglikHMM(HMM.(test_phones{index}), phoneme_matrix)
                    max_LL = loglikHMM(HMM.(test_phones{index}), phoneme_matrix);
                    candidate_phone = test_phones{index};
                end
            end
            
            % if the correct phoneme is found, add 1 to the numerator
            if strcmp(candidate_phone, phoneme{line})
                count.(phoneme{line})(1)  =  count.(phoneme{line})(1) + 1;
            elseif strcmp(candidate_phone, 'silence') && strcmp(phoneme{line}, 'h#')
                count.('silence')(1)  =  count.('silence')(1) + 1;
            end
            
            % add denominator no matter what 
            if strcmp(phoneme{line}, 'h#')
                count.('silence')(2)  =  count.('silence')(2) + 1;
            else
                count.(phoneme{line})(2)  =  count.(phoneme{line})(2) + 1;
            end
            % a = sprintf('candidate is %s, correct is %s', candidate_phone, phoneme{line});
            % disp(a)
            
        end
        
    
    
end

<<<<<<< HEAD
output_file = fopen('./20_iter_4Mixture_1State_7Dim_res.txt', 'w');
=======
output_file = fopen('./20_iter_4Mixture_2State_14Dim_three_quarter_data_res.txt', 'w');
>>>>>>> dffe9b53782e9bae7339507f6a04ebae2e262224
each_phone = fieldnames(count);

for index=1:numel(each_phone)
    success_rate = 100 * count.(each_phone{index})(1) / count.(each_phone{index})(2);
    report = sprintf('successfully recognize %s : %d out of %d times. --- rate %d', each_phone{index}, count.(each_phone{index})(1), count.(each_phone{index})(2), success_rate);
    fprintf(output_file, '%s\n', report);
end

fclose(output_file);
