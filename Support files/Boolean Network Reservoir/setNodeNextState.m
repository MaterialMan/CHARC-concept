function nodeUpdated = setNodeNextState(node)

% SETNODENEXTSTATE Look up next state for each node and update "nextState" field of the NODE
% structure-array. Make sure that assocRules() has been called on NODE before using this function.  
%
%   SETNODENEXTSTATE(NODE) returns the updated node structure-array containing 
%   next-state information for each node.
%   Next state information is stored in the "nextState" field of the NODE structure-array.
%
%   Input:
%       node               -  1 x n structure-array containing node information
%       
%   Output: 
%       nodeUpdated        -  1 x n structure-array containing updated node information         
%
%

%   Author: Christian Schwarzer - SSC EPFL
%   CreationDate: 13.11.2002 LastModified: 20.01.2003

if(nargin == 1)
    nodeUpdated = node;
    for i=1:length(node)
        nodeUpdated(i).nextState = nodeUpdated(i).rule(nodeUpdated(i).lineNumber,1);
        if(isempty(nodeUpdated(i).nextState))
            nodeUpdated(i).nextState = nodeUpdated(i).state;
        end
    end
else
 error('Wrong number of arguments. Type: help setNodeNextState')    
end
