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

%calculate p(x|z)new_frank
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