function [TSPPath,idxs] = mTSP(dist,nStops,nCars,pickups,destinations)

dist1 = zeros(nStops,1);
dist = [dist;dist1];
idxs = nchoosek(1:nStops,2);
% Aeq = ones(1,length(idxs));
% Aeq = [Aeq, zeros(1,nStops)];
% beq = nStops;
Aeq = zeros(nStops+1,(length(idxs)+nStops));

% whichIdxs = (idxs == 1); % find the trips that include stop ii
% whichIdxs = sum(whichIdxs,2); % include trips where ii is at either end
% Aeq(1+1,:) = [whichIdxs',zeros(1,nStops)]

% beq = 10

for ii = 1:size(idxs,1)
    srcIdxs(ii,1) = ((idxs(ii,1) == 1) && any(idxs(ii,2)==pickups))
    srcIdxs(ii,2) = -1 *((idxs(ii,1) == 1) && all(idxs(ii,2)~=pickups))
end

Aeq = [(srcIdxs(1,:) - srcIdxs(1,:))',zeros(2,nStops)]

% for ii = 2:nStops
%     whichIdxs = (idxs == ii); % find the trips that include stop ii
%     whichIdxs = sum(whichIdxs,2); % include trips where ii is at either end
%     Aeq(ii+1,:) = [whichIdxs',zeros(1,nStops)]; % include in the constraint matrix
% end

for ii = 2:nStops
    if any(find(pickups == ii))
        for jj = 1:size(idxs,1)
            whichIdxs(jj,1) = (((idxs(jj,1) == ii) && (idxs(jj,2)==1 || any(idxs(jj,2)==destinations(find(pickups==ii),:)) || any(idxs(jj,2) == pickups))) || ((idxs(jj,2) == ii) && (idxs(jj,1)==1 || any(idxs(jj,1)==destinations((find(pickups == ii)),:)) || any(idxs(jj,1) == pickups))));
        end
        Aeq(ii,:) = [whichIdxs',zeros(1,nStops)];
    else
        whichIdxs = (idxs == ii);
        whichIdxs = sum(whichIdxs,2);
        Aeq(ii,:) = [whichIdxs',zeros(1,nStops)];
    end
end

beq = [0;2*ones(nStops-1,1)];

A = diag((nStops*ones(1,(length(idxs)))));
% A(1:nStops-1,:) = [];
A(1,:) = [];
A1 = zeros((length(idxs)-1),nStops);
for i = 2:length(idxs)
    A1(i-1,idxs(i,1)) = 1;
    A1(i-1,idxs(i,2)) = -1;
end
A = [srcIdxs;-1*srcIdxs;A,A1];
b = [double(nCars); double(nCars);-1;-1;nStops * ones((length(idxs)-1),1)];

intcon = 1:(length(idxs)+ nStops);
lb = [zeros(length(idxs),1);ones((nStops),1)];
ub = [ones(length(idxs),1);((nStops-1)*ones((nStops),1))];
x = intlinprog(dist,intcon,A,b,Aeq,beq,lb,ub)
if not(isempty(x))
    TSPPath = x(1:length(idxs),:)
else
    TSPPath = 0
end

end


