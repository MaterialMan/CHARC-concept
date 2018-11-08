function config = getShape(config)

switch(config.substrate)

    case 'Bucky'
        config.G = graph(bucky);
        config.N = size(config.G.Nodes,1);
        
    case 'L'
        A = delsq(numgrid('L',config.NGrid +2));
        config.G = graph(A,'omitselfloops');
        config.N = size(config.G.Nodes,1);
        
    case 'Hypercube'
        A = hypercube(config.NGrid);
        config.G = graph(A);
        config.N = size(config.G.Nodes,1);
        
    case 'Torus'
        config.G = torusGraph(config.NGrid,config.self_loop,config.N_rings);
        config.N = size(config.G.Nodes,1);
        
    case 'Barbell'
        load barbellgraph.mat
        config.G = graph(A,'omitselfloops');
        config.N = size(config.G.Nodes,1);
        
    case 'Lattice'
        config.G = createLattice(config.NGrid,config.latticeType,config.self_loop,config.num_ensemble);
        config.N = size(config.G.Nodes,1);
        
    otherwise
        error('Requires a substrate shape.')
end
