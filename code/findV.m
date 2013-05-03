plot(tempCent(:,1),tempCent(:,2))
v=sqrt(diff(tempCent(:,1)).^2 + diff(tempCent(:,2)).^2);
figure
plot(v)
theta=atan(diff(tempCent(:,1))./diff(tempCent(:,2)));
figure
plot(theta)