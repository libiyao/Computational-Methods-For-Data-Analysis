function [threshold,w,u,s,v] = digitLDA(digit1,digit2,labels,data)
    indexofd1 = find(labels == digit1);
    indexofd2 = find(labels == digit2);
    [u,s,v] = svd(data,'econ');
    digits = s*v';
    u = u(:,1:50);
    digit1 = digits(1:50,indexofd1);
    digit2 = digits(1:50,indexofd2);
    mean1 = mean(digit1,2);
    mean2 = mean(digit2,2);
    Sw = 0;
    for k = 1:size(indexofd1,2)
        Sw = Sw + (digit1(:,k) - mean1)*(digit1(:,k) - mean1)';
    end
    for k = 1:size(indexofd2,2)
       Sw =  Sw + (digit2(:,k) - mean2)*(digit2(:,k) - mean2)';
    end
    Sb = (mean1-mean2)*(mean1-mean2)';
    [V2, D] = eig(Sb,Sw);
    [lambda, ind] = max(abs(diag(D)));
    w = V2(:,ind);
    w = w/norm(w,2);
    v1 = w'*digit1;
    v2 = w'*digit2;
    if mean(v1) > mean(v2)
        w = -w;
        v1 = -v1;
        v2 = -v2;
    end
    plot(v1,zeros(size(indexofd1,2)),'ob','Linewidth',2)
    hold on
    plot(v2,ones(size(indexofd2,2)),'dr','Linewidth',2)
    ylim([0 1.2])
    title('Plot of the classifer for digit 0 and 9');
    sortd1 = sort(v1);
    sortd2 = sort(v2);
    t1 = length(sortd1);
    t2 = 1;
    while sortd1(t1) > sortd2(t2)
        t1 = t1 - 1;
        t2 = t2 + 1;
    end
    threshold = (sortd1(t1) + sortd2(t2))/2;
end

