
function config = selectReservoirType(config)

switch(config.resType)
    case 'RoR' 
        config.createFcn = @createRoR;
        config.assessFcn = @collectDeepStates_nonIA;
        config.mutFcn = @mutateRoR;
        config.recFcn = @recombRoR;
        
    case 'RoR_IA'
        config.createFcn = @createRoR;
        config.assessFcn = @collectDeepStates_IA;
        config.mutFcn = @mutateRoR;
        config.recFcn = @recombRoR;
        
    case 'Pipeline'
        config.createFcn = @createDeepReservoir_pipeline;
        config.assessFcn = @collectDeepStates_pipeline;
        config.mutFcn = @mutateRoR;
        config.recFcn = @recombRoR;
         
    case 'Pipeline_IA'
        config.createFcn = @createDeepReservoir_pipeline;
        config.assessFcn = @collectDeepStates_pipeline_IA;
        config.mutFcn = @mutateRoR;
        config.recFcn = @recombRoR;
        
    case 'Ensemble'
        config.createFcn = @createDeepReservoir_ensemble;
        config.assessFcn = @collectEnsembleStates;
        config.mutFcn = @mutateRoR;
        config.recFcn = @recombRoR;
        
    case 'Graph'
        config.createFcn = @createGraphReservoir;
        config.assessFcn = @assessGraphReservoir;
        config.mutFcn = @mutateGraph;
        config.recFcn = @recombGraph;
        
    case 'BZ'
        config.createFcn = @createBZReservoir;
        config.assessFcn = @assessBZReservoir;
        config.mutFcn = @mutateBZ;
        config.recFcn = @recombBZ;
end

config.testFcn = @testReservoir; % default for all