function [request_result] = scheduling()
conn = database('location_distances','root','password','Vendor','MySQL','PortNumber',3307);
query = 'select * from requests r1 where r1.processed=0 and r1.time <= ( select addtime( (select r2.time from requests r2 where r2.processed=0 order by r2.time limit 1), ''00:10:00'')) order by r1.time limit 3';
curs = exec(conn,query);
curs = fetch(curs);
[m,~] = size(curs.Data);
str='UMC';
pCount = 0;
pMax = 12;
pCar=int32(4)

if (m == 1)
    str=strcat(str,',',curs.Data{1,3},',',curs.Data{1,4});
    str1 = strsplit(str,',');
    locations = unique(str1);
    locations(:,1) = [];
    strings = char(locations);
    [n,~]=size(strings);
    fprintf('Request is service by car 29842\n');
    [distances] = request_str(strings);
    if size(distances) == [1,1] 
        fprintf('Cost = %f',distances*2);
    else
        mTSP(distances,n,1);
    end
    reqID = curs.Data{1,1};
    uQuery = strcat('update requests set processed =1 where req_ID=',num2str(reqID(1,1)),';');
    uCurs = exec(conn,uQuery);
    
else
%     pQuery = 'select sum(passenger_count) from requests r1 where r1.processed=0 and r1.time <= ( select addtime( (select r2.time from requests r2 where r2.processed=0 order by r2.time limit 1), ''00:10:00'')) order by r1.time limit 3';
%     pCurs = exec(conn,pQuery);
%     pCurs = fetch(pCurs);
%     pCount = cell2mat(pCurs.Data);
    
    for i = 1:m
        pCur = curs.Data{i,5};
        if (pCur+pCount <= pMax)
            str=strcat(str,',',curs.Data{i,3},',',curs.Data{i,4});
            pCount = pCount + pCur;
            reqID = curs.Data{i,1};
            uQuery = strcat('update requests set processed =1 where req_ID=',num2str(reqID(1,1)),';');
            uCurs = exec(conn,uQuery);
        end
    end
    str1 = strsplit(str,',');
    locations = unique(str1);
    locations(:,1) = [];
    strings = char(locations);
    [n,~]=size(strings);
    distances=request_str(strings)
    mTSP(distances,n,idivide(pCount,pCar,'round'));
    
end



