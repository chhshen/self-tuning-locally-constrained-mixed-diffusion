function [precision,corrects] = precisionBulleye(K,size_classes,num_train)

if exist('num_train','var') && num_train>0 && num_train<min(size_classes)
    training = true;
else
    training = false;
end


num_objects = sum(size_classes);
num_classes = length(size_classes);

if ~training
    N = size_classes(1);
    precision = zeros(1,2*N);
    [maxD,INDEX] = sort(K,2,'descend');
    I_class =  1;       
    class_start = 1;    
    class_end = size_classes(1); 
    corrects = cell(num_classes,1);
    for i = 1: num_classes
        corrects{i} = zeros(2*N,1);
    end
    for i = 1:num_objects
        if i > class_end
            class_start = class_end + 1;
            I_class = I_class+1;
            class_end = class_end + size_classes(I_class);
        end
        for j = 1:2*N
            if INDEX(i,j) >= class_start && INDEX(i,j) <= class_end
                corrects{I_class}(j:end) = corrects{I_class}(j:end)+1;
            end
        end
    end
    corrects_rank = zeros(2*N,1);
    for i = 1:num_classes
        corrects_rank = corrects_rank + corrects{i};
    end
    precision(1:N) = corrects_rank(1:N)'./(num_objects*[1:N]);
    precision(N+1:end) = corrects_rank(N+1:end)'./(num_objects*N);
else
    N = num_train;
    precision = zeros(1,2*N);
    newK = zeros(num_objects-num_train*num_classes,num_train*num_classes);
    for i1 = 1:num_classes
        class_start = sum(size_classes(1:i1-1))+1;
        class_end = sum(size_classes(1:i1));
        new_class_start = class_start - num_train*(i1-1);
        new_class_end = class_end - num_train*i1;
        for i2 = 1:num_classes
            newK(new_class_start:new_class_end,num_train*(i2-1)+[1:num_train])=...
                K(class_start+num_train:class_end,sum(size_classes(1:i2-1))+[1:num_train]);
        end
    end
    [maxD,INDEX] = sort(newK,2,'descend');
    corrects = cell(num_classes,1);
    I_class =  1;       
    class_start = 1;    
    class_end = size_classes(1) - num_train; 
    for i = 1: num_classes
        corrects{i} = zeros(2*N,1);
    end
    for i = 1:num_objects-num_train*num_classes
        if i > class_end
            class_start = class_end + 1;
            I_class = I_class+1;
            class_end = class_end + size_classes(I_class) - num_train;
        end
        for j = 1:2*N
            if INDEX(i,j) > num_train*(I_class-1) && INDEX(i,j) <= num_train*I_class
                corrects{I_class}(j:end) = corrects{I_class}(j:end)+1;
            end
        end
    end 
    corrects_rank = zeros(2*N,1);
    for i = 1:num_classes
        corrects_rank = corrects_rank + corrects{i};
    end
    num_objectsTotal = num_objects-num_train*num_classes;
    precision(1:N) = corrects_rank(1:N)'./(num_objectsTotal*[1:N]);
    precision(N+1:end) = corrects_rank(N+1:end)'./(num_objectsTotal*N);
end