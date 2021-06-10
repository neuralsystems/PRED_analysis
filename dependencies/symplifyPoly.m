function [simplifiedPoly] = symplifyPoly(tolerance, poly)


% function [simplifiedPoly] = simplifyPoly(tolerance, poly)
%
% Douglas-Peucker polyline simplification algorithm. Returns an
% approximation of poly such that each point of simplifiedPoly is no more
% than tolerance away from poly.

% Ported to Matlab by Carl Fischer, April 2008
% http://eis.comp.lancs.ac.uk/~carl/
%
% http://geometryalgorithms.com/Archive/algorithm_0205/algorithm_0205.htm
% Copyright 2002, softSurfer (www.softsurfer.com)
% This code may be freely used and modified for any purpose
% providing that this copyright notice is included with it.
% SoftSurfer makes no warranty for this code, and cannot be held
% liable for any real or imagined damage resulting from its use.
% Users of this code must verify correctness for their application.


  
    

% simple vertex reduction: merge vertices that are close
prevVertexIndex = 1;
newPoly = poly(:,1); % start with the first vertex

for i=2:size(poly,2)
    if norm(poly(:,prevVertexIndex)-poly(:,i)) > tolerance
        newPoly = [newPoly poly(:,i)]; % keep this vertex
        prevVertexIndex = i;
    end
end

if prevVertexIndex < size(poly,2)
    newPoly = [newPoly poly(:,size(poly,2))]; % include the last vertex if it wasn't already included
end
  
markedVertices = [1 size(newPoly,2)];
markedVertices = simplifyDP(tolerance, newPoly, 1, size(newPoly,2), markedVertices);

markedVertices = sortrows(markedVertices')';
simplifiedPoly = newPoly(:,markedVertices);


    function [markedVertices] = simplifyDP(tolerance, poly, startIndex, endIndex, markedVertices)
        maxDist = 0;
        maxIndex = startIndex;
        segment = poly(:,[startIndex endIndex]);
        for j = startIndex:endIndex
            distance = pointToSegment(poly(:,j), segment);
            if distance > maxDist
                % Floats and ints will evaluate differently even if they appear
                % the same, eg. 10.0000 is actually slightly smaller than 10.
                % Doesn't matter too much but might explain some unexpected
                % results.
                maxDist = distance;
                maxIndex = j;
            end
        end
        if maxDist > tolerance
            markedVertices = [markedVertices maxIndex];
            markedVertices = simplifyDP(tolerance, poly, startIndex, maxIndex, markedVertices);
            markedVertices = simplifyDP(tolerance, poly, maxIndex, endIndex, markedVertices);
        end
    end

    function [dist] = pointToSegment(point, segment)
        % function [dist] = pointToSegment(point, segment)
        %
        %  Calculate the distance from point to segment. This is either the distance
        %  between point and its projection onto segment, or the distance between
        %  point and one of the extremeties of segment.

        % Ported to Matlab by Carl Fischer, April 2008
        % http://eis.comp.lancs.ac.uk/~carl/
        %
        % http://geometryalgorithms.com/Archive/algorithm_0102/algorithm_0102.htm#dist_Point_to_Segment()
        % Copyright 2001, softSurfer (www.softsurfer.com)
        % This code may be freely used and modified for any purpose
        % providing that this copyright notice is included with it.
        % SoftSurfer makes no warranty for this code, and cannot be held
        % liable for any real or imagined damage resulting from its use.
        % Users of this code must verify correctness for their application.

        u = segment(:,2) - segment(:,1);
        cu = dot(u,u);
        w = point - segment(:,1);
        cw = dot(w,u);
        if cw <= 0  
            dist = norm(point-segment(:,1));
        elseif cu <= cw
            dist = norm(point-segment(:,2));
        else
            b = cw/cu;
            Pb = segment(:,1) + b*u;
            dist = norm(point-Pb);
        end

    end

end