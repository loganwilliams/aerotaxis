function out = toComplex(allSpeeds)
    out = allSpeeds(:,1) .* exp(allSpeeds(:,2) * sqrt(-1));
end