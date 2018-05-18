function [flag] = verifyConstraints(constraints)
flag = 0;
for i = 1:size(constraints)
    if constraints(i) > constraints(i+1)
        flag = 1;
    end
end

