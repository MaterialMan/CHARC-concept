function [nodeUpdated, timeStateMatrix] = evolveARBN(node, varargin)

% EVOLVEARBN Develop network gradually K discrete time-steps according to ARBN (Asynchronous
% Random Boolean Network) update scheme.
%
%   EVOLVEARBN(NODE) advances all nodes in NODE one time-step in ARBN update mode.
%   
%   EVOLVEARBN(NODE, K) advances all nodes in NODE K time-steps in ARBN update mode.
%
%   EVOLVEARBN(NODE, K, TK) advances all nodes in NODE K time-steps in ARBN update mode
%   and saves all TK steps all node-states and the timeStateMatrix to the disk.
% 
%   Input:
%       node               - 1 x n structure-array containing node information
%       k                  - (Optional) Number of time-steps
%       tk                 - (Optional) Period for saving node-states/timeStateMatrix to disk.
%
%
%   Output: 
%       nodeUpdated        - 1 x n sturcture-array with updated node information
%                            ("lineNumber", "state", "nextState")                           
%       timeStateMatrix    - n x k+1 matrix containing calculated time-state evolution                                        



%   Author: Christian Schwarzer - SSC EPFL
%   CreationDate: 20.11.2002 LastModified: 20.01.2003

k = varargin{1};
inputSequence = varargin{2};
genotype = varargin{3};


nodeUpdated = resetNodeStats(node);
timeStateMatrix = zeros(length(nodeUpdated), k+1);
timeStateMatrix(1:length(nodeUpdated),1) = getStateVector(nodeUpdated)';

n = length(nodeUpdated);

% evolve network
for i=2:k+1
    
    nodeSelected = randi([1 n],1,1);
    
     % Apply input (somehow)
    for j = 1:length(node)
        if genotype.input_loc(j)
            nodeUpdated(j).state = inputSequence(i-1,j);
            nodeUpdated(j).nextState = inputSequence(i,j);
        end
    end
    
    nodeUpdated = setLUTLines(nodeUpdated);
    nodeUpdated = setNodeNextState(nodeUpdated);
    
    nodeUpdated(nodeSelected).state = nodeUpdated(nodeSelected).nextState;
    nodeUpdated(nodeSelected).nbUpdates = nodeUpdated(nodeSelected).nbUpdates + 1;
    
    timeStateMatrix(1:length(nodeUpdated),i) = getStateVector(nodeUpdated)';
    
    if(mod(i-1,tk) == 0)
        saveMatrix(nodeUpdated);
        saveMatrix(timeStateMatrix(:,1:i));
        i-1;  % display current time-step for user information
    end
    
end
