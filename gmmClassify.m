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
        vary = reshape(sum(model{i}.cov), 14, 8);
        result(1,i) = ComputeLikelihood(data, model{i}.means, vary, model{i}.weights, M);
    end

    [likelihood, sp_id] = sort(result(1,:),'descend');
    likelihood = likelihood(1, 1:5);
    for s=1:5
        speakers{s} = model{sp_id(s)}.name;
    end
    disp(likelihood)

   fileID = fopen(strcat('./', 'unkn_',int2str(utterance),'.lik'), 'w');
   for i=1:5
       fprintf(fileID, '%s  ', speakers{i});
       fprintf(fileID, '%f\n', likelihood(i));
   end
   fclose(fileID);
    
end
    
    
    
    
    
function [L, pm_x] = ComputeLikelihood(data, mu, vary, weight, M)
[d, t] = size(data);
bm_x = zeros(M,t);
nomi = zeros(M, t);
deno = zeros(1, M);

% calculate denominator
for i=1:M
    sigma = vary(:,i);
    deno(i) = (2*pi)^(d/2) * (prod(sigma))^0.5;
end

%calculate p(x|z)
for i = 1:M
    for j=1:t
        a = sum(((data(:,j)-mu(:,i)).^2)./vary(:,i));
        nomi(i,j) = exp(-0.5 * a);
    end
    bm_x(i,:)=nomi(i,:)/deno(i);
end

wbm=zeros(M,t);
for i=1:M
    wbm(i,:) = weight(i) * bm_x(i,:);
end

%calculate p(z)
pm_x = bsxfun(@rdivide, wbm, sum(wbm));

% p(x) = sum p(z)p(x|z)
px = bm_x .* pm_x;
px = sum(px);

logpx = log(px);
L = sum(logpx);
    