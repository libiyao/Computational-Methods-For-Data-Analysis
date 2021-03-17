%%
close all; clear;
%% Load train data
[images1, labels1] = mnist_parse('train-images.idx3-ubyte', 'train-labels.idx1-ubyte');
data1 = [];
for i = 1:60000
    img = reshape(images1(:,:,i),784,1);
    data1 = [data1, img];
end
data1 = double(data1);
%% Part1: SVD
[u,s,v] = svd(data1,'econ');
digits = s*v';
%% Analysis of the singular values
subplot(2,1,1)
plot(diag(s),'ko','Linewidth',2)
subplot(2,1,2)
semilogy(diag(s),'ko','Linewidth',2)
%% Continue
sig = diag(s);
plot(sig.^2/sum(sig.^2),'ko','Linewidth',2)
%% Part 2: approximations
range = 20:5:90;
for i = 1:15
    rank = range(i);
    approx_1 = u(:,1:rank)*s(1:rank,1:rank)*v(:,1:rank)';
    digit1 = reshape(approx_1(:,1),28,28);
    subplot(3,5,i);
    imshow(digit1)
    title(['Rank = ',num2str(rank)]);
end
%% Part 4
colors = [0, 0.4470, 0.7410;0.8500, 0.3250, 0.0980;0.9290, 0.6940, 0.1250;0.4940, 0.1840, 0.5560;0.4660, 0.6740, 0.1880;0.3010, 0.7450, 0.9330;0.6350, 0.0780, 0.1840;1, 0, 0;0, 0, 1;0.75, 0.75, 0;0.25, 0.25, 0.25];
for label=0:9
    indices = find(labels1 == label);
    plot3(v(indices, 1)', v(indices, 2)', v(indices, 3)', 'o', 'color',colors(label+1,:),'DisplayName', sprintf('%i',label), 'Linewidth', 2)
    hold on
end
xlabel('First V-Mode'), ylabel('Second V-Mode'), zlabel('Third V-Mode')
title('Projection onto V-modes 1, 2, 3')
legend
%% Two digits LDA
index1 = find(labels1 == 0)';
index2 = find(labels1 == 8)';
digit1 = digits(1:50,index1(1:1000));
digit2 = digits(1:50,index2(1:1000));
[threshold, w,u,s,v] = digitLDA(0, 8, labels1, data1);
%% Load test data
[images2, labels2] = mnist_parse('t10k-images.idx3-ubyte', 't10k-labels.idx1-ubyte');
data2 = [];
for i = 1:10000
    img = reshape(images2(:,:,i),784,1);
    data2 = [data2, img];
end
data2 = double(data2);
%% Hard two digits test
[threshold,w,u,s,v] = digitLDA(2,5,labels1,data1);
test2or5 = find(labels2 == 5 | labels2 == 2);
test_digit = u'*data2;
pval = w'*test_digit(:,test2or5);
total = pval > threshold;
successRate = sum(total)/size(total,2);
%% check the accuracy of the train data
test2or5Train = find(labels1 == 2 | labels1 == 5);
test_digit_Train = u'*data1;
pvalTrain = w'*test_digit_Train(:,test2or5Train);
totalTrain = pvalTrain > threshold;
successRateTrain = sum(totalTrain)/size(totalTrain,2);
%% Easy two digits test
[threshold,w,u,s,v] = digitLDA(0,9,labels1,data1);
test0or9 = find(labels2 == 0 | labels2 == 9);
test_digit = u'*data2;
pval = w'*test_digit(:,test0or9);
total2 = pval > threshold;
successRate2 = sum(total2)/size(total2,2);
%% check the accuracy of the train data
test0or9Train = find(labels1 == 0 | labels1 == 9);
test_digit_Train = u'*data1;
pvalTrain = w'*test_digit_Train(:,test0or9Train);
total2Train = pvalTrain > threshold;
successRate2Train = sum(total2Train)/size(total2Train,2);
%% Three digits LDA
index1 = find(labels1 == 3)';
index2 = find(labels1 == 8)';
digit1 = digits(1:50,index1(1:1000));
digit2 = digits(1:50,index2(1:1000));
mean1 = mean(digit1,2);
mean2 = mean(digit2,2);
index3 = find(labels1 == 6)';
digit3 = digits(1:50,index3(1:1000));
mean3 = mean(digit3,2);
overall_mean = (mean1+mean2+mean3) / 3;
Sb = 0;
Sb = (mean1 - overall_mean)*(mean1 - overall_mean)' + (mean2 - overall_mean)*(mean2 - overall_mean)' +(mean3 - overall_mean)*(mean3 - overall_mean)';
for k = 1:100
   Sw =  Sw + (digit3(:,k) - mean3)*(digit3(:,k) - mean3)';
end
[V2, D] = eig(Sb,Sw);
[lambda, ind] = max(abs(diag(D)));
w = V2(:,ind);
w = w/norm(w,2);
v1 = w'*digit1;
v2 = w'*digit2;
v3 = w'*digit3;
% make v2 bigger than v1
if mean(v1) > mean(v2)
    w = -w;
    v1 = -v1;
    v2 = -v2;
end
% make v3 bigger than v2
if mean(v2) > mean(v3)
    w = -w;
    v2 = -v2;
    v3 = -v3;
end
twos = ones(1000)+1;
p1 = plot(v1,zeros(1000),'ob','Linewidth',2);
hold on
p2 = plot(v2,ones(1000),'dr','Linewidth',2);
p3 = plot(v3,twos,'dk','Linewidth',2);
h = [p1(1),p2(1),p3(1)];
legend(h,'digit 3','digit 8', 'digit 6');
ylim([0 3.2])
%%
digits = [1, 2,3,4,5,6,8,14,16,18];
label = labels1';
for i = 1:10
    approx_1 = u(:,1:50)*s(1:50,1:50)*v(:,1:50)';
    digit1 = reshape(approx_1(:,digits(i)),28,28);
    subplot(2,5,i);
    imshow(digit1)
     title(['Digit is ',num2str(label(digits(i)))]);
end
%% Decision tree for all 10 digits
digitsTree = u(:,1:50)'*data1;
tree = fitctree(digitsTree',labels1);
digitsTest1 = u(:,1:50)'*data2;
testlabelTree1 = predict(tree, digitsTest1');
successrateTree1 = sum(testlabelTree1 == labels2)/10000;
%% Decision tree on two easy digits
indexTree1 = find(labels1 == 0 | labels1 == 9);
digitsTree1 = digitsTree(:,indexTree1);
tree1 = fitctree(digitsTree1', labels1(indexTree1));
indexTestTree1 = find(labels2 == 0 | labels2 == 9);
digitsTest2 = digitsTest1(:,indexTestTree1);
testlabelTree2 = predict(tree1, digitsTest2');
successrateTree2 = sum(testlabelTree2 == labels2(indexTestTree1))/1989;
%% Decision tree on two difficult digits
indexTree2 = find(labels1 == 2 | labels1 == 5);
digitsTree2 = digitsTree(:,indexTree2);
tree2 = fitctree(digitsTree2', labels1(indexTree2));
indexTestTree2 = find(labels2 == 2 | labels2 == 5);
digitsTest3 = digitsTest1(:,indexTestTree2);
testlabelTree3 = predict(tree2, digitsTest3');
successrateTree3 = sum(testlabelTree3 == labels2(indexTestTree2))/1924;
%% SVM classifier with training data, labels and test set
[u,s,v] = svd(data1,'econ');
digits = u(:,1:50)'*data1;
digits = digits ./ max(digits(:));
Mdl1 = fitcecoc(digits',labels1);
testdigits1 = u(:,1:50)'*data2;
testlabel1 = predict(Mdl1, testdigits1');
successrate = sum(testlabel1 == labels2)/10000;
%% SVM for two difficult digits
index = find(labels1 == 2 | labels1 == 5);
digitsfor2and5 = digits(:,index);
Mdl2 = fitcsvm(digitsfor2and5', labels1(index));
index2 = find(labels2 == 2 | labels2 == 5);
testdigits2 = testdigits1(:, index2);
testlabel2 = predict(Mdl2, testdigits2');
successrate2 = sum(testlabel2 == labels2(index2))/1924;
%% SVM for two easy digits
index = find(labels1 == 0 | labels1 == 9);
digitsfor0and9 = digits(:,index);
Mdl3 = fitcsvm(digitsfor0and9', labels1(index));
index2 = find(labels2 == 0 | labels2 == 9);
testdigits3 = testdigits1(:, index2);
testlabel3 = predict(Mdl3, testdigits3');
successrate3 = sum(testlabel3 == labels2(index2))/1989;