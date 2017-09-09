function xs = test(x0,Function,Jacobian,iters)
    [n,m] = size(Jacobian);
    xs = zeros(n,iters+1);
    xs(:,1) = x0;
    DF = zeros(n,m);
    Fx_k = zeros(m,1);
    for i = 1:1:iters
        for u = 1:1:n
            for v = 1:1:m
                DF(u,v) = Jacobian{u,v}(xs(v,i));
            end
        end
        xk = num2cell(transpose(xs(:,i)));
        for w = 1:1:m
            Fx_k(w,1) = Function{w,1}(xk{:});
        end
        s = linsolve(DF,-1*Fx_k);
        xs(:,i+1) = xs(:,i) + s;
    end
% tbl = zeros(iter,3);
% count = 0;
% tbl(count+1,:)=xs';
% while(iter > count)
%     b = func(xs(1),xs(2),xs(3))
%     A = df(xs(1),xs(2),xs(3))
%     xs = xs + linsolve(A,-1*b);
%     count = count+1;
%     tbl(count+1,:)=xs';
% end
% root = xs;
end