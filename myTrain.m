% https://csc.cdf.toronto.edu/mybb/showthread.php?tid=4751
% create a struct which contains every phoneme HMMs
data = struct();
addpath(genpath('/u/cs401/A3_ASR/code/FullBNT-1.0.7'));
dir_list = dir('/u/cs401/speechdata/Training/');

for i = 1:length(dir_list)
    %disp(dir_list(i).name)
    
    file_list = dir(['/u/cs401/speechdata/Training/' dir_list(i).name '/*.phn']);
    %disp(length(file_list))
    
    for index = 1:length(file_list)
        % loop through each phn file and corresponding mfcc file
        phn_name = ['/u/cs401/speechdata/Training/' dir_list(i).name '/' file_list(index).name];
        %disp(phn_name)
        mfcc_name = [strtok(phn_name, '.'), '.mfcc'];
        %disp(mfcc_name)
        [start_time, end_time, phoneme] = textread(phn_name, '%u %u %s');

        mfcc_file = textread(mfcc_name);
        [max_line, mfcc_vector] = size(mfcc_file);
        [row, column] = size(phoneme);

        for line = 1:row
            start_t = (start_time(line) / 128) + 1;
            end_t = min((end_time(line) / 128) + 1, max_line);
            if strcmp(phoneme{line}, 'h#')
                phoneme{line} = 'silence';
            end
            if ~isfield(data, phoneme{line})
                data.(phoneme{line}) = {};
            end
            phoneme_matrix = mfcc_file(start_t:end_t, 1:7).';
            data.(phoneme{line}) = [data.(phoneme{line}); phoneme_matrix];
        end
        
    end
    
end

HMM = struct();

phonemes = fieldnames(data);

for index = 1:numel(phonemes)
    % transpose to a one-by-N matrix
    data.(phonemes{index}) = data.(phonemes{index}).';
    HMM.(phonemes{index}) = initHMM(data.(phonemes{index}), 4, 1, 'kmeans');
    [HMM.(phonemes{index}),LL] = trainHMM(HMM.(phonemes{index}), data.(phonemes{index}));
end

save('./HMM_20iter_4Mixture_1State_7Dim.mat', 'HMM', '-mat');




