if (world instanceof ServerWorld) {
    IWorld _worldorig = world;

	world = ((ServerWorld) world).getServer().getWorld(${generator.map(field$dimension, "dimensions")});

    if (world != null) {
        ${statement$worldstatements}
    }

    world = _worldorig;
}
