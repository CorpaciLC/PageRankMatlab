function [q url] = sortByPageRank(myMatrix, tol, indices)    
    ranks = PageRank(myMatrix, tol);
    indices
    n = length(indices);
    for i = 1:n
        q(i) = ranks(indices(i));
    end
    for i = 1:n-1       % sortarea indecsilor in functie de PageRank
        for j = i+1:n
            if q(i) < q(j)
                aux = q(i);
                q(i) = q(j);
                q(j) = aux;
                aux = indices(i);
                indices(i) = indices(j);
                indices(j) = aux;                
            end
        end
    end
    
    n = min(n, 10);
    for i=1:n
        if indices(i) < 10 url{i} = strcat('Page000', num2str(indices(i)));
            else if indices(i) < 100 url{i} = strcat('Page00', num2str(indices(i))); 
                else if indices(i) < 1000 url{i} = strcat('Page0', num2str(indices(i)));
                    else strcat('Page', num2str(indices(i)));
                    end
                end
        end
        url{i} = strcat(url{i}, '.html');
    end
end