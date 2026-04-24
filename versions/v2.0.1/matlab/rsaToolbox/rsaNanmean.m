function m = rsaNanmean(dataVector)

if isempty(dataVector) % Check for empty input.
    m = NaN;
    return
end

% Replace NaNs with zeros.
nans = isnan(dataVector);
i = find(nans);
dataVector(i) = zeros(size(i));

% Replace Infs with zeros.
infs = isinf(dataVector);
i = find(infs);
dataVector(i) = zeros(size(i));

if min(size(dataVector))==1,
  count = length(dataVector)-sum(nans)-sum(infs);
else
  count = size(dataVector,1)-sum(nans)-sum(infs);
end

% Protect against a column of all NaNs
i = find(count==0);
count(i) = ones(size(i));
m = sum(dataVector)./count;
m(i) = i + NaN;

