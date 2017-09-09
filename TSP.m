function [Path] = TSP(dist,nStops)

dist1 = zeros(nStops,1);
dist = [dist;dist1];
idxs = nchoosek(1:nStops,2);
Aeq = ones(1,length(idxs));
Aeq = [Aeq, zeros(1,nStops)];
beq = nStops;
Aeq = [Aeq;zeros(nStops,(length(idxs)+nStops))];
for ii = 1:nStops
    whichIdxs = (idxs == ii); % find the trips that include stop ii
    whichIdxs = sum(whichIdxs,2); % include trips where ii is at either end
    Aeq(ii+1,:) = [whichIdxs',zeros(1,nStops)]; % include in the constraint matrix
end
beq = [beq; 2*ones(nStops,1)];

A = diag((nStops*ones(1,length(idxs))));
A1 = zeros(length(idxs),nStops);
for i = 1:length(idxs)
    A1(i,idxs(i,1)) = 1;
    A1(i,idxs(i,2)) = -1;
end
A = [A,A1];
b = nStops * ones(length(idxs),1);

intcon = 1:(length(idxs)+ nStops);
lb = [zeros(length(idxs),1);ones((nStops),1)];
ub = [ones(length(idxs),1);((nStops-1)*ones((nStops),1))];
x = intlinprog(dist,intcon,A,b,Aeq,beq,lb,ub)
Path = x(1:length(idxs),:)

end


