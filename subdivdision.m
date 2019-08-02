function [x, t] = subdivdision(x, t, nsub, offset)

if nargin<4
    offset = 0;
end


xiscell = iscell(x);

for i=1:nsub
%     x = [x; ( x(t,:) + x(t(:,[2 3 1]),:) )/2];
%     t = delaunay(x);

    if xiscell
        nv = size(x{1}, 1);
    else
        nv = size(x, 1);
    end
    
    % index from vertex pair to edges
    e = unique( sort( [reshape(t, [], 1), reshape(t(:,[2 3 1]), [], 1)], 2 ), 'rows' );
    ne = size(e, 1);

    % compute edge id based on the 2 vertex indices
    VV2E = sparse( e, e(:, [2 1]), [1:ne; 1:ne]', nv, nv );

    wts = ones(ne, 1)*[1 1];
    wts = wts + (rand(ne, 2)-0.5)*offset;
    wts = wts ./ repmat(sum(wts,2), 1, 2);
    
    MV2E = sparse( [1:ne 1:ne], e, wts, ne, nv );  % matrix transfrom vertices to edge vectors

    if xiscell
        x = cellfun( @(y) [y; MV2E*y], x, 'UniformOutput', false );
    else
        x(end+1:end+ne, :) = MV2E*x;
    end

    vext = nv + VV2E( sub2ind([nv nv], t(:,[2 3 1]), t(:,[3 1 2])) );
    t2 = [t(:,1) vext(:, [3 2]); t(:,2) vext(:, [1 3]); t(:,3) vext(:,[2 1]); vext];
    
    t = t2;
end