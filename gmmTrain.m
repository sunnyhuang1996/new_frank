function gmms = gmmTrain( dir_train, max_iter, epsilon, M )
% gmmTain
%
%  inputs:  dir_train  : a string pointing to the high-level
%                        directory containing each speaker directory
%           max_iter   : maximum number of training iterations (integer)
%           epsilon    : minimum improvement for iteration (float)
%           M          : number of Gaussians/mixture (integer)
%
%  output:  gmms       : a 1xN cell array. The i^th element is a structure
%                        with this structure:
%                            gmm.name    : string - the name of the speaker
%                            gmm.weights : 1xM vector of GMM weights
%                            gmm.means   : DxM matrix of means (each column 
%                                          is a vector
%                            gmm.cov     : DxDxM matrix of covariances. 
%                                          (:,:,i) is for i^th mixture

D = 14;
gmms = {};
speakers_list = dir(dir_train);
speakers_list = speakers_list(3:length(speakers_list));
for s_i = 1:length(speakers_list)
    name = speakers_list(s_i).name;
    gmms{s_i} = struct();
    gmms{s_i}.name = name;

    %get into dir of name
    mfcc_files = dir([dir_train, '/', name, '/', '*.mfcc']);
    %read data
    data = [];
    for f = 1:length(mfcc_files)
        file = [dir_train, '/', name, '/', mfcc_files(f).name];
        data = [data; textread(file)];
    end
    data = data(:, 1:D);
    data = data.';   %D*t
    
    %initalize 
    randConst = 1;
    weight = randConst +rand(M,1);
    weight = weight/sum(weight);

    mu = zeros(D,M);
    for q=1:M
        mu(:,q) = data(:, ceil(2726/M*q));
    end
    vary = ones(D, M);

    i = 0;
    prev_L = -Inf;
    improvement = Inf;
    while i<=max_iter && improvement>=epsilon
        [L, pm_x] = ComputeLikelihood(data, mu, vary, weight, M);
        [weight, mu, vary] = UpdateParameters(data, pm_x);
        improvement = L-prev_L;
        i = i+1;
    end
    
    gmms{s_i}.weights = weight;
    gmms{s_i}.means = mu;
    gmms{s_i}.cov = zeros(D, D, M);

    for i=1:M
        sigma = diag(vary(:, i));
        gmms{s_i}.cov(:,:,i) = sigma;
    end
end


function [weight, mu, vary] = UpdateParameters(data, pm_x)
data = data';
T = size(data,1);
common_sum = sum(pm_x,2)';
weight = common_sum/T;
mu = bsxfun(@rdivide, (pm_x * data)', common_sum);
vary = bsxfun(@rdivide, (pm_x * (data.^2)).', common_sum) - mu.^2;


%dir_train = '/u/cs401/speechdata/Training';
        