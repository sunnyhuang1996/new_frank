function [likelihood, speakers] = gmmClassify(model, M)

num_candidate = length(model);

uterrance_files = dir(['/u/cs401/speechdata/Testing/', '*.mfcc']);
for utterance=1:length(uterrance_files)
    result = zeros(1, num_candidate);
    speakers = {};
    file = ['/u/cs401/speechdata/Testing/', 'unkn_', int2str(utterance), '.mfcc'];
    data = textread(file);
    data = data(:, 1:14);
    data = data';
    for i=1:num_candidate
        vary = reshape(sum(model{i}.cov), 14, M);
        result(1,i) = ComputeLikelihood(data, model{i}.means, vary, model{i}.weights, M);
    end

    [likelihood, sp_id] = sort(result(1,:),'descend');
    likelihood = likelihood(1, 1:5);
    for s=1:5
        speakers{s} = model{sp_id(s)}.name;
    end

    fileID = fopen(strcat('./', 'unkn_',int2str(utterance),'.lik'), 'w');
    for i=1:5
        fprintf(fileID, '%s  ', speakers{i});
        fprintf(fileID, '%f\n', likelihood(i));
    end
    fclose(fileID);
    
end
