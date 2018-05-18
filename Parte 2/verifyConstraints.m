function [flag] = verifyConstraints(constraints, previous, next)
flag = true;
for i = 1:size(constraints,1)
    if ismember(constraints(i,1), next) && ismember(constraints(i,2), previous) ...
            && ~ismember(constraints(i,1), previous)
        flag = false;
        break;
    end
end

